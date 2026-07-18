// ????????????
`timescale 1ns / 1ps

module processor_core(
    input           clock_signal,
    input           reset_signal,
    
    input   [31:0]  initial_floor_value,
    input   [31:0]  initial_resistance_value,

    output  [31:0]  program_counter_output,
    output  [31:0]  current_instruction_output,

    output  [31:0]  total_attempts_result,
    output  [31:0]  total_broken_result,
    output          last_attempt_broken_status,
    output  [15:0]  upward_floor_output,         // ???????
    output  [15:0]  downward_floor_output        // ???????
    );
    
    // ??????????
    wire [31:0] instruction_fetch_pc;
    wire [31:0] instruction_fetch_next_pc;
    wire [31:0] instruction_fetch_inst;

    // ??????????
    wire [31:0] decode_next_pc_input;
    wire [31:0] decode_instruction_input;
    wire [4:0]  decode_ex_write_addr;
    wire [4:0]  decode_mem_write_addr;
    wire        decode_write_enable;
    wire        decode_ex_write_enable;
    wire        decode_mem_write_enable;

    wire        decode_data_mem_enable;
    wire        decode_data_mem_write;
    wire [1:0]  decode_data_mem_access;
    wire [31:0] decode_rs_operand;
    wire [31:0] decode_rt_operand;
    wire [4:0]  decode_rd_write_addr;
    wire        decode_rd_select;
    wire        decode_rd_write_enable;
    wire [31:0] decode_immediate_value;
    wire [31:0] decode_shift_amount;
    wire [1:0]  decode_pc_select;
    wire [31:0] decode_pc_branch_addr;
    wire [31:0] decode_pc_jump_addr;
    wire        decode_alu_a_select;
    wire        decode_alu_b_select;
    wire [3:0]  decode_alu_operation;
    wire        decode_pipeline_stall;
    wire        decode_branch_signal;

    // ????????
    wire        execute_data_mem_enable;
    wire        execute_data_mem_write;
    wire [1:0]  execute_data_mem_access;
    wire [31:0] execute_rs_operand;
    wire [31:0] execute_rt_operand;
    wire [4:0]  execute_rd_write_addr;
    wire        execute_rd_write_enable;
    wire        execute_rd_select;
    wire [31:0] execute_immediate_value;
    wire [31:0] execute_shift_amount;
    wire        execute_alu_a_select;
    wire        execute_alu_b_select;
    wire [3:0]  execute_alu_operation;
    wire        execute_stall_signal;

    wire        execute_out_data_mem_enable;
    wire        execute_out_data_mem_write;
    wire [1:0]  execute_out_data_mem_access;
    wire [31:0] execute_out_rs_operand;
    wire [31:0] execute_out_rt_operand;
    wire [4:0]  execute_out_rd_write_addr;
    wire        execute_out_rd_select;
    wire        execute_out_rd_write_enable;
    wire [31:0] execute_out_alu_result;

    // ???????????
    wire        memory_data_mem_enable;
    wire        memory_data_mem_write;
    wire [1:0]  memory_data_mem_access;
    wire [31:0] memory_rs_operand;
    wire [31:0] memory_rt_operand;
    wire [4:0]  memory_rd_write_addr;
    wire        memory_rd_select;
    wire        memory_rd_write_enable;
    wire [31:0] memory_alu_result;

    wire [4:0]  memory_out_rd_write_addr;
    wire        memory_out_rd_select;
    wire        memory_out_rd_write_enable;
    wire [31:0] memory_out_alu_result;
    wire [31:0] memory_out_data_mem_result;

    // ????????
    wire [4:0]  writeback_rd_write_addr;
    wire        writeback_rd_select;
    wire        writeback_rd_write_enable;
    wire [31:0] writeback_alu_result;
    wire [31:0] writeback_data_mem_result;

    wire [4:0]  writeback_out_rd_write_addr;
    wire        writeback_out_rd_write_enable;
    wire [31:0] writeback_out_rd_data;

    // ??????
    assign program_counter_output = instruction_fetch_pc;
    assign current_instruction_output = instruction_fetch_inst;

    // ?????????
    instruction_fetch_stage fetch_stage_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),
        .stall_signal(decode_pipeline_stall),

        .branch_target_address(decode_pc_branch_addr),
        .jump_target_address(decode_pc_jump_addr),
        .program_counter_select(decode_pc_select),

        .current_pc(instruction_fetch_pc),
        .next_pc(instruction_fetch_next_pc),
        .fetched_instruction(instruction_fetch_inst)
    );

    // ??-????????
    fetch_decode_register fetch_decode_register_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),

        .next_pc_input(instruction_fetch_next_pc),
        .instruction_input(instruction_fetch_inst),

        .stall_signal(decode_pipeline_stall),
        .branch_signal(decode_branch_signal),

        .next_pc_output(decode_next_pc_input),
        .instruction_output(decode_instruction_input)
    );

    // ?????????
    decode_stage decode_stage_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),

        .next_pc_input(decode_next_pc_input),
        .instruction_input(decode_instruction_input),

        .execute_write_addr(execute_out_rd_write_addr),
        .memory_write_addr(memory_out_rd_write_addr),
        .execute_write_enable(execute_out_rd_write_enable),
        .memory_write_enable(memory_out_rd_write_enable),

        .writeback_register_addr(writeback_out_rd_write_addr),
        .writeback_register_data(writeback_out_rd_data),
        .writeback_register_enable(writeback_out_rd_write_enable),

        .initial_floor_config(initial_floor_value),
        .initial_resistance_config(initial_resistance_value),

        .rs_operand_output(decode_rs_operand),
        .rt_operand_output(decode_rt_operand),
        .rd_write_addr_output(decode_rd_write_addr),
        .rd_write_enable_output(decode_rd_write_enable),
        .rd_select_output(decode_rd_select),
        .immediate_value_output(decode_immediate_value),
        .shift_amount_output(decode_shift_amount),

        .data_memory_enable(decode_data_mem_enable),
        .data_memory_write(decode_data_mem_write),
        .data_memory_access_type(decode_data_mem_access),

        .alu_input_a_select(decode_alu_a_select),
        .alu_input_b_select(decode_alu_b_select),
        .alu_operation_code(decode_alu_operation),

        .pc_selection_signal(decode_pc_select),
        .pc_branch_address(decode_pc_branch_addr),
        .pc_jump_address(decode_pc_jump_addr),

        .pipeline_stall_signal(decode_pipeline_stall),
        .branch_condition_signal(decode_branch_signal),

        .attempt_count_result(total_attempts_result),
        .broken_count_result(total_broken_result),
        .last_broken_status_result(last_attempt_broken_status),
        
        .upward_floor_count(upward_floor_output),
        .downward_floor_count(downward_floor_output)
    );

    // ??-????????
    decode_execute_register decode_execute_register_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),

        .data_mem_enable_input(decode_data_mem_enable),
        .data_mem_write_input(decode_data_mem_write),
        .data_mem_access_input(decode_data_mem_access),

        .rs_operand_input(decode_rs_operand),
        .rt_operand_input(decode_rt_operand),

        .rd_write_addr_input(decode_rd_write_addr),
        .rd_select_input(decode_rd_select),
        .rd_write_enable_input(decode_rd_write_enable),

        .alu_input_a_select(decode_alu_a_select),
        .alu_input_b_select(decode_alu_b_select),
        .alu_operation_code(decode_alu_operation),

        .immediate_value_input(decode_immediate_value),
        .shift_amount_input(decode_shift_amount),

        .stall_signal_input(decode_pipeline_stall),

        .data_mem_enable_output(execute_data_mem_enable),
        .data_mem_write_output(execute_data_mem_write),
        .data_mem_access_output(execute_data_mem_access),

        .rs_operand_output(execute_rs_operand),
        .rt_operand_output(execute_rt_operand),
        .rd_write_addr_output(execute_rd_write_addr),
        .rd_select_output(execute_rd_select),
        .rd_write_enable_output(execute_rd_write_enable),

        .alu_input_a_select_output(execute_alu_a_select),
        .alu_input_b_select_output(execute_alu_b_select),
        .alu_operation_code_output(execute_alu_operation),

        .immediate_value_output(execute_immediate_value),
        .shift_amount_output(execute_shift_amount)
    );

    // ?????????
    execute_stage execute_stage_unit(
        .reset_input(reset_signal),

        .data_mem_enable_input(execute_data_mem_enable),
        .data_mem_write_input(execute_data_mem_write),
        .data_mem_access_input(execute_data_mem_access),

        .rs_operand_input(execute_rs_operand),
        .rt_operand_input(execute_rt_operand),
        .rd_write_addr_input(execute_rd_write_addr),
        .rd_select_input(execute_rd_select),
        .rd_write_enable_input(execute_rd_write_enable),

        .immediate_value_input(execute_immediate_value),
        .shift_amount_input(execute_shift_amount),

        .alu_input_a_select(execute_alu_a_select),
        .alu_input_b_select(execute_alu_b_select),
        .alu_operation_code(execute_alu_operation),
        
        .data_mem_enable_output(execute_out_data_mem_enable),
        .data_mem_write_output(execute_out_data_mem_write),
        .data_mem_access_output(execute_out_data_mem_access),

        .rs_operand_output(execute_out_rs_operand),
        .rt_operand_output(execute_out_rt_operand),
        .rd_write_addr_output(execute_out_rd_write_addr),
        .rd_select_output(execute_out_rd_select),
        .rd_write_enable_output(execute_out_rd_write_enable),

        .alu_result_output(execute_out_alu_result)
    );

    // ??-?????????
    execute_memory_register execute_memory_register_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),

        .data_mem_enable_input(execute_out_data_mem_enable),
        .data_mem_write_input(execute_out_data_mem_write),
        .data_mem_access_input(execute_out_data_mem_access),

        .rs_operand_input(execute_out_rs_operand),
        .rt_operand_input(execute_out_rt_operand),
        .rd_write_addr_input(execute_out_rd_write_addr),
        .rd_select_input(execute_out_rd_select),
        .rd_write_enable_input(execute_out_rd_write_enable),
        
        .alu_result_input(execute_out_alu_result),

        .data_mem_enable_output(memory_data_mem_enable),
        .data_mem_write_output(memory_data_mem_write),
        .data_mem_access_output(memory_data_mem_access),

        .rs_operand_output(memory_rs_operand),
        .rt_operand_output(memory_rt_operand),
        .rd_write_addr_output(memory_rd_write_addr),
        .rd_select_output(memory_rd_select),
        .rd_write_enable_output(memory_rd_write_enable),

        .alu_result_output(memory_alu_result)
    );

    // ????????????
    memory_access_stage memory_stage_unit(
        .clock_input(clock_signal),

        .data_mem_enable_input(memory_data_mem_enable),
        .data_mem_write_input(memory_data_mem_write),
        .data_mem_access_input(memory_data_mem_access),

        .rs_operand_input(memory_rs_operand),
        .rt_operand_input(memory_rt_operand),
        .rd_write_addr_input(memory_rd_write_addr),
        .rd_select_input(memory_rd_select),
        .rd_write_enable_input(memory_rd_write_enable),

        .alu_result_input(memory_alu_result),

        .rd_write_addr_output(memory_out_rd_write_addr),
        .rd_write_enable_output(memory_out_rd_write_enable),
        .rd_select_output(memory_out_rd_select),

        .alu_result_output(memory_out_alu_result),

        .data_memory_result(memory_out_data_mem_result)
    );

    // ???-????????
    memory_writeback_register memory_writeback_register_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),

        .rd_write_addr_input(memory_out_rd_write_addr),
        .rd_select_input(memory_out_rd_select),
        .rd_write_enable_input(memory_out_rd_write_enable),

        .alu_result_input(memory_out_alu_result),
        .data_mem_result_input(memory_out_data_mem_result),

        .rd_write_addr_output(writeback_rd_write_addr),
        .rd_select_output(writeback_rd_select),
        .rd_write_enable_output(writeback_rd_write_enable),

        .alu_result_output(writeback_alu_result),
        .data_mem_result_output(writeback_data_mem_result)
    );

    // ?????????
    writeback_stage writeback_stage_unit(
        .rd_write_addr_input(writeback_rd_write_addr),
        .rd_select_input(writeback_rd_select),
        .rd_write_enable_input(writeback_rd_write_enable),

        .alu_result_input(writeback_alu_result),
        .data_mem_result_input(writeback_data_mem_result),

        .rd_write_addr_output(writeback_out_rd_write_addr),
        .rd_write_data_output(writeback_out_rd_data),
        .rd_write_enable_output(writeback_out_rd_write_enable)
    );

endmodule