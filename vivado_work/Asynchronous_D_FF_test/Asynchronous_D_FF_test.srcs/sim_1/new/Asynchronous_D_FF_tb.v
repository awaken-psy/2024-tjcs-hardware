`timescale 1ns / 1ps


module Asynchronous_D_FF_tb;
    reg CLK;
    reg RST_n;
    reg D;
    wire Q1;
    wire Q2;
    Asynchronous_D_FF a1(.CLK(CLK),.RST_n(RST_n),.D(D),.Q1(Q1),.Q2(Q2));

    initial CLK<=0;
    always #10 CLK <= ~CLK;
    initial 
    begin
        D <= 0;RST_n <= 1;
        #50 D<=1;
        #100 D<=0;
        #100 D<=1;
        #50 RST_n<=0;#50;
        #100 D<=1;
        #100 D<=0;
        #50 $stop;
    end
endmodule
