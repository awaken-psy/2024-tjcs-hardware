`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 05:38:31
// Design Name: 
// Module Name: encoder83_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module encoder83_tb();
    reg [7:0]Data_in;
    wire [2:0]Data_out;
    encoder83 encoder83_test_1(.iData(Data_in),.oData(Data_out));
    initial begin
        #50 Data_in=8'b0000_0001;
        #50 Data_in=8'b0000_0010;
        #50 Data_in=8'b0000_0100;
        #50 Data_in=8'b0000_1000;
        #50 Data_in=8'b0001_0000;
        #50 Data_in=8'b0010_0000;
        #50 Data_in=8'b0100_0000;
        #50 Data_in=8'b1000_0000;
    end
endmodule
