`timescale 1ns / 1ps

module multiplier(  
    input           reset_input,
    input           enable_signal,     
    input           signed_operation, 
    input [31:0]    operand_a,
    input [31:0]    operand_b,
    output [31:0]   high_result,
    output [31:0]   low_result
);

    reg [31:0] absolute_operand_a;
    reg [31:0] absolute_operand_b;
    reg [63:0] partial_product;
    reg [63:0] final_product;
    reg result_sign;

    integer bit_position;
    
    always @(*) begin
        if (reset_input) begin
            absolute_operand_a <= 32'h0;
            absolute_operand_b <= 32'h0;
            final_product     <= 64'h0;
            result_sign       <= 1'b0;
        end else if (enable_signal) begin
            if (operand_a == 32'h0 || operand_b == 32'h0) begin
                final_product <= 64'h0;
            end else if (~signed_operation) begin
                // Unsigned multiplication
                final_product = 64'h0;
                for (bit_position = 0; bit_position < 32; bit_position = bit_position + 1) begin
                    partial_product = operand_b[bit_position] ? ({ 32'h0, operand_a } << bit_position) : 64'h0;
                    final_product = final_product + partial_product;
                end
            end else begin
                // Signed multiplication
                final_product = 64'h0;
                result_sign = operand_a[31] ^ operand_b[31];
                absolute_operand_a = operand_a;
                absolute_operand_b = operand_b;
                
                if (operand_a[31]) begin
                    absolute_operand_a = operand_a ^ 32'hffffffff;
                    absolute_operand_a = absolute_operand_a + 32'h1;
                end
                
                if (operand_b[31]) begin
                    absolute_operand_b = operand_b ^ 32'hffffffff;
                    absolute_operand_b = absolute_operand_b + 32'h1;
                end
                
                for (bit_position = 0; bit_position < 32; bit_position = bit_position + 1) begin
                    partial_product = absolute_operand_b[bit_position] ? ({ 32'h0, absolute_operand_a } << bit_position) : 64'h0;
                    final_product = final_product + partial_product;
                end
                
                if (result_sign) begin
                    final_product = final_product ^ 64'hffffffffffffffff;
                    final_product = final_product + 64'h1;
                end
            end
        end
    end

    assign low_result = enable_signal ? final_product[31:0]  : 32'h0;
    assign high_result = enable_signal ? final_product[63:32] : 32'h0;
    
endmodule