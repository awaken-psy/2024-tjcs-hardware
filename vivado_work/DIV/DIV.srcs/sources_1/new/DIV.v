`timescale 1ns / 1ps

module DIV (
    input      [31:0] dividend,
    input      [31:0] divisor,
    input             start,
    input             clock,
    input             reset,
    output     [31:0] q,
    output     [31:0] r,
    output reg        busy
);

    reg  [4:0]  cycle_counter;
    reg  [31:0] quotient_reg;
    reg  [31:0] remainder_reg;
    reg  [31:0] divisor_reg;
    reg         remainder_sign_flag;
    reg         dividend_sign_reg;
    reg         divisor_sign_reg;
    
    wire [31:0] final_quotient;
    wire [31:0] final_remainder;
    wire [32:0] add_sub_result = remainder_sign_flag ? 
                                ({remainder_reg, quotient_reg[31]} + {1'b0, divisor_reg}) : 
                                ({remainder_reg, quotient_reg[31]} - {1'b0, divisor_reg});
    
    assign final_remainder = remainder_sign_flag ? remainder_reg + divisor_reg : remainder_reg;
    assign final_quotient = quotient_reg;
    assign r = dividend_sign_reg ? -final_remainder : final_remainder;
    assign q = (dividend_sign_reg ^ divisor_sign_reg) ? -final_quotient : final_quotient;

    always @(posedge clock or posedge reset) begin
        if (reset == 1) begin                  
            cycle_counter <= 5'b0;
            busy         <= 0;
        end 
        else begin
            if (start) begin                    
                remainder_reg        <= 32'b0;
                remainder_sign_flag  <= 0;
                
                if (dividend[31] == 0) begin
                    quotient_reg <= dividend;
                end 
                else begin
                    quotient_reg <= -dividend;
                end
                
                if (divisor[31] == 0) begin
                    divisor_reg <= divisor;
                end 
                else begin
                    divisor_reg <= -divisor;
                end
                
                dividend_sign_reg <= dividend[31];
                divisor_sign_reg  <= divisor[31];
                cycle_counter    <= 5'b0;
                busy             <= 1'b1;
            end 
            else if (busy) begin                    
                remainder_reg       <= add_sub_result[31:0];                 
                remainder_sign_flag <= add_sub_result[32];               
                quotient_reg        <= {quotient_reg[30:0], ~add_sub_result[32]};
                cycle_counter       <= cycle_counter + 5'b1;                 
                
                if (cycle_counter == 5'h1f) begin
                    busy <= 0;  
                end     
            end
        end
    end

endmodule