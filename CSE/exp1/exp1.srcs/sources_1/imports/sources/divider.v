`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 19:17:14
// Design Name: 
// Module Name: divider
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


module divider#(parameter num = 2)(
    input I_CLK,
    input rst,
    output reg O_CLK
    );
    integer i = 0;
    always @ (posedge I_CLK or posedge rst) begin
        if(rst == 1) begin
            O_CLK <= 0; i <= 0; end
        else begin
            if(i == num - 1) begin
                O_CLK <= ~O_CLK; i <= 0; end
            else begin
                i <= i + 1; end
        end
    end
endmodule
