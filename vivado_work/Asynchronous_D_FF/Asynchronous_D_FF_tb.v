`timescale 1ns / 1ps



module Asynchronous_D_FF_tb;
    reg clk;
    reg rst_n;
    reg d;
    wire q1;
    wire q2;
    Asynchronous_D_FF test1(.CLK(clk),.RST_n(rst_n),.D(d),.Q1(q1),.Q2(q2));

    initial clk<=0;
    always #10 clk <= ~clk;
    initial 
    begin
        d <= 0;
        rst_n <= 1;

        #10 d<=1;
        #20 d<=0;
        #20 d<=1;

        #10 rst_n<=0;
        #10;

        #20 d<=1;
        #20 d<=0;

        #10 $stop;
    end

endmodule
