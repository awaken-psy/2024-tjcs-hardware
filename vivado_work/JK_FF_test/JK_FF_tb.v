`timescale 1ns / 1ps

module JK_FF_tb;
    reg CLK;
    reg RST_n;
    reg J;
    reg K;
    wire Q1;
    wire Q2;
    JK_FF test1(.CLK(CLK),.RST_n(RST_n),.J(J),.K(K),.Q1(Q1),.Q2(Q2));

    initial CLK<=0;
    always #10 CLK <= ~CLK;
    initial 
    begin
        J <= 0;K <= 0;RST_n <= 1;
        #50 begin J<=1; K<=0; end
        #100 begin J<=0; K<=1; end
        #100 begin J<=1; K<=1; end
        #100 begin RST_n<=0; end
        #100 begin J<=1; K<=0; end
        #100 begin J<=0; K<=1; end
        #100 begin J<=1; K<=1; end
        $stop;
    end 
endmodule
