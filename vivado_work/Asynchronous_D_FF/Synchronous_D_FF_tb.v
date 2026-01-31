`timescale 1ns / 1ps


module Synchronous_D_FF_tb;
    reg CLK,RST_n,D;
    wire Q1,Q2;
    Synchronous_D_FF test(.CLK(CLK),.RST_n(RST_n),.D(D),.Q1(Q1),.Q2(Q2));

    initial CLK<=0;
    always #50 CLK <= ~CLK;
    initial 
    begin
        D <= 0;RST_n <= 1;
        #50 D<=1;
        #100 D<=0;
        #100 D<=1;
        #100 RST_n<=0;
        #100 D<=1;
        #100 D<=0;
        #50 $stop;
    end
endmodule
