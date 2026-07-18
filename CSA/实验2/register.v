`timescale 1ns / 1ps

module data_register(
    input               clock_signal, 
    input               reset_signal, 
    input               enable_signal, 
    input       [31:0]  input_data, 
    output reg  [31:0]  output_data 
    );
    
    always @(negedge clock_signal or posedge reset_signal) begin
        if (reset_signal) 
            output_data <= 32'b0;
        else if (enable_signal) 
            output_data <= input_data;
    end

endmodule