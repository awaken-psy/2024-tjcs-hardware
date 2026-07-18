# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

`exp3` 是一门计算机组成原理课程 FPGA 实验系列的第三个实验，使用 **Xilinx Vivado 2024.2**。当前 `exp3.xpr` 是一个**全新的空白项目**——三个文件集（`sources_1` / `constrs_1` / `sim_1`）均已创建但尚无任何 RTL 源文件、约束或 testbench。后续工作将以添加 Verilog 设计为起点。

本系列已完成的实验（位于 `D:/CSE/` 同级目录，可作为惯例参考）：
- **exp1**：实现 OpenMIPS 教学处理器——MIPS 五级流水线（`if_id` / `id` / `id_ex` / `ex` / `ex_mem` / `mem` / `mem_wb`，外加 `regfile` / `cp0_reg` / `hilo_reg` / `div` / `divider` / `ctrl` / `defines`），顶层 `openmips_min_sopc`，指令存储用 `dist_mem_gen` IP 加载 `.coe`，数码管显示 `seg7x16`，testbench `openmips_min_sopc_tb`。
- **exp2**：系统移植实验——在 OpenMIPS 上构建 Wishbone 总线 SoC（DDR2 SDRAM / UART16550 / GPIO / SPI Flash），把 μC/OS-II 实时操作系统移植到 DDR2 并通过串口启动。

> exp1/exp2 的完整技术细节见下方「前序实验完成的工作」章节（作者学号 2352628，韦畅；LaTeX 报告源在 `D:/CSE/exp1/report/`、`D:/CSE/exp2/report/`，分章节文件在各自 `sections/`）。

## 实验3任务（应用开发实验）—— 贪吃蛇

在 exp2 的 OpenMIPS + μC/OS-II SoC 上做贪吃蛇游戏。**游戏逻辑跑在 FPGA 上**，方向用开发板按钮控制，画面通过 UART 发给 PC 的 pygame 显示。

### 架构
- **FPGA = 游戏主机**：μC/OS-II `TaskStart` 跑贪吃蛇（16×16 网格），板按钮（GPIO）控制方向，每次移动经 UART 发 41 字节状态帧。
- **PC = 图形界面**：`pc/snake_gui.py`（pygame）串口收帧、渲染画面+分数；`pc/debug_rx.py` 协议调试。
- **UART 单向**（FPGA→PC）；输入用板按钮，不用键盘。不用 VGA。

### 关键实现位置
- **硬件**：`exp3.srcs/`（从 exp2 整目录复制+改名）。xdc 改 `gpio_i[1..4]` 接方向按钮 BTNU/R/D/L = M18/M17/P18/P17，`gpio_i[0]`=BTNC 中键 = N17。顶层 `openmips_min_sopc`（韦昂版，数码管被精简）。
- **软件**：`software/ucosii/common/openmips.c`（从学长 exp3 复制 OS 软件目录）。新增 `uart_putc_raw()`，把 `TaskStart` 替换为贪吃蛇逻辑。main/驱动/OS 内核/BootLoader/Makefile 全复用学长。
- **PC**：`pc/{debug_rx,snake_gui}.py`（pyserial+pygame，4800 波特率）。

### UART 协议帧（FPGA→PC，41 字节二进制）
`[0,1]`=0xAA 0x55 头；`[2]`=state(3=READY/0=RUNNING/1=OVER/2=WIN)；`[3,4]`=score 小端；`[5]`=food(fx<<4|fy)；`[6]`=head(hx<<4|hy)；`[7]`=length；`[8..39]`=16×16 位图(蛇身=1，行优先高位在前)；`[40]`=bytes[2..39] 的 XOR 校验。PC 解析见 `pc/debug_rx.py`。

### ⚠️ 踩过的坑（别重蹈）
- **UART 波特率是 4800 不是 9600**：`openmips.h` 的 `IN_CLK=100000000` 是误导注释，OpenMIPS 实际跑 **50MHz**（clk_wiz），`uart_init` 的 divisor=651 → 实际 50M÷16÷651 ≈ **4800 bps**。PC 端 pyserial 必须 4800。
- **MIPS 工具链**：本机/课程都不提供。用 `mips-sde-elf 2016.05`（i686-pc-linux-gnu，Sourcery CodeBench），来自 GitHub `RT-Thread/toolchains-ci` release v1.1（`mips-2016.05-7-mips-sde-elf-i686-pc-linux-gnu.tar.bz2`）。装到 WSL Ubuntu `~/mips-sde-elf/mips-2016.05/`，64 位 WSL 需 `sudo apt install libc6:i386 libstdc++6:i386 zlib1g:i386`。
- **WSL PATH 括号坑**：WSL 继承的 Windows PATH 含 `Program Files (x86)`，括号让 `export PATH=...:$PATH` 报语法错。编译用临时 `PATH="/home/awaken/mips-sde-elf/mips-2016.05/bin:/usr/bin:/bin"`（封装在 `software/build.sh`）。
- **GCC 5.3 vs 学长 4.3**：不能复用学长预编译 `.o`，复制后删光旧 `.o`，`make clean` 全量重编（源码齐全）。
- **uart_putc 帧污染**：原 `uart_putc` 把 `\n(0x0A)` 自动追加 `\r(0x0D)`，破坏二进制帧。发协议帧必须用新增的 `uart_putc_raw`。
- **烧 Flash 型号**：本板 Nexys4 DDR 板载 **Spansion S25FL128S**，Vivado `Add Configuration Memory Device` 选 `s25fl128sxxxxx0-spi-x1_x2_x4`（不是 mt25ql128，选错报 `Part selected mt25ql128, but part s25fl128sxxxxx0 detected`）。
- **搬工程后 Vivado Sources 空**：必须先删 exp3 原空白工程的 `exp3.cache/.hw/.sim/.ip_user_files`，再打开 `exp3.xpr`，否则加载错乱。
- **ila_debug.xdc**：综合可能报 `Dropping logic core u_ila_0` 警告，无害（ILA 调试核，烧 Flash 时也会提示，忽略）。

### 常用命令
- 重编 OS.bin（改了 `openmips.c` 后）：`wsl -d Ubuntu -- bash /mnt/d/CSE/exp3/software/build.sh`
- PC 调试帧：`python pc/debug_rx.py COM3`
- PC 玩：`python pc/snake_gui.py COM3`
- 下板：Vivado Hardware Manager 烧 `software/ucosii/OS.bin` 到 S25FL128S（Erase+Program+Verify）→ Program Device 下载 `exp3.runs/impl_1/openmips_min_sopc.bit`（比特流 JTAG 临时下载，断电丢；Flash 里 OS.bin 持久）。

## 前序实验完成的工作（exp1 / exp2 技术底座）

exp3 几乎必然建立在这两个实验的成果之上。以下是做 exp3 时最可能复用/对接的关键技术事实。

### exp1：OpenMIPS CPU 改造（54 → 89 条 MIPS 指令）

在 OpenMIPS 教学五级流水线 CPU 基础上扩到 89 条指令并加入 CP0 + 异常/中断，下板 Nexys DDR 通过全部 11 个测试函数。

- **流水线模块**（`exp1.srcs/sources_1/imports/sources/`，纯 Verilog）：
  - 流水段：`pc_reg` → `if_id` → `id` → `id_ex` → `ex` → `ex_mem` → `mem` → `mem_wb`
  - 数据通路：`regfile`（通用寄存器堆）、`hilo_reg`（HI/LO）、`cp0_reg`（CP0）、`div`（试商法除法器）、`divider`（分频）、`LLbit_reg`（LL/SC 链接位）
  - 控制：`ctrl`（冒险 + 异常控制）、**`defines.v`（全局宏定义，几乎所有模块都 `include 它）**
  - 顶层层级：`openmips`（CPU 核）→ `openmips_min_sopc`（最小 SoC：CPU + inst_rom + data_ram + seg7x16）→ `openmips_board`（板级）
- **CP0 协处理器**：实现 Count / Compare / Status / Cause / EPC 寄存器，支持**时钟中断**。
- **精确异常机制**：ID 检 syscall/eret/无效指令 → EX 检自陷/溢出 → **MEM 阶段统一判定最终异常类型** → `ctrl` 发 flush 清空流水线 → PC 置异常入口 **`0x00400004`**。中断在 MEM 由 `(Cause[15:8] & Status[15:8]) && !Status[1] && Status[0]` 判定。
- **冒险处理**：数据前推（EX 阶段结果优先于 MEM 阶段）；load-use 冒险插入一个气泡（stall）。
- **除法**：独立 `div` 模块，32 周期试商法，4 状态机 `DivFree`/`DivOn`/`DivByZero`/`DivEnd`，运算期间 EX 暂停。
- **访存细节**：数据 RAM 4 字节 bank，**大端模式**（`addr[1:0]==00` 对应最高字节）；支持非对齐访存 LWL/LWR/SWL/SWR。
- **测试程序加载链**：MARS 导出二进制文本 → 脚本加 `memory_initialization_radix=2;` 与 `memory_initialization_vector=` 头转 COE → `dist_mem_gen` IP 初始化指令 ROM（`inst_rom.coe`）。testbench：`openmips_min_sopc_tb.v`。
- **时钟与时序**：板载 100MHz 经 `divider` 模块 100000 倍分频后 CPU 实际工作频率 <1kHz，故综合阶段针对 100MHz 的时序违规（WNS 为负）**可安全忽略**。

### exp2：μC/OS-II 系统移植（OpenMIPS SoC）

在 exp1 CPU 上构建 Wishbone 总线 SoC，把 μC/OS-II 移植到 DDR2，串口观察到完整启动日志。

- **SoC 架构**：**Wishbone B4 共享总线**（OpenCores `WB_CONMAX`），CPU 为唯一主设备，挂 4 个从设备——**DDR2 SDRAM、UART16550、GPIO、SPI Flash**。
- **地址映射**（`addr[31:28]` 高 4 位解码）：

  | 高 4 位 | 地址范围 | 从设备 |
  |---|---|---|
  | `0000` | `0x00000000–0x0FFFFFFF` | DDR2 SDRAM（256MB 主存） |
  | `0001` | `0x10000000–0x1FFFFFFF` | UART16550 |
  | `0010` | `0x20000000–0x2FFFFFFF` | GPIO（数码管 / LED） |
  | `0011` | `0x30000000–0x3FFFFFFF` | SPI Flash（程序存储，**复位取指起点**） |

- **关键 IP / 原语**：SPI Flash 控制器用 **`STARTUPE2` 原语**驱动专用配置引脚输出 SPI 时钟、一次读 4 字节（芯片 S25FL128S）；DDR2 用 Xilinx **`mig_7series`（MIG）IP** 完成初始化校准 + 读写。
- **时钟**（`clk_wiz`）：板载 100MHz → **50MHz**（总线/CPU/UART/GPIO/Flash）+ **200MHz**（MIG 参考时钟）。复位：`assign rst = ~rst_n | ~locked;`（`locked` 为 PLL 锁定信号）。
- **启动流程（BootLoader）**：复位从 `0x30000000`（Flash）取指 → 轮询 GPIO 等待 DDR2 校准完成 → 把 μC/OS-II 映像从 Flash 搬到 DDR2 → 跳转 DDR2 执行。
- **软件交叉编译**（Ubuntu + `mips-sde-elf` GCC 4.3 工具链）：修改 UART 分频系数（651）→ 编译 BootLoader + μC/OS-II 内核 + `common`(HAL) + `port`(移植层) → 链接 `ucosii.om`(ELF) → `mips-sde-elf-objcopy -O binary` 转 `ucosii.bin` → `BinMerge.exe` 合并 BootLoader 生成 **`OS.bin`**。
- **下板与调试**：Vivado Hardware Manager 烧 `OS.bin` 到 SPI Flash；PC 端 SuperCom（COM3 / 4800 / 8N1）接收启动日志；片上调试用 **Vivado ILA**。

## 目标硬件

- **FPGA 器件**：`xc7a100tcsg324-1`（Xilinx Artix-7 100T，C SG324 封装，速度等级 -1），即 **Nexys4 / Nexys A7-100T** 开发板。
- **默认库**：`xil_defaultlib`；顶层自动推断（`TopAutoSet = TRUE`）。
- 器件已在 `.xpr` 中锁定（`synth_1` / `impl_1` 均指向同一 Part），新增文件无需重新指定。

## 课程与代码惯例（沿用自 exp1/exp2）

- **HDL 语言一律用 Verilog**（`.v`）。项目里出现的 `.vhd` 都是 Xilinx IP 自动生成的产物，不要手写 VHDL。
- **目录布局**（Vivado 在添加首个源文件时会自动创建 `exp3.srcs/`）：
  - `exp3.srcs/sources_1/...` — 设计源（RTL）
  - `exp3.srcs/constrs_1/...` — 约束文件（`.xdc`，沿用 `openmips.xdc` 风格的引脚/电平约束）
  - `exp3.srcs/sim_1/...` — testbench
  - `exp3.gen/sources_1/ip/<ip_name>/` — **综合/生成产物**，由 Vivado 从 `.xci` 重新生成，不要手动编辑
  - `exp3.cache/`、`exp3.hw/`、`exp3.ip_user_files/`、`exp3.sim/` — Vivado 中间/缓存产物
- **指令存储**：用 `.coe`（系数文件）存放 MIPS 机器码，通过 `dist_mem_gen`（分布式 ROM）IP 加载。先在 `Mars4_5.jar`（`D:/CSE/Mars4_5.jar`，MIPS 汇编器/模拟器）中汇编测试程序，再导出机器码生成 `.coe`。
- **常用 IP**：`dist_mem_gen`（指令/数据 ROM-RAM）、`clk_wiz`（时钟）、`mig_7series`（DDR3）。

## 构建与仿真命令

FPGA 项目没有传统意义的 build/lint/test——「构建」= 综合 + 实现 + 生成比特流，「测试」= 仿真。所有操作通过 **Vivado Tcl** 完成。Claude Code 无法驱动 Vivado GUI，因此用 **批处理模式**（需 Vivado 在 PATH 中，或用完整路径如 `C:/Xilinx/Vivado/2024.2/bin/vivado.bat`）：

```powershell
# 在 PowerShell 中以批处理模式运行一段 Tcl（或写成 build.tcl 用 -source 加载）
vivado -mode batch -nojournal -nolog -tempDir ./.tmp -source build.tcl
# 交互式 Tcl Shell（适合多步探索）
vivado -mode tcl
```

核心 Tcl 命令（项目已打开后：`open_project D:/CSE/exp3/exp3.xpr`）：

```tcl
# —— 添加源文件并设置顶层 ——
add_files -norecurse {rtl/openmips.v rtl/regfile.v}
import_files -force            # 拷入 exp3.srcs/（默认行为，按需）
set_property top openmips_min_sopc [current_fileset]
update_compile_order -fileset sources_1

# —— 综合 + 实现 + 比特流（runs 已在 .xpr 中定义为 synth_1 / impl_1）——
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# —— IP 生成（新增/改动 IP 后必须先生成目标再综合）——
generate_target all [get_ips]

# —— 仿真（XSim，默认仿真器；时间单位 ns、基数 hex）——
set_property top openmips_min_sopc_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib   [get_filesets sim_1]
launch_simulation              # 编译 + 启动
run all                        ;# 或 run 1000 ns / restart 等
close_simulation
```

「运行单个测试」即把 `sim_1` 的顶层指向某个 testbench 后 `launch_simulation`。

## 重要约束

- **不要手动编辑 `exp3.xpr`**——它是 Vivado 管理的 XML，所有项目级改动（加文件、改顶层、改 runs）都应通过 Vivado GUI 或 Tcl 完成，否则项目会损坏。
- `exp3.gen/`、`exp3.cache/`、`exp3.hw/`、`exp3.ip_user_files/`、`exp3.sim/` 及将来的 `exp3.runs/` 全是生成产物；如需纳入版本控制，应忽略这些目录，仅保留 `.xpr`、`.srcs/` 下的手写源与 `.xci`（IP 定义）。
- 改动 IP 后，先 `generate_target all [get_ips]` 再综合，否则 `synth_1` 会因缺少 IP 产物失败。
