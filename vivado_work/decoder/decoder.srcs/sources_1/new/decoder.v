`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/13 21:07:46
// Design Name: 
// Module Name: decoder
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


module decoder(
    input [2:0] iData,
    input [1:0] iEna,
    output reg [7:0] oData
    );
    always @(*) begin
        if(iEna[1]&!iEna[0])  begin
            case (iData)
                3'b000: oData = 8'b1111_1110;
                3'b001: oData = 8'b1111_1101;
                3'b010: oData = 8'b1111_1011;
                3'b011: oData = 8'b1111_0111;
                3'b100: oData = 8'b1110_1111;
                3'b101: oData = 8'b1101_1111;
                3'b110: oData = 8'b1011_1111;
                3'b111: oData = 8'b0111_1111;
            endcase
        end
        else 
            oData = 8'b1111_1111;
    end
endmodule
