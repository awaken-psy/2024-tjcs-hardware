`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 07:34:38
// Design Name: 
// Module Name: display7
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


module display7(
    input [3:0] iData,
    output reg [6:0] oData
    );
    always @(*) begin
            case(iData)
                4'b0000: oData = 7'b100_0000;
                4'b0001: oData = 7'b111_1001;
                4'b0010: oData = 7'b010_0100;
                4'b0011: oData = 7'b011_0000;
                4'b0100: oData = 7'b001_1001;
                4'b0101: oData = 7'b001_0010;
                4'b0110: oData = 7'b000_0010;
                4'b0111: oData = 7'b111_1000;
                4'b1000: oData = 7'b000_0000;
                4'b1001: oData = 7'b001_0000;
            endcase
        end
endmodule
