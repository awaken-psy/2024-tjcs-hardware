// 七段数码管显示驱动模块
`timescale 1ns / 1ps

module seven_segment_display(
     input clock_input,
	 input reset_input,
	 input chip_select,
	 input [31:0] display_data_input,
	 output [7:0] segment_output,
	 output [7:0] digit_select_output
    );

    // 扫描时钟分频计数器
    reg [14:0] frequency_counter;
	 
	 always @ (posedge clock_input, posedge reset_input)
      if (reset_input)
        frequency_counter <= 0;
      else
        frequency_counter <= frequency_counter + 1'b1;
 
    // 生成扫描时钟
    wire scan_clock = frequency_counter[14]; 
	 
	 // 数码管位选地址计数器
	 reg [2:0] digit_address;
	 
	 always @ (posedge scan_clock, posedge reset_input)
	   if(reset_input)
		  digit_address <= 0;
		else
		  digit_address <= digit_address + 1'b1;
		  
	 // 数码管位选信号生成
	 reg [7:0] digit_select_register;
	 
	 always @ (*)
	   case(digit_address)
		  3'd7 : digit_select_register = 8'b01111111;
		  3'd6 : digit_select_register = 8'b10111111;
		  3'd5 : digit_select_register = 8'b11011111;
		  3'd4 : digit_select_register = 8'b11101111;
		  3'd3 : digit_select_register = 8'b11110111;
		  3'd2 : digit_select_register = 8'b11111011;
		  3'd1 : digit_select_register = 8'b11111101;
		  3'd0 : digit_select_register = 8'b11111110;
		endcase
	
	 // 显示数据锁存
	 reg [31:0] display_data_latch;
	 
	 always @ (posedge clock_input, posedge reset_input)
	   if(reset_input)
		  display_data_latch <= 0;
		else if(chip_select)
		  display_data_latch <= display_data_input;
		  
	 // 当前显示数据选择
	 reg [3:0] current_digit_data;
	 
	 always @ (*)
	   case(digit_address)
		  3'd0 : current_digit_data = display_data_latch[3:0];
		  3'd1 : current_digit_data = display_data_latch[7:4];
		  3'd2 : current_digit_data = display_data_latch[11:8];
		  3'd3 : current_digit_data = display_data_latch[15:12];
		  3'd4 : current_digit_data = display_data_latch[19:16];
		  3'd5 : current_digit_data = display_data_latch[23:20];
		  3'd6 : current_digit_data = display_data_latch[27:24];
		  3'd7 : current_digit_data = display_data_latch[31:28];
		endcase
	 
	 // 七段译码逻辑
	 reg [7:0] segment_output_register;
	 
	 always @ (posedge clock_input, posedge reset_input)
	   if(reset_input)
		  segment_output_register <= 8'hff;
		else
		  case(current_digit_data)
		    4'h0 : segment_output_register <= 8'hC0;  // 显示数字0
          4'h1 : segment_output_register <= 8'hF9;  // 显示数字1
          4'h2 : segment_output_register <= 8'hA4;  // 显示数字2
          4'h3 : segment_output_register <= 8'hB0;  // 显示数字3
          4'h4 : segment_output_register <= 8'h99;  // 显示数字4
          4'h5 : segment_output_register <= 8'h92;  // 显示数字5
          4'h6 : segment_output_register <= 8'h82;  // 显示数字6
          4'h7 : segment_output_register <= 8'hF8;  // 显示数字7
          4'h8 : segment_output_register <= 8'h80;  // 显示数字8
          4'h9 : segment_output_register <= 8'h90;  // 显示数字9
          4'hA : segment_output_register <= 8'h88;  // 显示字母A
          4'hB : segment_output_register <= 8'h83;  // 显示字母B
          4'hC : segment_output_register <= 8'hC6;  // 显示字母C
          4'hD : segment_output_register <= 8'hA1;  // 显示字母D
          4'hE : segment_output_register <= 8'h86;  // 显示字母E
          4'hF : segment_output_register <= 8'h8E;  // 显示字母F
		  endcase
		  
	 // 输出信号连接
	 assign digit_select_output = digit_select_register;
	 assign segment_output = segment_output_register;

endmodule