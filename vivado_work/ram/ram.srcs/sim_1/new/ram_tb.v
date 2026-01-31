`timescale 1ns / 1ps

module ram_tb;

reg clk;
    reg ena;
    reg wena;
    reg [4:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;

    ram uut (.clk(clk),.ena(ena),.wena(wena),.addr(addr),.data_in(data_in),.data_out(data_out));

    initial begin
        clk = 0;
         ena = 0;
        wena = 0;
        addr = 0;
        data_in = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        ena = 1;         
        wena = 1;         
        addr = 5'd0;  
        data_in = 32'hDEADBEEF; 
        #10;           



        addr = 5'd1;     
        #10;        


        wena = 0;       
        addr = 5'd0;
        #10;



        addr = 5'd1; 
        data_in = 32'hCAFEBABE;
        #10;



        ena = 1;         
        wena = 1;         
        addr = 5'd0;  
        data_in = 32'hDDADEEFD; 
        #10;           
      
        addr = 5'd1; 
        data_in = 32'hAADFDCBA;
        #10;


        ena = 0;      
        #10;


        $stop;
    end



endmodule
