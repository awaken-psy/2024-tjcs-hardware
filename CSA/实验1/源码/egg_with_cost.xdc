# 时钟信号引脚配置
set_property PACKAGE_PIN E3 [get_ports system_clock] 

# 控制信号引脚配置
set_property PACKAGE_PIN N17 [get_ports system_reset] 
set_property PACKAGE_PIN P17 [get_ports floor_init_enable] 
set_property PACKAGE_PIN M17 [get_ports resistance_init_enable] 
set_property PACKAGE_PIN H17 [get_ports final_result_broken_status] 

# 七段数码管段选信号引脚配置
set_property PACKAGE_PIN T10 [get_ports {segment_output[0]}] 
set_property PACKAGE_PIN R10 [get_ports {segment_output[1]}] 
set_property PACKAGE_PIN K16 [get_ports {segment_output[2]}] 
set_property PACKAGE_PIN K13 [get_ports {segment_output[3]}] 
set_property PACKAGE_PIN P15 [get_ports {segment_output[4]}] 
set_property PACKAGE_PIN T11 [get_ports {segment_output[5]}] 
set_property PACKAGE_PIN L18 [get_ports {segment_output[6]}] 
set_property PACKAGE_PIN H15 [get_ports {segment_output[7]}] 

# 七段数码管位选信号引脚配置
set_property PACKAGE_PIN J17 [get_ports {digit_select_output[0]}] 
set_property PACKAGE_PIN J18 [get_ports {digit_select_output[1]}] 
set_property PACKAGE_PIN T9  [get_ports {digit_select_output[2]}] 
set_property PACKAGE_PIN J14 [get_ports {digit_select_output[3]}] 
set_property PACKAGE_PIN P14 [get_ports {digit_select_output[4]}] 
set_property PACKAGE_PIN T14 [get_ports {digit_select_output[5]}] 
set_property PACKAGE_PIN K2  [get_ports {digit_select_output[6]}] 
set_property PACKAGE_PIN U13 [get_ports {digit_select_output[7]}] 

# 输入数据信号引脚配置
set_property PACKAGE_PIN J15 [get_ports {input_data[0]}] 
set_property PACKAGE_PIN L16 [get_ports {input_data[1]}] 
set_property PACKAGE_PIN M13 [get_ports {input_data[2]}] 
set_property PACKAGE_PIN R15 [get_ports {input_data[3]}] 
set_property PACKAGE_PIN R17 [get_ports {input_data[4]}] 
set_property PACKAGE_PIN T18 [get_ports {input_data[5]}] 
set_property PACKAGE_PIN U18 [get_ports {input_data[6]}] 
set_property PACKAGE_PIN R13 [get_ports {input_data[7]}] 
set_property PACKAGE_PIN T8  [get_ports {input_data[8]}] 
set_property PACKAGE_PIN U8  [get_ports {input_data[9]}] 
set_property PACKAGE_PIN R16 [get_ports {input_data[10]}] 
set_property PACKAGE_PIN T13 [get_ports {input_data[11]}] 
set_property PACKAGE_PIN H6  [get_ports {input_data[12]}] 
set_property PACKAGE_PIN U12 [get_ports {input_data[13]}] 
set_property PACKAGE_PIN U11 [get_ports {input_data[14]}] 
set_property PACKAGE_PIN V10 [get_ports {input_data[15]}] 

# 信号电平标准配置 - 控制信号
set_property IOSTANDARD LVCMOS33 [get_ports system_clock] 
set_property IOSTANDARD LVCMOS33 [get_ports system_reset] 
set_property IOSTANDARD LVCMOS33 [get_ports floor_init_enable] 
set_property IOSTANDARD LVCMOS33 [get_ports resistance_init_enable] 
set_property IOSTANDARD LVCMOS33 [get_ports final_result_broken_status] 

# 信号电平标准配置 - 数码管位选信号
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[7]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[6]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[5]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[4]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[3]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[2]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {digit_select_output[0]}] 

# 信号电平标准配置 - 数码管段选信号
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[7]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[6]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[5]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[4]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[3]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[2]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {segment_output[0]}] 

# 信号电平标准配置 - 输入数据信号
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[0]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[2]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[3]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[4]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[5]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[6]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[7]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[8]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[9]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[10]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[11]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[12]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[13]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[14]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[15]}] 

# 时钟约束配置
create_clock -period 100.000 -name clk_pin -waveform {0.000 50.000} [get_ports system_clock] 

# 输入延迟约束
set_input_delay -clock [get_clocks *] 1.000 [get_ports system_reset] 

# 输出延迟约束
set_output_delay -clock [get_clocks *] 0.000 [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]