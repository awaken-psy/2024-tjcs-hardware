`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 18:13:00
// Design Name: 
// Module Name: LLbit_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module LLbit_reg(
    input wire clk,
	input wire rst,
	
	input wire flush,
	//Ð´¶Ë¿Ú
	input wire LLbit_i,
	input wire we,
	
	//¶Á¶Ë¿Ú1
	output reg LLbit_o
    );
    
    always @ (posedge clk) 
    begin
		if (rst == `RstEnable) 
		begin
			LLbit_o <= 1'b0;
		end 
		else if((flush == 1'b1)) 
		begin
			LLbit_o <= 1'b0;
		end else if((we == `WriteEnable)) 
		begin
			LLbit_o <= LLbit_i;
		end
	end
    
endmodule
