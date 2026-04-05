# 计算机组成原理与数字逻辑实验

[![Verilog](https://img.shields.io/badge/Verilog-HDL-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Logisim](https://img.shields.io/badge/Logisim-2.7-orange.svg)](http://www.cburch.com/logisim/)
[![Vivado](https://img.shields.io/badge/Vivado-2019+-red.svg)](https://www.xilinx.com/products/design-tools/vivado.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> 同济大学计算机科学与技术专业计算机组成原理及数字逻辑系列实验，包含 Logisim 电路仿真与 Vivado/Verilog 硬件设计实现。

---

## 📂 仓库结构

```
2024-tjcs-hardware/
├── logisim/              # Logisim 数字逻辑电路仿真
│   ├── 3-8decoder.circ
│   ├── barrelshifter.circ
│   ├── Counter8.circ
│   ├── Regfiles.circ
│   ├── 定序型比较器.circ
│   ├── 定序型加法器.circ
│   └── ...
└── vivado_work/          # Verilog HDL 硬件设计（Vivado）
    ├── Adder/            # 加法器
    ├── alu/              # 算术逻辑单元
    ├── barrelshifter32/  # 32 位桶形移位器
    ├── CPU_54/           # 54 条指令 CPU
    ├── Divider/          # 除法器
    ├── Regfiles/         # 寄存器堆
    └── ...
```

---

## 🧪 实验内容

### Logisim 数字逻辑

| 实验 | 内容 |
|------|------|
| 基础门电路 | 与/或/非/异或等逻辑门 |
| 编码器/译码器 | 3-8 译码器、优先编码器 |
| 加法器/比较器 | 多类型实现方式对比 |
| 计数器 | 8 位计数器 |
| 寄存器堆 | 多端口寄存器堆设计 |
| 桶形移位器 | 可变位移位操作 |

### Verilog / Vivado

| 实验 | 内容 |
|------|------|
| 基础组合逻辑 | 门电路、选择器、编码器 |
| 触发器 | 同步/异步 D 触发器、JK 触发器 |
| ALU | 算术逻辑单元设计 |
| 乘法器/除法器 | 有符号/无符号运算 |
| CPU 设计 | 单周期/多周期 CPU（54 条 MIPS 指令） |

---

## 🛠️ 工具环境

- **Logisim** 2.7.0（数字逻辑仿真）
- **Vivado** 2019+（FPGA 综合与仿真）
- **Verilog HDL**（硬件描述语言）

---

## 📄 许可证

[MIT License](LICENSE)
