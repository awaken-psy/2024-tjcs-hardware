`timescale 1ns / 1ps

module pcreg(
    input clk,
    input rst,
    input ena,
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    always @(posedge clk or rst==1'b1)
    begin
        if(rst==1) data_out = 32'b00000000_00000000_00000000_00000000;
        else if(ena==1) data_out = data_in;
    end
endmodule
