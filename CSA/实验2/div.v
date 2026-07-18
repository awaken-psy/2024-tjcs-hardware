`timescale 1ns / 1ps

module div(
    input           reset_input,
    input           enable_signal,
    input           signed_operation,
    input [31:0]    dividend,
    input [31:0]    divisor,
    output [31:0]   quotient_output,
    output [31:0]   remainder_output
);

    reg quotient_negative;
    reg remainder_negative;
    reg [63:0] current_dividend;
    reg [63:0] current_divisor;
    integer iteration_index;
    
    always @(*) begin
        if (reset_input) begin
            current_dividend  <= 64'h0;
            current_divisor   <= 64'h0;
            quotient_negative <= 1'b0;
            remainder_negative <= 1'b0;
        end else if (enable_signal) begin
            if (signed_operation) begin
                current_dividend = dividend;
                current_divisor = { divisor, 32'h0 };
                
                for (iteration_index = 0; iteration_index < 32; iteration_index = iteration_index + 1) begin
                    current_dividend = current_dividend << 1;
                    if (current_dividend >= current_divisor) begin
                        current_dividend = current_dividend - current_divisor;
                        current_dividend = current_dividend + 1;
                    end
                end
            end else begin
                current_dividend  = dividend;
                current_divisor   = { divisor, 32'h0 };
                quotient_negative = dividend[31] ^ divisor[31];
                remainder_negative = dividend[31];
                
                if (dividend[31]) begin
                    current_dividend = dividend ^ 32'hffffffff;
                    current_dividend = current_dividend + 32'h1;
                end
                
                if (divisor[31]) begin
                    current_divisor = { divisor ^ 32'hffffffff, 32'h0 };
                    current_divisor = current_divisor + 64'h0000000100000000;
                end
                
                for (iteration_index = 0; iteration_index < 32; iteration_index = iteration_index + 1) begin
                    current_dividend = current_dividend << 1;
                    if (current_dividend >= current_divisor) begin
                        current_dividend = current_dividend - current_divisor;
                        current_dividend = current_dividend + 1;
                    end
                end
                
                if (remainder_negative) begin
                    current_dividend = current_dividend ^ 64'hffffffff00000000;
                    current_dividend = current_dividend + 64'h0000000100000000;
                end
                
                if (quotient_negative) begin
                    current_dividend = current_dividend ^ 64'h00000000ffffffff;
                    current_dividend = current_dividend + 64'h0000000000000001;
                    if (current_dividend[31:0] == 32'h0) begin
                        current_dividend = current_dividend - 64'h0000000100000000;
                    end
                end
            end
        end
    end
    
    assign quotient_output = enable_signal ? current_dividend[31:0] : 32'h0;
    assign remainder_output = enable_signal ? current_dividend[63:32] : 32'h0;

endmodule