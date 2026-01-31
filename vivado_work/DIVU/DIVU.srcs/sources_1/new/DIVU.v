`timescale 1ns / 1ps

module DIVU (
    input [31:0] dividend,
    input [31:0] divisor,
    input start,
    input clock,
    input reset,
    output [31:0] q,
    output [31:0] r,
    output reg busy
);

    reg [4:0] step_counter;
    reg [31:0] quotient_reg;
    reg [31:0] remainder_reg;
    reg [31:0] divisor_reg;
    reg remainder_negative_flag;

    wire [32:0] arithmetic_result = remainder_negative_flag ? 
        ({remainder_reg, quotient_reg[31]} + {1'b0, divisor_reg}) : 
        ({remainder_reg, quotient_reg[31]} - {1'b0, divisor_reg});
    
    assign r = remainder_negative_flag ? remainder_reg + divisor_reg : remainder_reg;
    assign q = quotient_reg;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            step_counter <= 5'd0;
            busy <= 1'b0;
        end else begin
            if (start) begin
                remainder_reg <= 32'd0;
                remainder_negative_flag <= 1'b0;
                quotient_reg <= dividend;
                divisor_reg <= divisor;
                step_counter <= 5'd0;
                busy <= 1'b1;
            end else if (busy) begin
                remainder_reg <= arithmetic_result[31:0];
                remainder_negative_flag <= arithmetic_result[32];
                quotient_reg <= {quotient_reg[30:0], ~arithmetic_result[32]};
                step_counter <= step_counter + 5'd1;
                
                if (step_counter == 5'd31) begin
                    busy <= 1'b0;
                end
            end
        end
    end

endmodule

