`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 16:54:21
// Design Name: 
// Module Name: selector41_tb
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


module selector41_tb;
    reg [3:0]Data_0;
    reg [3:0]Data_1;
    reg [3:0]Data_2;
    reg [3:0]Data_3;
    reg iS0;
    reg iS1;
    wire [3:0]Z;

    selector41 selector41_test_1(.iC0(Data_0),.iC1(Data_1),.iC2(Data_2),.iC3(Data_3),.iS0(iS0),.iS1(iS1),.oZ(Z));
    initial begin
    Data_0 = 4'b0111;
    Data_1 = 4'b1011;
    Data_2 = 4'b1101;
    Data_3 = 4'b1110;
    #100 begin iS1 = 0 ; iS0 = 0; end
    #100 begin iS1 = 0 ; iS0 = 1; end
    #100 begin iS1 = 1 ; iS0 = 0; end
    #100 begin iS1 = 1 ; iS0 = 1; end
    end


endmodule
