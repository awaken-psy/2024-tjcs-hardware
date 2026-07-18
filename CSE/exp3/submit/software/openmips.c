#include "includes.h"

#define BOTH_EMPTY (UART_LS_TEMT | UART_LS_THRE)


#define WAIT_FOR_XMITR \
        do { \
                lsr = REG8(UART_BASE + UART_LS_REG); \
        } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)

#define WAIT_FOR_THRE \
        do { \
                lsr = REG8(UART_BASE + UART_LS_REG); \
        } while ((lsr & UART_LS_THRE) != UART_LS_THRE)

#define TASK_STK_SIZE 256

OS_STK TaskStartStk[TASK_STK_SIZE];


void uart_init(void)
{
        INT32U divisor;

         /* Set baud rate */

        divisor = (INT32U) IN_CLK/(16 * UART_BAUD_RATE);

        REG8(UART_BASE + UART_LC_REG) = 0x80;
        REG8(UART_BASE + UART_DLB1_REG) = divisor & 0x000000ff;
        REG8(UART_BASE + UART_DLB2_REG) = (divisor >> 8) & 0x000000ff;
        REG8(UART_BASE + UART_LC_REG) = 0x00;


        /* Disable all interrupts */

        REG8(UART_BASE + UART_IE_REG) = 0x00;


        /* Set 8 bit char, 1 stop bit, no parity */

       REG8(UART_BASE + UART_LC_REG) = UART_LC_WLEN8 | (UART_LC_ONE_STOP | UART_LC_NO_PARITY);


        uart_print_str("UART initialize done ! \n");
	return;
}

void uart_putc(char c)
{
        unsigned char lsr;
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TH_REG) = c;
        if(c == '\n') {
          WAIT_FOR_THRE;
          REG8(UART_BASE + UART_TH_REG) = '\r';
        }
        WAIT_FOR_XMITR;

}

/* 发送原始字节，不做 '\n'->'\r\n' 转换，用于二进制协议帧 */
void uart_putc_raw(char c)
{
        unsigned char lsr;
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TH_REG) = c;
        WAIT_FOR_XMITR;
}

void uart_print_str(char* str)
{
       INT32U i=0;
       OS_CPU_SR cpu_sr;
       OS_ENTER_CRITICAL()

       while(str[i]!=0)
       {
		i++;
       	uart_putc(str[i-1]);
       }

       OS_EXIT_CRITICAL()

}

void gpio_init()
{
	REG32(GPIO_BASE + GPIO_OE_REG) = 0xffffffff;
	REG32(GPIO_BASE + GPIO_INTE_REG) = 0x00000000;
	gpio_out(0x00000000);
	uart_print_str("GPIO initialize done ! \n");
        return;
}

void gpio_out(INT32U number)
{
	  REG32(GPIO_BASE + GPIO_OUT_REG) = number;
}

INT32U gpio_in()
{
	INT32U temp = 0;
	temp = REG32(GPIO_BASE + GPIO_IN_REG);
	return temp;
}

/* 设置 CP0 Count/Compare/Status，启动 100Hz 时钟节拍 */
void OSInitTick(void)
{
    INT32U compare = (INT32U)(IN_CLK / OS_TICKS_PER_SEC);

    asm volatile("mtc0   %0,$9"   : :"r"(0x0));
    asm volatile("mtc0   %0,$11"   : :"r"(compare));
    asm volatile("mtc0   %0,$12"   : :"r"(0x10000401));

    return;
}

/*========================================================================
 *  贪吃蛇游戏 (exp3 应用开发实验)
 *
 *  游戏逻辑在本任务（μC/OS-II TaskStart）中运行，状态通过 UART 以固定
 *  41 字节二进制帧发给 PC 的 pygame 显示。方向由开发板按钮控制：
 *    gpio_in bit0 = BTNC(中/开始)  bit1 = BTNU(上)  bit2 = BTNR(右)
 *    bit3 = BTND(下)  bit4 = BTLN(左)
 *========================================================================*/

#define GW          16              /* 网格 16x16 */
#define MAXLEN      (GW*GW)         /* 蛇最大长度 */
#define SPEED       20              /* OSTimeDly 节拍：20 = 200ms/格 ≈ 5 格/秒（速度减半） */
#define INIT_LEN    3               /* 初始蛇长 */

/* 方向 */
#define DIR_UP      0
#define DIR_RIGHT   1
#define DIR_DOWN    2
#define DIR_LEFT    3

/* 游戏状态 (同时作为协议帧的 state 字段) */
#define ST_READY    3               /* 等待开始 */
#define ST_RUNNING  0               /* 运行中 */
#define ST_OVER     1               /* Game Over */
#define ST_WIN      2               /* 通关 */

/* 按钮 */
#define BTN_CENTER  0x01
#define BTN_UP      0x02
#define BTN_RIGHT   0x04
#define BTN_DOWN    0x08
#define BTN_LEFT    0x10

/* 协议帧：41 字节
 * [0,1]=0xAA 0x55 头, [2]=state, [3,4]=score(LE), [5]=food(x<<4|y),
 * [6]=head(x<<4|y), [7]=length, [8..39]=16x16 位图(蛇身=1),
 * [40]=checksum (bytes[2..39] 的 XOR)
 */
#define FR_HEAD0    0xAA
#define FR_HEAD1    0x55
#define FR_LEN      41

/* 游戏状态（文件级静态，避免占用任务栈；蛇身 2KB 放不下 1KB 栈） */
static int sx[MAXLEN], sy[MAXLEN];  /* 蛇身坐标，下标 0 为头 */
static int len;
static int dir;
static int fx, fy;                  /* 食物坐标 */
static int score;
static int state;                   /* ST_* */
static unsigned int rng_seed;       /* 随机种子 */

/* 简单 LCG 伪随机，取 4 位 */
static int rand4(void)
{
    rng_seed = rng_seed * 1103515245u + 12345u;
    return (int)((rng_seed >> 16) & 0xF);
}

/* 坐标 (x,y) 是否在蛇身上 */
static int hit_snake(int x, int y)
{
    int i;
    for (i = 0; i < len; i++) {
        if (sx[i] == x && sy[i] == y) return 1;
    }
    return 0;
}

/* 在空格上放置食物 */
static void place_food(void)
{
    int tries = 0;
    do {
        fx = rand4();
        fy = rand4();
        if (!hit_snake(fx, fy)) return;
        tries++;
    } while (tries < 256);
}

/* 初始化一局 */
static void snake_init(void)
{
    int cx = GW / 2, cy = GW / 2;
    sx[0] = cx;     sy[0] = cy;
    sx[1] = cx - 1; sy[1] = cy;
    sx[2] = cx - 2; sy[2] = cy;
    len = INIT_LEN;
    dir = DIR_RIGHT;
    score = 0;
    state = ST_READY;
    rng_seed = (unsigned int)OSTimeGet();
    if (rng_seed == 0) rng_seed = 0x12345678u;
    place_food();
}

/* 前进一格：处理吃食/增长、撞墙/撞自身判定，更新 state */
static void step_snake(void)
{
    int nx = sx[0], ny = sy[0];
    int i;

    if (dir == DIR_UP)         ny--;
    else if (dir == DIR_DOWN)  ny++;
    else if (dir == DIR_LEFT)  nx--;
    else                        nx++;   /* DIR_RIGHT */

    /* 回环边界：从一侧出去，从对侧回来（不 Game Over） */
    if (nx < 0) nx = GW - 1;
    else if (nx >= GW) nx = 0;
    if (ny < 0) ny = GW - 1;
    else if (ny >= GW) ny = 0;

    /* 撞自身（除尾节，普通前进时尾会让位） */
    for (i = 0; i < len - 1; i++) {
        if (sx[i] == nx && sy[i] == ny) { state = ST_OVER; return; }
    }

    if (nx == fx && ny == fy) {
        /* 吃到食物：整体后移一格并增长 len */
        for (i = len; i > 0; i--) { sx[i] = sx[i-1]; sy[i] = sy[i-1]; }
        sx[0] = nx; sy[0] = ny;
        len++;
        score++;
        if (len >= MAXLEN) { state = ST_WIN; return; }
        place_food();
    } else {
        /* 普通前进：尾到头整体后移一格，更新头 */
        for (i = len - 1; i > 0; i--) { sx[i] = sx[i-1]; sy[i] = sy[i-1]; }
        sx[0] = nx; sy[0] = ny;
    }
}

static unsigned char xor_checksum(unsigned char *buf, int n)
{
    unsigned char c = 0;
    int i;
    for (i = 0; i < n; i++) c ^= buf[i];
    return c;
}

/* 打包并发送一帧游戏状态 */
static void send_frame(void)
{
    unsigned char fr[FR_LEN];
    int i, idx;

    /* 同步分数到数码管：gpio_o[31:16] = score（seg7x16 显示） */
    gpio_out((INT32U)score << 16);

    fr[0] = FR_HEAD0;
    fr[1] = FR_HEAD1;
    fr[2] = (unsigned char)state;
    fr[3] = (unsigned char)(score & 0xFF);
    fr[4] = (unsigned char)((score >> 8) & 0xFF);
    fr[5] = (unsigned char)(((fx & 0xF) << 4) | (fy & 0xF));
    fr[6] = (unsigned char)(((sx[0] & 0xF) << 4) | (sy[0] & 0xF));
    fr[7] = (unsigned char)len;

    /* 16x16 位图：蛇身格置 1，行优先，每字节高位在前 */
    for (i = 0; i < 32; i++) fr[8 + i] = 0;
    for (i = 0; i < len; i++) {
        idx = sy[i] * GW + sx[i];
        fr[8 + (idx >> 3)] |= (unsigned char)(1 << (7 - (idx & 7)));
    }

    fr[40] = xor_checksum(&fr[2], 38);

    for (i = 0; i < FR_LEN; i++) uart_putc_raw((char)fr[i]);
}

void TaskStart(void *pdata)
{
    OSInitTick();
    snake_init();

    while (1) {
        if (state == ST_RUNNING) {
            INT32U b = gpio_in();
            /* 读方向按钮，禁止 180° 反向 */
            if ((b & BTN_UP)    && dir != DIR_DOWN)  dir = DIR_UP;
            else if ((b & BTN_DOWN)  && dir != DIR_UP)    dir = DIR_DOWN;
            else if ((b & BTN_LEFT)  && dir != DIR_RIGHT) dir = DIR_LEFT;
            else if ((b & BTN_RIGHT) && dir != DIR_LEFT)  dir = DIR_RIGHT;

            step_snake();
            send_frame();
        } else {
            /* READY / OVER / WIN：持续发帧让 PC 显示画面，按中键开始/重开 */
            send_frame();
            if (gpio_in() & BTN_CENTER) {
                snake_init();
                state = ST_RUNNING;
                OSTimeDly(15);          /* 简易消抖 */
            }
        }
        OSTimeDly(SPEED);
    }
}

void main()
{
  OSInit();

  uart_init();

  gpio_init();

  OSTaskCreate(TaskStart,
	       (void *)0,
	       &TaskStartStk[TASK_STK_SIZE - 1],
	       0);

  OSStart();

}
