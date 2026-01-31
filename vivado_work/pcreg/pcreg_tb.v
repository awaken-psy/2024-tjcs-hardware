`timescale 1ns / 1ps


module pcreg_tb;
    reg clk;
    reg rst;
    reg ena;
    reg [31:0] data_in;
    wire [31:0] data_out; 
    pcreg test1(.clk(clk),.rst(rst),.ena(ena),.data_in(data_in),.data_out(data_out));

    initial clk<=0;
    always #10 clk <= ~clk;
    initial 
    begin
        data_in <= 32'b00000000_00000000_00000000_00000000;
        ena <= 1;
        rst <= 0;

        #10 data_in <= 32'b10101010_10101010_10101010_10101010;
        #20 data_in <= 32'b01010101_01010101_01010101_01010101;
        #20 rst <= 1;

        #10 ena <= 0;
        data_in <= 32'b10101010_10101010_10101010_10101010;

        #20 $stop;
    end

endmodule
