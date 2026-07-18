`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/09 11:14:56
// Design Name: 
// Module Name: if_id
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

module if_id(
    input wire clk,
    input wire rst,
    
    input wire[5:0] stall,
    input wire flush,
    
    // 来自取值阶段的信号，其中宏定义InstBus表示指令宽度，为32
    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus] if_inst,
    
    // 对应译码极端的信号
    output reg[`InstAddrBus] id_pc,
    output reg[`InstBus] id_inst
    );
    
    always @ (posedge clk)
    begin
        if (rst == `RstEnable)
        begin
            id_pc <= `ZeroWord;     // 复位时pc为0
            id_inst <= `ZeroWord;   // 复位时指令也为0，即空指令
        end
        else if(flush == 1'b1 ) 
        begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;					
		end
        else if (stall[1] == `Stop && stall[2] == `NoStop)
        begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else if (stall[1] == `NoStop)
        begin
            id_pc <= if_pc;     // 其余时刻向下传递取值阶段的值
            id_inst <= if_inst;
        end
    end
    
endmodule
