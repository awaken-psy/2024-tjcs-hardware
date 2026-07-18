# ============================================
# 时钟约束
# ============================================
set_property PACKAGE_PIN E3   [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 100.000 -name clk_pin -waveform {0.000 50.000} [get_ports clk]

# ============================================
# 按键和开关约束
# ============================================
# 复位按键
set_property PACKAGE_PIN N17  [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# 使能按键
set_property PACKAGE_PIN V10  [get_ports ena]
set_property IOSTANDARD LVCMOS33 [get_ports ena]

# 拨码开关（3位）
set_property PACKAGE_PIN M13  [get_ports {switch[2]}]
set_property PACKAGE_PIN L16  [get_ports {switch[1]}]
set_property PACKAGE_PIN J15  [get_ports {switch[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[0]}]

# ============================================
# 七段数码管段选约束
# ============================================
set_property PACKAGE_PIN T10  [get_ports {o_seg[0]}]
set_property PACKAGE_PIN R10  [get_ports {o_seg[1]}]
set_property PACKAGE_PIN K16  [get_ports {o_seg[2]}]
set_property PACKAGE_PIN K13  [get_ports {o_seg[3]}]
set_property PACKAGE_PIN P15  [get_ports {o_seg[4]}]
set_property PACKAGE_PIN T11  [get_ports {o_seg[5]}]
set_property PACKAGE_PIN L18  [get_ports {o_seg[6]}]
set_property PACKAGE_PIN H15  [get_ports {o_seg[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_seg[0]}]

# ============================================
# 七段数码管位选约束
# ============================================
set_property PACKAGE_PIN J17  [get_ports {o_sel[0]}]
set_property PACKAGE_PIN J18  [get_ports {o_sel[1]}]
set_property PACKAGE_PIN T9   [get_ports {o_sel[2]}]
set_property PACKAGE_PIN J14  [get_ports {o_sel[3]}]
set_property PACKAGE_PIN P14  [get_ports {o_sel[4]}]
set_property PACKAGE_PIN T14  [get_ports {o_sel[5]}]
set_property PACKAGE_PIN K2   [get_ports {o_sel[6]}]
set_property PACKAGE_PIN U13  [get_ports {o_sel[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_sel[0]}]

# ============================================
# 时序约束
# ============================================
# 复位信号的输入延迟约束
set_input_delay -clock [get_clocks clk_pin] 1.000 [get_ports rst]

# 所有输出端口的输出延迟约束
set_output_delay -clock [get_clocks clk_pin] 0.000 [get_ports -filter {DIRECTION == "OUT"}]

# ============================================
# 可选：添加上拉或下拉约束（如果需要）
# ============================================
# 为按键和开关添加上拉，避免悬空时的噪声
set_property PULLUP TRUE [get_ports rst]
set_property PULLUP TRUE [get_ports ena]
# set_property PULLUP TRUE [get_ports {switch[*]}]

