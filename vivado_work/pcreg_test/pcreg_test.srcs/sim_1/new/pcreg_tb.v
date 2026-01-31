`timescale 1ns / 1ps

module pcreg_tb;
    reg clk,rst,ena;
    reg [31:0] inD;
    wire [31:0] outD; 
    pcreg t1(.clk(clk),.rst(rst),.ena(ena),.data_in(inD),.data_out(outD));
    initial clk<=0;
    always #50 clk <= ~clk;
    initial 
    begin
        inD <= 32'b00000000_00000000_00000000_00000000;
        ena <= 1;
        rst <= 0;

        #50 inD <= 32'b11101110_10100010_10100010_10001010;
        #100 inD <= 32'b01111101_01010101_01000101_10011101;
        #100 rst <= 1;

        #100 ena <= 0;
        inD <= 32'b10001110_10101111_00001010_10111110;
        #100 $stop;
    end
endmodule
