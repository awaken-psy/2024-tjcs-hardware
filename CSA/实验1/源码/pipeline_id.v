// 指令译码阶段处理模块
`timescale 1ns / 1ps

module instruction_decode_stage(
    input           clock_signal,
    input           reset_signal,

    input   [31:0]  next_pc_input,
    input   [31:0]  current_instruction,
 
    input   [4:0]   execute_write_addr,
    input   [4:0]   memory_write_addr,
    input           execute_write_enable,
    input           memory_write_enable,

    input   [4:0]   writeback_register_addr,
    input           writeback_register_enable,
    input   [31:0]  writeback_register_data,

    input   [31:0]  initial_floor_config,
    input   [31:0]  initial_resistance_config,

    output  [31:0]      rs_operand_output,
    output  [31:0]      rt_operand_output,
    output  [4:0]       rd_write_addr_output,
    output              rd_select_output,
    output              rd_write_enable_output,
    output  [31:0]      immediate_value_output,
    output  [31:0]      shift_amount_output,

    output              data_memory_enable,
    output              data_memory_write,
    output  [1:0]       data_memory_access_type,

    output  [31:0]      pc_branch_address,
    output  [31:0]      pc_jump_address,
    output  [1:0]       pc_selection_signal,

    output              alu_input_a_select,
    output              alu_input_b_select,
    output [3:0]        alu_operation_code,

    output              pipeline_stall_signal,
    output              branch_condition_signal,

    output  [31:0]      total_attempts_result,
    output  [31:0]      total_broken_result,
    output              last_attempt_broken_status,
    output [15:0] upward_floor_output,
    output [15:0] downward_floor_output
    );

    // 指令字段解析
    wire [5:0] opcode_field   = current_instruction[31:26];
    wire [5:0] function_field = current_instruction[ 5: 0];
    wire [4:0] rs_address     = current_instruction[25:21];
    wire [4:0] rt_address     = current_instruction[20:16];
    wire [4:0] rd_address     = current_instruction[15:11];

    // 控制信号
    wire rs_read_enable, rt_read_enable;
    wire sign_extension_flag;

    // 立即数符号扩展
    assign immediate_value_output = { { 16{ sign_extension_flag & current_instruction[15] } }, 
                                     current_instruction[15:0] };
    
    // 移位量处理
    assign shift_amount_output = { 27'b0, current_instruction[10:6] };

    // 分支地址计算
    assign pc_branch_address = next_pc_input + 
                              { { 14{ current_instruction[15] }}, 
                                current_instruction[15:0], 2'b0 };
    
    // 跳转地址计算
    assign pc_jump_address = { next_pc_input[31:28], 
                              current_instruction[25:0], 2'b0 };

    // 分支条件判断
    assign branch_condition_signal = 
        ((opcode_field == 6'b000100) && (rs_operand_output == rt_operand_output)) || 
        ((opcode_field == 6'b000101) && (rs_operand_output != rt_operand_output)) || 
        (opcode_field == 6'b000010);

    // 寄存器文件实例化
    register_file register_file_unit(
        .clock_input(clock_signal),
        .reset_input(reset_signal),

        .rs_read_enable(rs_read_enable),
        .rt_read_enable(rt_read_enable),
        .rd_write_enable(writeback_register_enable),
        .rs_address(rs_address),
        .rt_address(rt_address),
        .rd_address(writeback_register_addr),
        .rd_write_data(writeback_register_data),

        .initial_floor_value(initial_floor_config),
        .initial_resistance_value(initial_resistance_config),

        .rs_data_output(rs_operand_output),
        .rt_data_output(rt_operand_output),

        .attempt_count_output(total_attempts_result),
        .broken_count_output(total_broken_result),
        .last_broken_status_output(last_attempt_broken_status),
        
        .upward_floor_count(upward_floor_output),
        .downward_floor_count(downward_floor_output)
    );

    // 控制单元实例化
    instruction_decoder control_unit( 
        .branch_condition(branch_condition_signal),
        .current_instruction(current_instruction),

        .read_enable_rs(rs_read_enable),
        .read_enable_rt(rt_read_enable),
        .write_enable_rd(rd_write_enable_output),
        .rd_select_output(rd_select_output),
        .destination_addr(rd_write_addr_output),

        .data_mem_enable(data_memory_enable),
        .data_mem_write(data_memory_write),
        .data_mem_access_type(data_memory_access_type),

        .sign_extension_flag(sign_extension_flag),
        .alu_input_a_select(alu_input_a_select),
        .alu_input_b_select(alu_input_b_select),
        .alu_operation_code(alu_operation_code),
        .program_counter_select(pc_selection_signal)
    );

    // 数据冲突检测单元
    hazard_detection_unit hazard_detector(
        .clock_input(clock_signal),
        .reset_input(reset_signal),
        .rs_address_input(rs_address),
        .rt_address_input(rt_address),
        .rs_read_enable(rs_read_enable),
        .rt_read_enable(rt_read_enable),
        .execute_write_addr(execute_write_addr),
        .memory_write_addr(memory_write_addr),
        .execute_write_enable(execute_write_enable),
        .memory_write_enable(memory_write_enable),
        .stall_signal_output(pipeline_stall_signal)
    );

endmodule