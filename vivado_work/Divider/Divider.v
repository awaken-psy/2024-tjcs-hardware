`timescale 1ns / 1ps

module Divider(
    input I_CLK,
    input rst,
    output O_CLK
    );
    parameter NUM_DIV = 20;
    reg [$clog2(NUM_DIV)-1:0] count;
    reg clk_temp;
    initial clk_temp=0;
    always @(posedge I_CLK) begin
            if (rst) begin count <= 0;clk_temp <= 0; end 
            else begin
                if (count == NUM_DIV/2 - 1) begin clk_temp<=~clk_temp;count <= 0; end 
                else begin count <= count + 1; end
            end
        end
    assign O_CLK = clk_temp;
endmodule
