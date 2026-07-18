`timescale 1ns / 1ps

module openmips_board(
    input clk_in,
    input reset,
    input en_clk,
    input [1:0] choose,
    output [7:0] o_seg,
    output [7:0] o_sel
    );

    wire clk_cpu;
    wire clk_seg;
    wire [31:0] i_data;
    wire [31:0] inst, pc, result;

    divider#(4) div_seg (clk_in, reset, clk_seg);
    divider#(100000) div_cpu (clk_in, reset, clk_cpu);
    seg7x16 seg7 (clk_seg, reset, i_data, o_seg, o_sel);
    assign i_data = (choose[1]) ? inst :((choose[0]) ? pc : result);

    wire clk_real;
    assign clk_real = en_clk ? clk_seg : clk_cpu;
    openmips_min_sopc docpu_top(clk_real, reset, pc, inst, result);

endmodule
