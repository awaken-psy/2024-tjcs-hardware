#!/usr/bin/env python3
"""贪吃蛇 PC 端图形界面：串口接收 FPGA 发来的状态帧，pygame 渲染画面。
用法: python snake_gui.py [COM口]   (默认 COM3)

操作：开发板按钮控制方向（上/下/左/右），中键开始/重开。ESC 退出。
协议见 debug_rx.py 注释。
"""
import serial, sys, threading, queue, pygame

FR_LEN = 41
HEAD = bytes([0xAA, 0x55])
GRID = 16
CELL = 32
TOP = 56
WIDTH = GRID * CELL
HEIGHT = GRID * CELL + TOP
STATE_NAME = {0: "RUNNING", 1: "GAME OVER", 2: "YOU WIN!", 3: "READY - press CENTER"}


def parse(frame):
    chk = 0
    for b in frame[2:40]:
        chk ^= b
    if chk != frame[40]:
        return None
    state = frame[2]
    score = frame[3] | (frame[4] << 8)
    fx, fy = frame[5] >> 4, frame[5] & 0xF
    hx, hy = frame[6] >> 4, frame[6] & 0xF
    length = frame[7]
    return state, score, fx, fy, hx, hy, length, bytes(frame[8:40])


def reader(ser, q):
    buf = bytearray()
    while True:
        try:
            data = ser.read(64)
        except Exception:
            break
        if not data:
            continue
        buf.extend(data)
        while True:
            i = buf.find(HEAD)
            if i < 0:
                if len(buf) >= 2:
                    del buf[:-1]
                break
            if len(buf) - i >= FR_LEN:
                frame = bytes(buf[i:i + FR_LEN])
                del buf[:i + FR_LEN]
                res = parse(frame)
                if res:
                    q.put(res)
            else:
                del buf[:i]
                break


def main():
    port = sys.argv[1] if len(sys.argv) > 1 else "COM3"
    try:
        ser = serial.Serial(port, 4800, timeout=0.1)
    except Exception as e:
        print(f"无法打开串口 {port}: {e}")
        sys.exit(1)

    q = queue.Queue()
    threading.Thread(target=reader, args=(ser, q), daemon=True).start()

    pygame.init()
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    pygame.display.set_caption("OpenMIPS Snake")
    clock = pygame.time.Clock()
    font = pygame.font.SysFont("consolas", 24)

    # 初始空画面
    state, score, length = 3, 0, 3
    fx = fy = hx = hy = 0
    bitmap = bytes(32)

    running = True
    while running:
        for e in pygame.event.get():
            if e.type == pygame.QUIT:
                running = False
            elif e.type == pygame.KEYDOWN and e.key == pygame.K_ESCAPE:
                running = False
        try:
            while True:
                state, score, fx, fy, hx, hy, length, bitmap = q.get_nowait()
        except queue.Empty:
            pass

        screen.fill((15, 15, 20))

        # 顶栏
        name = STATE_NAME.get(state, "?")
        col = (120, 200, 255) if state == 0 else (255, 180, 80)
        txt = font.render(f"Score {score:>4}   Len {length:>3}   {name}", True, col)
        screen.blit(txt, (12, 16))

        # 网格 + 蛇身 + 食物
        for y in range(GRID):
            for x in range(GRID):
                rect = pygame.Rect(x * CELL, TOP + y * CELL, CELL, CELL)
                idx = y * GRID + x
                bit = (bitmap[idx >> 3] >> (7 - (idx & 7))) & 1
                if bit:
                    color = (90, 255, 90) if (x == hx and y == hy) else (40, 170, 40)
                    pygame.draw.rect(screen, color, rect)
                pygame.draw.rect(screen, (40, 40, 50), rect, 1)
        # 食物(画在蛇身上层)
        food_rect = pygame.Rect(fx * CELL + 4, TOP + fy * CELL + 4, CELL - 8, CELL - 8)
        pygame.draw.rect(screen, (230, 60, 60), food_rect, border_radius=4)

        pygame.display.flip()
        clock.tick(30)

    pygame.quit()


if __name__ == "__main__":
    main()
