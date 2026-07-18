`timescale 1ns / 1ps

module board_top(
    input           system_clk,
    input           reset_signal,
    input           enable_signal,
    input  [2:0]    mode_switch,
    output [7:0]    segment_output,
    output [7:0]    selector_output
    );

    wire [31:0] data_to_display;
    wire [31:0] program_counter, current_instruction;
    wire [31:0] register_6_value;
    wire [31:0] register_7_value;
    wire [31:0] register_15_value;
    wire [31:0] register_16_value;

    wire        cpu_clock;
    reg [20:0]  clock_divider_counter;

    always @(posedge system_clk) begin
        clock_divider_counter <= clock_divider_counter + 21'd1;
    end
    
    assign cpu_clock = clock_divider_counter[19];  // Board implementation
    // assign cpu_clock = system_clk;               // Simulation

    multiplexer_8to32 display_mux(
        .input_0(program_counter),
        .input_1(current_instruction),
        .input_2(32'h0),
        .input_3(32'h0),
        .input_4(register_6_value),
        .input_5(register_7_value),
        .input_6(register_15_value),
        .input_7(register_16_value),
        .select_signal(mode_switch),
        .mux_output(data_to_display)
    );

    seven_segment_display display_unit(
        .clk_input(system_clk),
        .reset_input(reset_signal),
        .enable_input(1'b1),
        .data_input(data_to_display),
        .segment_output(segment_output),
        .selector_output(selector_output)
    );

    central_processing_unit cpu_instance(
        .cpu_clk(cpu_clock),
        .cpu_rst(reset_signal),
        .cpu_en(enable_signal),
        .pc_out(program_counter),
        .inst_out(current_instruction),
        .reg6_out(register_6_value),
        .reg7_out(register_7_value),
        .reg15_out(register_15_value),
        .reg16_out(register_16_value)
    );

endmodule