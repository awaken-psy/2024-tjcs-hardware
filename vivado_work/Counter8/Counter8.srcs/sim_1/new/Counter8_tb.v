`timescale 1ns / 1ps

module Counter8_tb;
    reg CLK;
    reg rst_n;
    wire [2:0] oQ;
    wire [6:0] oDisplay;

    Counter8 test1(.CLK(CLK),.rst_n(rst_n),.oQ(oQ),.oDisplay(oDisplay));

    always #5 CLK <= ~CLK;
    initial 
    begin
        CLK<=0; 
        rst_n<=0;
        #10 rst_n<=1;
        #1000 rst_n<=0;
        $stop;
    end
endmodule

