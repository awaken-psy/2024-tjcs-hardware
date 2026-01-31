`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 08:13:30
// Design Name: 
// Module Name: encoder83_Pri
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


module encoder83_Pri(
    input [7:0] iData,
    input iEI,
    output reg [2:0] oData,
    output reg oEO
    );
    always @(*) begin
        if(~iEI & iData == 8'b1111_1111)  begin
           oEO = 1'b0;
           oData = 3'b111;
        end
        else begin
            oEO = 1'b1;
            casex(iData)
                8'b0xxx_xxxx: oData = 3'b000;
                8'b10xx_xxxx: oData = 3'b001;
                8'b110x_xxxx: oData = 3'b010;
                8'b1110_xxxx: oData = 3'b011;
                8'b1111_0xxx: oData = 3'b100;
                8'b1111_10xx: oData = 3'b101;
                8'b1111_110x: oData = 3'b110;
                8'b1111_1110: oData = 3'b111;
            endcase
        end
    end
endmodule
