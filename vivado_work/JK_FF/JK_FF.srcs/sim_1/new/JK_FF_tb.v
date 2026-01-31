`timescale 1ns / 1ps

module JK_FF_tb;
    reg clk;
    reg rst_n;
    reg j;
    reg k;
    wire q1;
    wire q2;
    JK_FF test1(.CLK(clk),.RST_n(rst_n),.J(j),.K(k),.Q1(q1),.Q2(q2));

    initial clk<=0;
    always #10 clk <= ~clk;
    initial 
    begin
        j <= 0;
        k <= 0;
        rst_n <= 1;

        #10 begin j<=1; k<=0; end
        #20 begin j<=0; k<=1; end
        #20 begin j<=1; k<=1; end

        #20 rst_n<=0;

        #20 begin j<=1; k<=0; end
        #20 begin j<=0; k<=1; end
        #20 begin j<=1; k<=1; end

        $stop;
    end


endmodule
