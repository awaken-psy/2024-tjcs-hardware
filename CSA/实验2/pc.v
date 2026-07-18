`timescale 1ns / 1ps

module program_counter(
    input               clock_input,
    input               reset_input,
    input               enable_input,
    input               stall_input,
    input [31:0]        next_pc_value,
    output reg [31:0]   current_pc_value
);

    always @(posedge clock_input or posedge reset_input) begin
        if (reset_input) begin
            current_pc_value <= 32'h00400000;
        end else if (~stall_input) begin
            if (enable_input) begin
                current_pc_value <= next_pc_value;
            end
        end
    end

endmodule