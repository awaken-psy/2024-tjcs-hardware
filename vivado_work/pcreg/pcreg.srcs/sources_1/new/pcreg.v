`timescale 1ns / 1ps


module pcreg(
    input clk, //1位输入，寄存器时钟信号，上升沿时为PC寄存器赋值 
    input rst, //1位输入，异步重置信号，高电平时将PC寄存器清零  注：当ena信号无效时，rst也可以重置寄存器 
    input ena, //1位输入,有效信号高电平时PC寄存器读入data_in的值，否则保持原有输出
    input [31:0] data_in, //32位输入，输入数据将被存入寄存器内部 
    output reg [31:0] data_out //32位输出，工作时始终输出PC寄存器内部存储的值 
    );
    always @(posedge clk or rst==1)begin
        if(rst==1)
            data_out = 32'b00000000_00000000_00000000_00000000;
        else if(ena==1)
            data_out = data_in;
    end
endmodule
