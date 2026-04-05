# 硬件系列课程实验存档

[![Verilog](https://img.shields.io/badge/Verilog-HDL-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Logisim](https://img.shields.io/badge/Logisim-2.7-orange.svg)](http://www.cburch.com/logisim/)
[![Vivado](https://img.shields.io/badge/Vivado-2019+-red.svg)](https://www.xilinx.com/products/design-tools/vivado.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> 同济大学计算机科学与技术专业三门硬件系列课程的实验存档：**数字逻辑**、**计算机组成原理**、**计算机系统结构**。

---

## 📚 课程概览

| 课程 | 工具 | 主要内容 |
|------|------|---------|
| 数字逻辑 | Logisim | 基础门电路、编码器/译码器、加法器、计数器、寄存器堆 |
| 计算机组成原理 | Verilog / Vivado | ALU、乘除法器、单周期/多周期 CPU（MIPS） |
| 计算机系统结构 | Verilog / Vivado | 流水线 CPU、数据转发、冒险检测、异常处理 |

---

## 📂 仓库结构

```
2024-tjcs-hardware/
├── logisim/                  # 数字逻辑实验（Logisim 仿真）
│   ├── 3-8decoder.circ
│   ├── barrelshifter.circ
│   ├── Counter8.circ
│   ├── Regfiles.circ
│   ├── 定序型比较器.circ
│   ├── 定序型加法器.circ
│   └── ...
└── vivado_work/              # 组成原理 & 系统结构实验（Verilog）
    ├── Adder/
    ├── alu/
    ├── barrelshifter32/
    ├── Regfiles/
    ├── mult/ multu/          # 乘法器（有/无符号）
    ├── Divider/ DIV/ DIVU/   # 除法器
    ├── CPU_54/ cpu54/        # 54 条指令单周期 CPU
    └── ...
```

---

## 🧪 实验内容

### 数字逻辑（Logisim）

| 实验 | 内容 |
|------|------|
| 基础门电路 | 与/或/非/异或等逻辑门 |
| 编码器/译码器 | 3-8 译码器、优先编码器 |
| 加法器/比较器 | 定序型、多路选择器型、计数器型对比实现 |
| 8 位计数器 | 同步计数器设计 |
| 寄存器堆 | 多端口寄存器堆 |
| 桶形移位器 | 可变位移位操作 |

### 计算机组成原理（Verilog / Vivado）

| 实验 | 内容 |
|------|------|
| 基础组合逻辑 | 门电路、选择器、编码器、译码器 |
| 触发器 | 同步/异步 D 触发器、JK 触发器 |
| ALU | 算术逻辑单元 |
| 乘法器/除法器 | 有符号/无符号运算 |
| CPU 设计 | 54 条 MIPS 指令单周期 CPU |

### 计算机系统结构（Verilog / Vivado）

#### 实验1 — 简单流水线 CPU

基于 MIPS 指令集的五级流水线 CPU，实现流水线基础框架：

- **五级流水段**：IF → ID → EX → MEM → WB
- **流水段间寄存器**：IF/ID、ID/EX、EX/MEM、MEM/WB
- **冒险检测与流水线暂停**（`stall.v`）
- 基础 ALU、寄存器堆、数据存储器

#### 实验2 — 完整流水线 CPU

在实验1基础上扩展，实现完整的 MIPS 流水线处理器：

- **数据转发（Forwarding）** — 解决数据相关，减少流水线停顿
- **CP0 协处理器** — 异常/中断处理机制
- **乘除法单元** — `mult` / `div` 指令支持
- **CLZ 前导零计数** — `clz` 指令支持
- **完整指令集支持** — 覆盖运算、访存、跳转、异常等类型

---

## 🛠️ 工具环境

- **Logisim** 2.7.0 — 数字逻辑仿真
- **Vivado** 2019+ — FPGA 综合与仿真
- **Verilog HDL** — 硬件描述语言
- **MARS** — MIPS 汇编模拟器（测试用）

---

## 📄 许可证

[MIT License](LICENSE)
