`timescale 1ns / 1ps

module DIVU_test();

    // Input stimulus
    reg [31:0] dividend_val;
    reg [31:0] divisor_val;
    wire division_start;
    reg division_request;
    reg clk_signal;
    reg reset_signal;
    
    // Output monitoring
    wire [31:0] quotient_out;
    wire [31:0] remainder_out;
    wire divider_busy;

    // Start condition: when division is requested and divider isn't busy
    assign division_start = division_request & ~divider_busy;

    // Unit Under Test instantiation
    DIVU divider_unit (
        .dividend(dividend_val),
        .divisor(divisor_val),
        .start(division_start),
        .clock(clk_signal),
        .reset(reset_signal),
        .q(quotient_out),
        .r(remainder_out),
        .busy(divider_busy)
    );

    // Test sequence initialization
    initial begin
        clk_signal = 0;
        reset_signal = 1;  // Active high reset
        division_request = 0;
        dividend_val = 524;  // Test dividend
        divisor_val = 13;    // Test divisor
        
        // Release reset after 50ns
        #50 reset_signal = 0;
        // Trigger division after 5ns
        #5 division_request = 1;
        // Clear request after 20ns
        #20 division_request = 0;
    end

    // Clock generation (period = 20ns)
    always begin
        #10 clk_signal = !clk_signal;
    end

endmodule