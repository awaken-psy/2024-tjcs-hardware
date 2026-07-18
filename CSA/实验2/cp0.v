`include "mips_definitions.vh"
`timescale 1ns / 1ps

module cp0(
    input           clock_input,
    input           reset_input,
    input           move_from_cp0_enable,
    input           move_to_cp0_enable,
    input   [31:0]  program_counter_input,
    input   [4:0]   register_destination_code,
    input   [31:0]  write_data_input,
    input           exception_signal,
    input           exception_return,
    input   [4:0]   exception_cause_code,
    output  [31:0]  read_data_output,
    output  [31:0]  status_register,
    output  [31:0]  exception_address
);

    reg [31:0] cp0_register_array [0:31];
    integer register_index;

    always @(posedge clock_input or posedge reset_input) begin
        if (reset_input) begin
            for (register_index = 0; register_index < 32; register_index = register_index + 1) begin
                cp0_register_array[register_index] <= 32'h0;
            end
        end else if (move_to_cp0_enable) begin
            cp0_register_array[register_destination_code] <= write_data_input;
        end else if (exception_signal) begin
            cp0_register_array[`STATUS] <= { cp0_register_array[`STATUS][26:0], 5'b00000 };
            cp0_register_array[`CAUSE]  <= { 25'd0, exception_cause_code, 2'b00 };
            cp0_register_array[`EPC]    <= program_counter_input;
        end else if (exception_return) begin
            cp0_register_array[`STATUS] <= { 5'b00000, cp0_register_array[`STATUS][31:5] };
        end
    end
   
    assign status_register  = cp0_register_array[`STATUS];
    assign exception_address = exception_return ? cp0_register_array[`EPC] : 32'h00400004;  
    assign read_data_output = move_from_cp0_enable ? cp0_register_array[register_destination_code] : 32'hz;

endmodule