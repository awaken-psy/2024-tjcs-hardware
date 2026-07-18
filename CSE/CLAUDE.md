# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

同济大学「计算机系统实验」课程 FPGA 实验系列。在 **Xilinx Vivado** 下使用 **Verilog** 实现 OpenMIPS 教学处理器，逐步构建 Wishbone 总线 SoC、移植 μC/OS-II 实时操作系统，最终开发桌面应用。

- **目标硬件**: Nexys4 DDR（Nexys A7-100T），器件 `xc7a100tcsg324-1`
- **开发环境**: Vivado 2024.2（exp1 用 2024.2，exp2/exp3 的参考项目分别用过 2020.2/2019.1）
- **仿真器**: Vivado XSim（默认）
- **MIPS 汇编/模拟**: `Mars4_5.jar`（项目根目录）

## 实验目录与递进关系

三个实验是**逐层递进**的，后者依赖前者的所有硬件成果：

### exp1 — CPU 改造
从教学版 OpenMIPS 54 条指令扩展到 **89 条 MIPS 指令**，添加 CP0 协处理器、精确异常机制、时钟中断。
- 5 级流水线: `pc_reg → if_id → id → id_ex → ex → ex_mem → mem → mem_wb`
- 数据通路: `regfile` / `hilo_reg` / `cp0_reg` / `div` / `LLbit_reg`
- 控制: `ctrl`（冒险控制+异常控制）、`defines.v`（全局宏定义，所有模块 `include`）
- 顶层: `openmips`(CPU 核) → `openmips_min_sopc`(最小 SoC) → `openmips_board`(板级)
- 指令存储: `dist_mem_gen` IP 加载 `.coe` 文件（MARS 导出 → 加 COE 头）
- 参考源码: `exp1/exp1.srcs/sources_1/imports/sources/`

### exp2 — 系统移植（μC/OS-II）
在 exp1 CPU 基础上构建 **Wishbone B4 共享总线** SoC（OpenCores `WB_CONMAX`），移植 μC/OS-II 到 DDR2。
- **SoC 架构**: CPU 为唯一 Master，4 个 Slave: DDR2 / UART16550 / GPIO / SPI Flash
- **地址映射**（高 4 位解码）:
  - `0x0` — DDR2 SDRAM（256MB，主存）
  - `0x1` — UART16550
  - `0x2` — GPIO（数码管/LED）
  - `0x3` — SPI Flash（S25FL128S，**复位取指起点**）
- **IP**: `mig_7series`（DDR2 控制器）、`clk_wiz`（100MHz→50MHz 总线 + 200MHz MIG 参考）
- **启动流程**: 复位从 Flash 取指 → 等待 DDR2 校准 → BootLoader 搬 μC/OS-II 到 DDR2 → 跳转
- 参考源码: `exp2/exp2.srcs/sources_1/imports/code/`

### exp3 — 应用开发（贪吃蛇）+ 学长参考
在 exp2 SoC 上开发贪吃蛇游戏 + pygame PC 端显示。exp3 另有学长（曾崇然 2152809）的翻牌游戏版本作为参考。
- **硬件**: 复用 exp2 全部 RTL，修改 XDC（GPIO 按钮方向映射）
- **软件** (`exp3/software/`): μC/OS-II + 贪吃蛇 TaskStart，MIPS 交叉编译
- **PC 端** (`exp3/pc/`): `snake_gui.py`（pygame）、`debug_rx.py`（协议调试）
- **UART 协议**: 4800 bps 二进制帧（41 字节），FPGA→PC 单向
- 关键踩坑记录见 `exp3/CLAUDE.md`（波特率、工具链、Flash 型号等）

## Vivado 项目操作

所有操作通过 **Vivado Tcl** 完成（批处理或交互式）。项目文件为各 `expN/expN.xpr`。

```powershell
# 批处理模式
vivado -mode batch -nojournal -nolog -source build.tcl

# 交互式 Tcl Shell
vivado -mode tcl
```

核心 Tcl 流程：
```tcl
open_project D:/CSE/exp3/exp3.xpr

# 添加文件
add_files -norecurse {rtl/foo.v}
update_compile_order -fileset sources_1

# IP 生成（改 IP 后必须先做）
generate_target all [get_ips]

# 综合 + 实现 + 比特流
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# 仿真
set_property top openmips_min_sopc_tb [get_filesets sim_1]
launch_simulation
run all
close_simulation
```

## MIPS 软件交叉编译

在 WSL Ubuntu 中使用 `mips-sde-elf` 工具链（GCC 4.3 / 2016.05 均可）。exp3 的软件目录 `exp3/software/` 包含完整 μC/OS-II 源码 + BootLoader + Makefile。

```bash
# exp3 编译（详见 exp3/software/build.sh）
PATH="/home/awaken/mips-sde-elf/mips-2016.05/bin:/usr/bin:/bin"
make clean && make all
# 产出: ucosii.om(ELF) → ucosii.bin → OS.bin(BootLoader+OS合并)
```

64 位 WSL 需安装 32 位库: `sudo apt install libc6:i386 libstdc++6:i386 zlib1g:i386`

## 下板烧录

1. Vivado Hardware Manager → Add Configuration Memory Device → `s25fl128sxxxxx0-spi-x1_x2_x4`
2. 烧 `OS.bin` 到 SPI Flash（Erase + Program + Verify）
3. Program Device 下载比特流（JTAG 临时下载，断电丢失；Flash 中 OS.bin 持久）

## 重要约束

- **不要手动编辑 `.xpr`** — 它是 Vivado 管理的 XML，所有改动通过 GUI 或 Tcl
- `expN.gen/`、`expN.cache/`、`expN.hw/`、`expN.runs/`、`expN.sim/` 全是生成产物，不应手动编辑或纳入版本控制
- **`defines.v` 是全局宏定义文件**，几乎所有 RTL 模块都 `include` 它；改动宏定义会影响整个设计
- 手写 Verilog 一律用 `.v`，`.vhd` 是 Xilinx IP 自动生成的
- exp2/exp3 的 UART 实际波特率是 **4800**（50MHz 时钟 ÷ 16 ÷ 651），不是 9600
- exp2/exp3 使用的 SPI Flash 芯片是 **S25FL128S**（Nexys4 DDR 板载）
