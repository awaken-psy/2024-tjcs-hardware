`timescale 1ns / 1ps


module Adder_tb;
    reg [7:0]a;
    reg [7:0]b;
    reg iC;
    wire [7:0]c;
    wire oC;
    Adder test1(.iData_a(a),.iData_b(b),.iC(iC),.oData(c),.oData_C(oC));
    initial begin
        #10 begin a=8'b1010_1010 ; b=8'b0101_0101 ; iC=0 ; end//1111_1111 0
        #10 begin a=8'b1010_1010 ; b=8'b0101_0101 ; iC=1 ; end//0000_0000 1
        #10 begin a=8'b0100_0011 ; b=8'b1000_1001 ; iC=0 ; end//1100_1100 0
        #10 begin a=8'b0100_0011 ; b=8'b1000_1001 ; iC=1 ; end//1100_1101 0
        #10 begin a=8'b1010_0000 ; b=8'b0000_1010 ; iC=0 ; end//1010_1010 0
        #10 begin a=8'b1010_0000 ; b=8'b0000_1010 ; iC=1 ; end//1010_1011 0
    end
endmodule
