`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 07:39:46
// Design Name: 
// Module Name: display7_tb
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


module display7_tb;
    reg [3:0]Data_in;
    wire [6:0]Data_out;
    display7 display7_test_1(.iData(Data_in),.oData(Data_out));
    initial begin
        #50 Data_in=4'b0000;
        #50 Data_in=4'b0001;
        #50 Data_in=4'b0010;
        #50 Data_in=4'b0011;
        #50 Data_in=4'b0100;
        #50 Data_in=4'b0101;
        #50 Data_in=4'b0110;
        #50 Data_in=4'b0111;
        #50 Data_in=4'b1000;
        #50 Data_in=4'b1001;
        
    end
endmodule
