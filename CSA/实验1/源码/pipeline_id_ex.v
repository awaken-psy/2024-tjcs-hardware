// ??-???????????
`timescale 1ns / 1ps

module decode_execute_pipeline_register(
    input               clock_input,
    input               reset_input,

    input               data_mem_enable_in,
    input               data_mem_write_in,
    input       [1:0]   data_mem_access_type_in,

    input       [31:0]  rs_operand_in,
    input       [31:0]  rt_operand_in,
    input       [4:0]   rd_write_addr_in,
    input               rd_select_in,
    input               rd_write_enable_in,

    input       [31:0]  immediate_value_in,
    input       [31:0]  shift_amount_in,

    input               alu_input_a_select_in,
    input               alu_input_b_select_in,
    input       [3:0]   alu_control_code_in,

    input               pipeline_stall,

    output reg          data_mem_enable_out,
    output reg          data_mem_write_out,
    output reg  [1:0]   data_mem_access_type_out,

    output reg  [31:0]  rs_operand_out,
    output reg  [31:0]  rt_operand_out,
    output reg  [4:0]   rd_write_addr_out,
    output reg          rd_select_out,
    output reg          rd_write_enable_out,

    output reg  [31:0]  immediate_value_out,
    output reg  [31:0]  shift_amount_out,

    output reg          alu_input_a_select_out,
    output reg          alu_input_b_select_out,
    output reg  [3:0]   alu_control_code_out
    );

    // ??????????
    always @ (posedge clock_input or posedge reset_input) 
    begin
        // ??????????????
        if(reset_input || pipeline_stall)
        begin
            data_mem_enable_out       <= 1'b0;
            data_mem_write_out        <= 1'b0;
            data_mem_access_type_out  <= 2'b00;

            rs_operand_out            <= 32'h00000000;
            rt_operand_out            <= 32'h00000000;
            rd_write_addr_out         <= 5'b00000;
            rd_select_out             <= 1'b0;
            rd_write_enable_out       <= 1'b0;

            immediate_value_out       <= 32'h00000000;
            shift_amount_out          <= 32'h00000000;

            alu_input_a_select_out    <= 1'b0;
            alu_input_b_select_out    <= 1'b0;
            alu_control_code_out      <= 4'b0000;
        end
        // ???????
        else 
        begin
            data_mem_enable_out       <= data_mem_enable_in;
            data_mem_write_out        <= data_mem_write_in;
            data_mem_access_type_out  <= data_mem_access_type_in;
            
            rs_operand_out            <= rs_operand_in;
            rt_operand_out            <= rt_operand_in;
            rd_write_addr_out         <= rd_write_addr_in;
            rd_select_out             <= rd_select_in;
            rd_write_enable_out       <= rd_write_enable_in;

            immediate_value_out       <= immediate_value_in;
            shift_amount_out          <= shift_amount_in;

            alu_input_a_select_out    <= alu_input_a_select_in;
            alu_input_b_select_out    <= alu_input_b_select_in;
            alu_control_code_out      <= alu_control_code_in;
        end
    end 
endmodule