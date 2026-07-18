`include "mips_definitions.vh"
`timescale 1ns / 1ps

module compare(
    input           clock_input,
    input           reset_input,
    input [31:0]    operand_a, 
    input [31:0]    operand_b,
    input [5:0]     opcode,
    input [5:0]     function_code,
    input           exception_signal,
    output reg      branch_decision
    );
    
    always @(*) begin
        if(reset_input) begin
            branch_decision <= 1'b0;
        end else if(exception_signal) begin
            branch_decision <= 1'b1;
        end else if(opcode == `OPCODE_BEQ) begin
            branch_decision <= (operand_a == operand_b);
        end else if(opcode == `OPCODE_BNE) begin
            branch_decision <= (operand_a != operand_b);
        end else if(opcode == `OPCODE_BGEZ) begin
            branch_decision <= (operand_a >= 32'h0);
        end else if(opcode == `OPCODE_J) begin
            branch_decision <= 1'b1;
        end else if(opcode == `OPCODE_JR && function_code == `FUNC_JR) begin
            branch_decision <= 1'b1;
        end else if(opcode == `OPCODE_JAL) begin
            branch_decision <= 1'b1;
        end else if(opcode == `OPCODE_JALR && function_code == `FUNC_JALR) begin
            branch_decision <= 1'b1;
        end else if(opcode == `OPCODE_TEQ && function_code == `FUNC_TEQ) begin
            branch_decision <= (operand_a == operand_b);
        end else begin
            branch_decision <= 1'b0;
        end
    end
    
endmodule-