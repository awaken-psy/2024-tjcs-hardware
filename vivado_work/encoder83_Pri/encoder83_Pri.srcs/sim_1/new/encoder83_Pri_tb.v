`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 08:13:46
// Design Name: 
// Module Name: encoder83_Pri_tb
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


module encoder83_Pri_tb;
    reg [7:0] Data_in;
    reg EI;
    wire [2:0] Data_out;
    wire EO;
    encoder83_Pri encoder83_Pri_test_1(.iEI(EI),.oEO(EO),.iData(Data_in),.oData(Data_out));
    initial begin
    #10 begin EI=0;Data_in=8'b0000_0000;end
    #10 begin EI=0;Data_in=8'b1000_0000;end
    #10 begin EI=0;Data_in=8'b1100_0000;end
    #10 begin EI=0;Data_in=8'b1110_0000;end
    #10 begin EI=0;Data_in=8'b1111_0000;end
    #10 begin EI=0;Data_in=8'b1111_1000;end
    #10 begin EI=0;Data_in=8'b1111_1100;end
    #10 begin EI=0;Data_in=8'b1111_1110;end
    #10 begin EI=0;Data_in=8'b1111_1111;end
    end
endmodule
