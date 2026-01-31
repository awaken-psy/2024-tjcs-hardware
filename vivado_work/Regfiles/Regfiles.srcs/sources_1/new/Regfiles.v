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

module Asynchronous_D_FF(
    input CLK,
    input D,
    input RST_n,
    output reg Q1,
    output reg Q2
    );
    always @(posedge CLK or negedge RST_n) begin
        if (~RST_n) begin
            Q1 <= 1'b0;
            Q2 <= 1'b1;
        end
        else begin
            Q1 <= D;
            Q2 <= ~D;
        end
    end
endmodule


module decoder5to32 (
    input iEna,         
    input [4:0] in,  
    output reg [31:0] out 
);
    always @(*) begin
        if (iEna) begin
            out = 32'b0;
            out[in] = 1'b1;
        end else out = 32'b0;
    end
endmodule

module mux32to1_32bit (
    input [1023:0] in,    
    input [4:0] sel,     
    input ena,             
    output reg [31:0] out  
);
    always @(*) begin
        if (ena) begin
            out = in[sel * 32 +: 32];
        end else  out = 32'bz;

    end
endmodule

module Regfiles(
    input clk,
    input rst,
    input we,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,
    output [31:0] rdata1,
    output [31:0] rdata2
    );


    wire [31:0] write_decoder_out; 
    wire [1023:0] registers_flat;  
    genvar i;

    decoder5to32 write_decoder (.iEna(we),.in(waddr),.out(write_decoder_out) );

    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_gen
            pcreg reg_inst (.clk(clk),.rst(rst),.ena(write_decoder_out[i]), .data_in(wdata),.data_out(registers_flat[i * 32 +: 32]) );
        end
    endgenerate

    mux32to1_32bit mux_rdata1 (.in(registers_flat), .sel(raddr1),.ena(~we),.out(rdata1));
    mux32to1_32bit mux_rdata2 (.in(registers_flat), .sel(raddr2),.ena(~we),.out(rdata2));
endmodule
