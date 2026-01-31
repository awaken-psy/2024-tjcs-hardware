`timescale 1ns / 1ps


module ram2_tb;
    reg clk;
    reg ena;
    reg wena;
    reg [4:0] addr;
    reg [31:0] data_in;
    wire [31:0] data;

    ram2 uut (.clk(clk),.ena(ena),.wena(wena),.addr(addr),.data(data));

    assign data = (ena && wena) ? data_in : 32'bz;

    initial begin
        forever #5 clk=~clk;
    end

    initial begin
        clk = 0;
        ena = 0;
        wena = 0;
        addr = 0;
        data_in = 0;

        #10;ena = 1;wena = 1;addr = 5'b00001;data_in = 32'hD0D010D0;
        #10;wena = 0;data_in=32'hEAFFFCDB;
        #10;ena = 1;wena = 1;addr = 5'b00101000;
        #10;data_in = 32'hB1B1B1B1;ena=0;
        #10;ena=1;wena = 0;
        #10;$stop;
    end
endmodule
