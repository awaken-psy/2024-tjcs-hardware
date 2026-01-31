`timescale 1ns / 1ps

module Divider_tb;
    reg I_CLK;
    reg rst;
    wire O_CLK;
 
    Divider #(20) test1(.I_CLK(I_CLK),.rst(rst),.O_CLK(O_CLK));
    always #10 I_CLK = ~I_CLK;
    initial begin
        I_CLK = 0;rst = 1;
        #40;rst = 0;
        #1000;rst = 1;
        #40;rst = 0;
        #400;$stop;
    end
endmodule
