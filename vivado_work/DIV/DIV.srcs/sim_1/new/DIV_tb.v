`timescale 1ns / 1ps

module DIV_tb();

    // Input Stimulus
    reg  [31:0] dividend_input;
    reg  [31:0] divisor_input;
    reg         division_enable;
    reg         clock_signal;
    reg         reset_signal;
    
    // Output Monitoring
    wire [31:0] quotient_output;
    wire [31:0] remainder_output;
    wire        busy_status;
    
    // Control Signals
    wire        start_operation = division_enable & ~busy_status;

    // Instantiate DUT
    DIV u_DIV (
        .dividend (dividend_input),
        .divisor  (divisor_input),
        .start    (start_operation),
        .clock    (clock_signal),
        .reset    (reset_signal),
        .q        (quotient_output),
        .r        (remainder_output),
        .busy     (busy_status)
    );

    // Test Sequence
    initial begin
        // Initialize
        clock_signal     = 0;
        reset_signal     = 1;
        division_enable  = 0;
        dividend_input   = -5;
        divisor_input    = -2;
        
        // Release reset
        #50 reset_signal = 0;
        
        // Trigger division
        #5 division_enable = 1;
        #20 division_enable = 0;
    end

    // Clock Generation (100MHz)
    always begin
        #10 clock_signal = ~clock_signal;
    end

endmodule