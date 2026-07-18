`timescale 1ns / 1ps

module alu (
    input [31:0]    operand_a,    
    input [31:0]    operand_b, 
    input [3:0]     alu_control,
    output [31:0]   result,
    output          zero_flag,
    output          carry_flag, 
    output          negative_flag, 
    output          overflow_flag
    );

    wire signed [31:0] signed_operand_a, signed_operand_b;
    reg [32:0] computation_result;
    
    assign signed_operand_a = operand_a;
    assign signed_operand_b = operand_b;

    always @(*) begin
        case(alu_control)
            4'b0000: computation_result = operand_a + operand_b;
            4'b0010: computation_result = signed_operand_a + signed_operand_b;
            4'b0001: computation_result = operand_a - operand_b;
            4'b0011: computation_result = signed_operand_a - signed_operand_b;
            4'b0100: computation_result = operand_a & operand_b;
            4'b0101: computation_result = operand_a | operand_b;
            4'b0110: computation_result = operand_a ^ operand_b;
            4'b0111: computation_result = ~(operand_a | operand_b);
            4'b1000: computation_result = { operand_b[15:0], 16'h0 };
            4'b1001: computation_result = { operand_b[15:0], 16'h0 };
            4'b1011: computation_result = (signed_operand_a < signed_operand_b);
            4'b1010: computation_result = (operand_a < operand_b);
            4'b1100: begin
                if(operand_a == 32'h0) 
                    { computation_result[31:0], computation_result[32] } = { signed_operand_b, 1'b0 };
                else
                    { computation_result[31:0], computation_result[32] } = signed_operand_b >>> (operand_a - 1);
            end
            4'b1110: computation_result = operand_b << operand_a;
            4'b1111: computation_result = operand_b << operand_a;
            4'b1101: begin
                if(operand_a == 32'h0) 
                    { computation_result[31:0], computation_result[32] } = { operand_b, 1'b0 };
                else
                    { computation_result[31:0], computation_result[32] } = operand_b >> (operand_a - 1);
            end
            default: computation_result = 33'h0;
        endcase
    end
    
    assign result = computation_result[31:0];
    assign zero_flag = (computation_result[31:0] == 32'h0);
    assign carry_flag = computation_result[32];
    assign overflow_flag = computation_result[32] ^ computation_result[31];
    assign negative_flag = computation_result[31];
    
endmodule