`timescale 1ns / 1ps

module cpu(
    input           system_clock,
    input           system_reset,
    input           enable_signal,
    output [31:0]   program_counter,
    output [31:0]   current_instruction,
    output [31:0]   register_6_value,
    output [31:0]   register_7_value,
    output [31:0]   register_15_value,
    output [31:0]   register_16_value
);

    // Register enable signals
    wire program_counter_enable;
    wire id_ex_stage_reg_enable;
    wire ex_mem_stage_reg_enable;
    wire mem_wb_stage_reg_enable;

    // Control signals
    wire pipeline_stall;
    wire branch_taken;

    // Instruction Fetch stage
    wire [31:0] next_program_counter; 
    wire [31:0] program_counter_plus_4;

    // Instruction Decode stage
    wire [31:0] id_stage_pc_plus_4;
    wire [31:0] id_stage_instruction;

    wire [2:0]  id_stage_pc_select;
    wire [5:0]  id_stage_opcode;
    wire [5:0]  id_stage_function;
    wire [31:0] id_stage_immediate;
    wire [31:0] id_stage_shift_amount;
    wire [31:0] id_stage_pc_plus_4_out;
    wire [31:0] id_stage_exception_address;
    wire [31:0] id_stage_branch_address;
    wire [31:0] id_stage_jump_address;
    wire [31:0] id_stage_register_address;
    wire [31:0] id_stage_rs_data;  
    wire [31:0] id_stage_rt_data;
    wire [31:0] id_stage_hi_data;
    wire [31:0] id_stage_lo_data;
    wire [31:0] id_stage_cp0_data;
    wire        id_stage_alu_a_select;
    wire [1:0]  id_stage_alu_b_select;
    wire [3:0]  id_stage_alu_control;
    wire        id_stage_multiplier_enable;
    wire        id_stage_divider_enable;
    wire        id_stage_clz_enable;
    wire        id_stage_multiplier_signed;
    wire        id_stage_divider_signed;
    wire        id_stage_cutter_sign_extend;
    wire        id_stage_cutter_address_select;
    wire [2:0]  id_stage_cutter_select;
    wire        id_stage_data_memory_enable;
    wire        id_stage_data_memory_write_enable;
    wire [1:0]  id_stage_data_memory_write_select;
    wire [1:0]  id_stage_data_memory_read_select;
    wire        id_stage_hi_write_enable;
    wire        id_stage_lo_write_enable;
    wire        id_stage_rd_write_enable;
    wire [1:0]  id_stage_hi_source_select;
    wire [1:0]  id_stage_lo_source_select;
    wire [2:0]  id_stage_rd_source_select;
    wire [4:0]  id_stage_rd_write_address;

    // Execution stage
    wire [5:0]  ex_stage_opcode;
    wire [5:0]  ex_stage_function;
    wire [31:0] ex_stage_pc_plus_4;
    wire [31:0] ex_stage_immediate;
    wire [31:0] ex_stage_shift_amount;
    wire [31:0] ex_stage_rs_data;
    wire [31:0] ex_stage_rt_data;
    wire [31:0] ex_stage_hi_data;
    wire [31:0] ex_stage_lo_data;
    wire [31:0] ex_stage_cp0_data;
    wire        ex_stage_alu_a_select;
    wire [1:0]  ex_stage_alu_b_select;
    wire [3:0]  ex_stage_alu_control;
    wire        ex_stage_multiplier_enable;
    wire        ex_stage_divider_enable;
    wire        ex_stage_clz_enable;
    wire        ex_stage_multiplier_signed;
    wire        ex_stage_divider_signed;
    wire        ex_stage_cutter_sign_extend;
    wire        ex_stage_cutter_address_select;
    wire [2:0]  ex_stage_cutter_select;
    wire        ex_stage_data_memory_enable;
    wire        ex_stage_data_memory_write_enable;
    wire [1:0]  ex_stage_data_memory_write_select;
    wire [1:0]  ex_stage_data_memory_read_select;
    wire        ex_stage_hi_write_enable;
    wire        ex_stage_lo_write_enable;
    wire        ex_stage_rd_write_enable;
    wire [1:0]  ex_stage_hi_source_select;
    wire [1:0]  ex_stage_lo_source_select;
    wire [2:0]  ex_stage_rd_source_select;
    wire [4:0]  ex_stage_rd_write_address;

    wire [31:0] ex_stage_pc_plus_4_out;
    wire [31:0] ex_stage_rs_data_out;
    wire [31:0] ex_stage_rt_data_out;
    wire [31:0] ex_stage_hi_data_out;
    wire [31:0] ex_stage_lo_data_out;
    wire [31:0] ex_stage_cp0_data_out;
    wire [31:0] ex_stage_alu_result;
    wire [31:0] ex_stage_multiplier_hi;
    wire [31:0] ex_stage_multiplier_lo;
    wire [31:0] ex_stage_divider_remainder;
    wire [31:0] ex_stage_divider_quotient;
    wire [31:0] ex_stage_clz_result;
    wire        ex_stage_cutter_sign_extend_out;
    wire        ex_stage_cutter_address_select_out;
    wire [2:0]  ex_stage_cutter_select_out;
    wire        ex_stage_data_memory_enable_out;
    wire        ex_stage_data_memory_write_enable_out;
    wire [1:0]  ex_stage_data_memory_write_select_out;
    wire [1:0]  ex_stage_data_memory_read_select_out;
    wire        ex_stage_hi_write_enable_out;
    wire        ex_stage_lo_write_enable_out;
    wire        ex_stage_rd_write_enable_out;
    wire [1:0]  ex_stage_hi_source_select_out;
    wire [1:0]  ex_stage_lo_source_select_out;
    wire [2:0]  ex_stage_rd_source_select_out;
    wire [4:0]  ex_stage_rd_write_address_out;

    // Memory stage
    wire [31:0] mem_stage_pc_plus_4;
    wire [31:0] mem_stage_rs_data;
    wire [31:0] mem_stage_rt_data;
    wire [31:0] mem_stage_hi_data;
    wire [31:0] mem_stage_lo_data;
    wire [31:0] mem_stage_cp0_data;
    wire [31:0] mem_stage_alu_result;
    wire [31:0] mem_stage_multiplier_hi;
    wire [31:0] mem_stage_multiplier_lo;  
    wire [31:0] mem_stage_divider_remainder;
    wire [31:0] mem_stage_divider_quotient;
    wire [31:0] mem_stage_clz_result;
    wire        mem_stage_cutter_sign_extend;
    wire        mem_stage_cutter_address_select;
    wire [2:0]  mem_stage_cutter_select;
    wire        mem_stage_data_memory_enable;
    wire        mem_stage_data_memory_write_enable;
    wire [1:0]  mem_stage_data_memory_write_select;
    wire [1:0]  mem_stage_data_memory_read_select;
    wire        mem_stage_hi_write_enable;
    wire        mem_stage_lo_write_enable;
    wire        mem_stage_rd_write_enable;
    wire [1:0]  mem_stage_hi_source_select;
    wire [1:0]  mem_stage_lo_source_select;
    wire [2:0]  mem_stage_rd_source_select;
    wire [4:0]  mem_stage_rd_write_address;

    wire [31:0] mem_stage_pc_plus_4_out;
    wire [31:0] mem_stage_rs_data_out;
    wire [31:0] mem_stage_hi_data_out;
    wire [31:0] mem_stage_lo_data_out;
    wire [31:0] mem_stage_cp0_data_out;
    wire [31:0] mem_stage_alu_result_out;
    wire [31:0] mem_stage_multiplier_hi_out;
    wire [31:0] mem_stage_multiplier_lo_out;
    wire [31:0] mem_stage_divider_remainder_out;
    wire [31:0] mem_stage_divider_quotient_out;
    wire [31:0] mem_stage_clz_result_out;
    wire [31:0] mem_stage_data_memory_data;
    wire        mem_stage_hi_write_enable_out;
    wire        mem_stage_lo_write_enable_out;
    wire        mem_stage_rd_write_enable_out;       
    wire [1:0]  mem_stage_hi_source_select_out;
    wire [1:0]  mem_stage_lo_source_select_out;
    wire [2:0]  mem_stage_rd_source_select_out;
    wire [4:0]  mem_stage_rd_write_address_out;

    // Write Back stage
    wire [31:0] wb_stage_pc_plus_4;
    wire [31:0] wb_stage_rs_data;
    wire [31:0] wb_stage_hi_data;
    wire [31:0] wb_stage_lo_data;
    wire [31:0] wb_stage_cp0_data;
    wire [31:0] wb_stage_alu_result;
    wire [31:0] wb_stage_multiplier_hi;
    wire [31:0] wb_stage_multiplier_lo;
    wire [31:0] wb_stage_divider_remainder;
    wire [31:0] wb_stage_divider_quotient;
    wire [31:0] wb_stage_clz_result;
    wire [31:0] wb_stage_data_memory_data;
    wire        wb_stage_hi_write_enable;
    wire        wb_stage_lo_write_enable;
    wire        wb_stage_rd_write_enable;
    wire [1:0]  wb_stage_hi_source_select;
    wire [1:0]  wb_stage_lo_source_select;
    wire [2:0]  wb_stage_rd_source_select;
    wire [4:0]  wb_stage_rd_write_address;

    wire        wb_stage_hi_write_enable_out;
    wire        wb_stage_lo_write_enable_out;
    wire        wb_stage_rd_write_enable_out;
    wire [31:0] wb_stage_hi_data_out;
    wire [31:0] wb_stage_lo_data_out;
    wire [31:0] wb_stage_rd_data_out;
    wire [4:0]  wb_stage_rd_write_address_out;

    assign program_counter_enable    = enable_signal;
    assign id_ex_stage_reg_enable    = enable_signal;
    assign ex_mem_stage_reg_enable   = enable_signal;
    assign mem_wb_stage_reg_enable   = enable_signal;
    
    program_counter pc_instance(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .enable_input(program_counter_enable),
        .stall_input(pipeline_stall),
        .pc_input(next_program_counter),
        .pc_output(program_counter)
    );

    instruction_fetch_pipeline fetch_stage(
        .current_pc(program_counter),
        .pc_select_signal(id_stage_pc_select),
        .exception_address(id_stage_exception_address),
        .branch_address(id_stage_branch_address),
        .register_address(id_stage_register_address),
        .jump_address(id_stage_jump_address),
        .next_pc(next_program_counter),
        .pc_plus_4(program_counter_plus_4),
        .instruction_fetched(current_instruction)
    );

    if_id_pipeline_registers if_id_pipeline(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .stall_input(pipeline_stall),
        .branch_input(branch_taken),
        .pc_plus_4_input(program_counter_plus_4),
        .instruction_input(current_instruction),
        .pc_plus_4_output(id_stage_pc_plus_4),
        .instruction_output(id_stage_instruction)
    );

    instruction_decode_pipeline decode_stage(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .pc_plus_4_input(id_stage_pc_plus_4),
        .instruction_input(id_stage_instruction),
        .hi_write_enable_input(wb_stage_hi_write_enable_out),
        .lo_write_enable_input(wb_stage_lo_write_enable_out),
        .rd_write_enable_input(wb_stage_rd_write_enable_out),
        .rd_write_address_input(wb_stage_rd_write_address_out),
        .hi_data_input(wb_stage_hi_data_out),
        .lo_data_input(wb_stage_lo_data_out),
        .rd_data_input(wb_stage_rd_data_out),
        .ex_opcode_input(ex_stage_opcode),
        .ex_function_input(ex_stage_function),
        .ex_pc_plus_4_input(ex_stage_pc_plus_4_out),
        .ex_alu_result_input(ex_stage_alu_result),
        .ex_multiplier_hi_input(ex_stage_multiplier_hi),
        .ex_multiplier_lo_input(ex_stage_multiplier_lo),
        .ex_divider_remainder_input(ex_stage_divider_remainder),
        .ex_divider_quotient_input(ex_stage_divider_quotient),
        .ex_clz_result_input(ex_stage_clz_result),
        .ex_hi_data_input(ex_stage_hi_data_out),
        .ex_lo_data_input(ex_stage_lo_data_out),
        .ex_rs_data_input(ex_stage_rs_data_out),
        .ex_hi_write_enable_input(ex_stage_hi_write_enable_out),
        .ex_lo_write_enable_input(ex_stage_lo_write_enable_out),
        .ex_rd_write_enable_input(ex_stage_rd_write_enable_out),
        .ex_hi_source_select_input(ex_stage_hi_source_select_out),
        .ex_lo_source_select_input(ex_stage_lo_source_select_out),
        .ex_rd_source_select_input(ex_stage_rd_source_select_out),
        .ex_rd_write_address_input(ex_stage_rd_write_address_out),
        .mem_pc_plus_4_input(mem_stage_pc_plus_4_out),
        .mem_alu_result_input(mem_stage_alu_result_out),
        .mem_multiplier_hi_input(mem_stage_multiplier_hi_out),
        .mem_multiplier_lo_input(mem_stage_multiplier_lo_out),
        .mem_divider_quotient_input(mem_stage_divider_remainder_out),
        .mem_divider_remainder_input(mem_stage_divider_quotient_out),
        .mem_clz_result_input(mem_stage_clz_result_out),
        .mem_lo_data_input(mem_stage_lo_data_out),
        .mem_hi_data_input(mem_stage_hi_data_out),
        .mem_rs_data_input(mem_stage_rs_data_out),
        .mem_data_memory_data_input(mem_stage_data_memory_data),
        .mem_hi_write_enable_input(mem_stage_hi_write_enable_out),
        .mem_lo_write_enable_input(mem_stage_lo_write_enable_out),
        .mem_rd_write_enable_input(mem_stage_rd_write_enable_out),
        .mem_hi_source_select_input(mem_stage_hi_source_select_out),
        .mem_lo_source_select_input(mem_stage_lo_source_select_out),
        .mem_rd_source_select_input(mem_stage_rd_source_select_out),
        .mem_rd_write_address_input(mem_stage_rd_write_address_out),
        .stall_output(pipeline_stall),
        .branch_output(branch_taken),
        .opcode_output(id_stage_opcode),
        .function_output(id_stage_function),
        .pc_select_output(id_stage_pc_select),
        .pc_plus_4_output(id_stage_pc_plus_4_out),
        .immediate_output(id_stage_immediate),
        .shift_amount_output(id_stage_shift_amount),
        .exception_address_output(id_stage_exception_address),
        .branch_address_output(id_stage_branch_address),
        .jump_address_output(id_stage_jump_address),
        .register_address_output(id_stage_register_address),
        .rs_data_output(id_stage_rs_data),
        .rt_data_output(id_stage_rt_data),
        .hi_data_output(id_stage_hi_data),
        .lo_data_output(id_stage_lo_data),
        .cp0_data_output(id_stage_cp0_data),
        .alu_a_select_output(id_stage_alu_a_select),
        .alu_b_select_output(id_stage_alu_b_select),
        .alu_control_output(id_stage_alu_control),
        .multiplier_enable_output(id_stage_multiplier_enable),
        .divider_enable_output(id_stage_divider_enable),
        .clz_enable_output(id_stage_clz_enable),
        .multiplier_signed_output(id_stage_multiplier_signed),
        .divider_signed_output(id_stage_divider_signed),
        .hi_write_enable_output(id_stage_hi_write_enable),
        .lo_write_enable_output(id_stage_lo_write_enable),
        .rd_write_enable_output(id_stage_rd_write_enable),
        .cutter_sign_extend_output(id_stage_cutter_sign_extend),
        .cutter_address_select_output(id_stage_cutter_address_select),
        .cutter_select_output(id_stage_cutter_select),
        .data_memory_enable_output(id_stage_data_memory_enable),
        .data_memory_write_enable_output(id_stage_data_memory_write_enable),
        .data_memory_write_select_output(id_stage_data_memory_write_select),
        .data_memory_read_select_output(id_stage_data_memory_read_select),
        .hi_source_select_output(id_stage_hi_source_select),
        .lo_source_select_output(id_stage_lo_source_select),
        .rd_source_select_output(id_stage_rd_source_select),
        .rd_write_address_output(id_stage_rd_write_address),
        .register_6_output(register_6_value),
        .register_7_output(register_7_value),
        .register_15_output(register_15_value),
        .register_16_output(register_16_value)
    );

    id_ex_pipeline_registers id_ex_pipeline(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .write_enable_input(id_ex_stage_reg_enable),
        .stall_input(pipeline_stall),
        .opcode_input(id_stage_opcode),
        .function_input(id_stage_function),
        .pc_plus_4_input(id_stage_pc_plus_4_out),
        .immediate_input(id_stage_immediate),
        .shift_amount_input(id_stage_shift_amount),
        .rs_data_input(id_stage_rs_data),
        .rt_data_input(id_stage_rt_data),
        .hi_data_input(id_stage_hi_data),
        .lo_data_input(id_stage_lo_data),
        .cp0_data_input(id_stage_cp0_data),
        .alu_a_select_input(id_stage_alu_a_select),
        .alu_b_select_input(id_stage_alu_b_select),
        .alu_control_input(id_stage_alu_control),
        .multiplier_enable_input(id_stage_multiplier_enable),
        .clz_enable_input(id_stage_clz_enable),
        .divider_enable_input(id_stage_divider_enable),
        .multiplier_signed_input(id_stage_multiplier_signed),
        .divider_signed_input(id_stage_divider_signed),
        .cutter_sign_extend_input(id_stage_cutter_sign_extend),
        .cutter_address_select_input(id_stage_cutter_address_select),
        .cutter_select_input(id_stage_cutter_select),
        .data_memory_enable_input(id_stage_data_memory_enable),
        .data_memory_write_enable_input(id_stage_data_memory_write_enable),
        .data_memory_write_select_input(id_stage_data_memory_write_select),
        .data_memory_read_select_input(id_stage_data_memory_read_select),
        .hi_write_enable_input(id_stage_hi_write_enable),
        .lo_write_enable_input(id_stage_lo_write_enable),
        .rd_write_enable_input(id_stage_rd_write_enable),
        .hi_source_select_input(id_stage_hi_source_select),
        .lo_source_select_input(id_stage_lo_source_select),
        .rd_source_select_input(id_stage_rd_source_select),
        .rd_write_address_input(id_stage_rd_write_address),
        .opcode_output(ex_stage_opcode),
        .function_output(ex_stage_function),
        .pc_plus_4_output(ex_stage_pc_plus_4),
        .immediate_output(ex_stage_immediate),
        .shift_amount_output(ex_stage_shift_amount),
        .rs_data_output(ex_stage_rs_data),
        .rt_data_output(ex_stage_rt_data),
        .hi_data_output(ex_stage_hi_data),
        .lo_data_output(ex_stage_lo_data),
        .cp0_data_output(ex_stage_cp0_data),
        .alu_a_select_output(ex_stage_alu_a_select),
        .alu_b_select_output(ex_stage_alu_b_select),
        .alu_control_output(ex_stage_alu_control),
        .clz_enable_output(ex_stage_clz_enable),
        .multiplier_enable_output(ex_stage_multiplier_enable),
        .divider_enable_output(ex_stage_divider_enable),
        .multiplier_signed_output(ex_stage_multiplier_signed),
        .divider_signed_output(ex_stage_divider_signed),
        .cutter_sign_extend_output(ex_stage_cutter_sign_extend),
        .cutter_address_select_output(ex_stage_cutter_address_select),
        .cutter_select_output(ex_stage_cutter_select),
        .data_memory_enable_output(ex_stage_data_memory_enable),
        .data_memory_write_enable_output(ex_stage_data_memory_write_enable),
        .data_memory_write_select_output(ex_stage_data_memory_write_select),
        .data_memory_read_select_output(ex_stage_data_memory_read_select),
        .rd_write_enable_output(ex_stage_rd_write_enable),
        .hi_write_enable_output(ex_stage_hi_write_enable),
        .lo_write_enable_output(ex_stage_lo_write_enable),
        .hi_source_select_output(ex_stage_hi_source_select),
        .lo_source_select_output(ex_stage_lo_source_select),
        .rd_source_select_output(ex_stage_rd_source_select),
        .rd_write_address_output(ex_stage_rd_write_address)
    );

    execution_pipeline ex_stage(
        .reset_input(system_reset),
        .pc_plus_4_input(ex_stage_pc_plus_4),
        .immediate_input(ex_stage_immediate),
        .shift_amount_input(ex_stage_shift_amount),
        .rs_data_input(ex_stage_rs_data),
        .rt_data_input(ex_stage_rt_data),
        .hi_data_input(ex_stage_hi_data),
        .lo_data_input(ex_stage_lo_data),
        .cp0_data_input(ex_stage_cp0_data),
        .alu_a_select_input(ex_stage_alu_a_select),
        .alu_b_select_input(ex_stage_alu_b_select),
        .alu_control_input(ex_stage_alu_control),
        .multiplier_enable_input(ex_stage_multiplier_enable),
        .divider_enable_input(ex_stage_divider_enable),
        .clz_enable_input(ex_stage_clz_enable),
        .multiplier_signed_input(ex_stage_multiplier_signed),
        .divider_signed_input(ex_stage_divider_signed),
        .cutter_sign_extend_input(ex_stage_cutter_sign_extend),
        .cutter_address_select_input(ex_stage_cutter_address_select),
        .cutter_select_input(ex_stage_cutter_select),
        .data_memory_enable_input(ex_stage_data_memory_enable),
        .data_memory_write_enable_input(ex_stage_data_memory_write_enable),
        .data_memory_write_select_input(ex_stage_data_memory_write_select),
        .data_memory_read_select_input(ex_stage_data_memory_read_select),
        .rd_write_enable_input(ex_stage_rd_write_enable),
        .hi_write_enable_input(ex_stage_hi_write_enable),
        .lo_write_enable_input(ex_stage_lo_write_enable),
        .hi_source_select_input(ex_stage_hi_source_select),
        .lo_source_select_input(ex_stage_lo_source_select),
        .rd_source_select_input(ex_stage_rd_source_select),
        .rd_write_address_input(ex_stage_rd_write_address),
        .pc_plus_4_output(ex_stage_pc_plus_4_out),
        .multiplier_hi_output(ex_stage_multiplier_hi),
        .multiplier_lo_output(ex_stage_multiplier_lo),
        .divider_remainder_output(ex_stage_divider_remainder),
        .divider_quotient_output(ex_stage_divider_quotient),
        .rs_data_output(ex_stage_rs_data_out),
        .rt_data_output(ex_stage_rt_data_out),
        .hi_data_output(ex_stage_hi_data_out),
        .lo_data_output(ex_stage_lo_data_out),
        .cp0_data_output(ex_stage_cp0_data_out),
        .clz_result_output(ex_stage_clz_result),
        .alu_result_output(ex_stage_alu_result),
        .cutter_sign_extend_output(ex_stage_cutter_sign_extend_out),
        .cutter_address_select_output(ex_stage_cutter_address_select_out),
        .cutter_select_output(ex_stage_cutter_select_out),
        .data_memory_enable_output(ex_stage_data_memory_enable_out),
        .data_memory_write_enable_output(ex_stage_data_memory_write_enable_out),
        .data_memory_write_select_output(ex_stage_data_memory_write_select_out),
        .data_memory_read_select_output(ex_stage_data_memory_read_select_out),
        .hi_write_enable_output(ex_stage_hi_write_enable_out),
        .lo_write_enable_output(ex_stage_lo_write_enable_out),
        .rd_write_enable_output(ex_stage_rd_write_enable_out),
        .hi_source_select_output(ex_stage_hi_source_select_out),
        .lo_source_select_output(ex_stage_lo_source_select_out),
        .rd_source_select_output(ex_stage_rd_source_select_out),
        .rd_write_address_output(ex_stage_rd_write_address_out)
    );

    ex_mem_pipeline_registers ex_mem_pipeline(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .write_enable_input(ex_mem_stage_reg_enable),
        .pc_plus_4_input(ex_stage_pc_plus_4_out),
        .rs_data_input(ex_stage_rs_data_out),
        .rt_data_input(ex_stage_rt_data_out),
        .hi_data_input(ex_stage_hi_data_out),
        .lo_data_input(ex_stage_lo_data_out),
        .cp0_data_input(ex_stage_cp0_data_out),
        .alu_result_input(ex_stage_alu_result),
        .multiplier_hi_input(ex_stage_multiplier_hi),
        .multiplier_lo_input(ex_stage_multiplier_lo),
        .divider_remainder_input(ex_stage_divider_remainder),
        .divider_quotient_input(ex_stage_divider_quotient),
        .clz_result_input(ex_stage_clz_result),
        .cutter_sign_extend_input(ex_stage_cutter_sign_extend_out),
        .cutter_select_input(ex_stage_cutter_select_out),
        .cutter_address_select_input(ex_stage_cutter_address_select_out),
        .data_memory_enable_input(ex_stage_data_memory_enable_out),
        .data_memory_write_enable_input(ex_stage_data_memory_write_enable_out),
        .data_memory_write_select_input(ex_stage_data_memory_write_select_out),
        .data_memory_read_select_input(ex_stage_data_memory_read_select_out),
        .hi_write_enable_input(ex_stage_hi_write_enable_out),
        .lo_write_enable_input(ex_stage_lo_write_enable_out),
        .rd_write_enable_input(ex_stage_rd_write_enable_out),
        .hi_source_select_input(ex_stage_hi_source_select_out),
        .lo_source_select_input(ex_stage_lo_source_select_out),
        .rd_source_select_input(ex_stage_rd_source_select_out),
        .rd_write_address_input(ex_stage_rd_write_address_out),
        .pc_plus_4_output(mem_stage_pc_plus_4),
        .rs_data_output(mem_stage_rs_data),
        .rt_data_output(mem_stage_rt_data),
        .hi_data_output(mem_stage_hi_data),
        .lo_data_output(mem_stage_lo_data),
        .cp0_data_output(mem_stage_cp0_data),
        .alu_result_output(mem_stage_alu_result),
        .multiplier_hi_output(mem_stage_multiplier_hi),
        .multiplier_lo_output(mem_stage_multiplier_lo),
        .divider_remainder_output(mem_stage_divider_remainder),
        .divider_quotient_output(mem_stage_divider_quotient),
        .clz_result_output(mem_stage_clz_result),
        .cutter_sign_extend_output(mem_stage_cutter_sign_extend),
        .cutter_address_select_output(mem_stage_cutter_address_select),
        .cutter_select_output(mem_stage_cutter_select),
        .data_memory_enable_output(mem_stage_data_memory_enable),
        .data_memory_write_enable_output(mem_stage_data_memory_write_enable),
        .data_memory_write_select_output(mem_stage_data_memory_write_select),
        .data_memory_read_select_output(mem_stage_data_memory_read_select),
        .rd_write_enable_output(mem_stage_rd_write_enable),
        .hi_write_enable_output(mem_stage_hi_write_enable),
        .lo_write_enable_output(mem_stage_lo_write_enable),
        .hi_source_select_output(mem_stage_hi_source_select),
        .lo_source_select_output(mem_stage_lo_source_select),
        .rd_source_select_output(mem_stage_rd_source_select),
        .rd_write_address_output(mem_stage_rd_write_address)
    );

    memory_pipeline mem_stage(
        .clock_input(system_clock),
        .pc_plus_4_input(mem_stage_pc_plus_4),
        .rs_data_input(mem_stage_rs_data),
        .rt_data_input(mem_stage_rt_data),
        .hi_data_input(mem_stage_hi_data),
        .lo_data_input(mem_stage_lo_data),
        .cp0_data_input(mem_stage_cp0_data),
        .alu_result_input(mem_stage_alu_result),
        .multiplier_hi_input(mem_stage_multiplier_hi),
        .multiplier_lo_input(mem_stage_multiplier_lo),
        .divider_remainder_input(mem_stage_divider_remainder),
        .divider_quotient_input(mem_stage_divider_quotient),
        .clz_result_input(mem_stage_clz_result),
        .cutter_sign_extend_input(mem_stage_cutter_sign_extend),
        .cutter_address_select_input(mem_stage_cutter_address_select),
        .cutter_select_input(mem_stage_cutter_select),
        .data_memory_write_select_input(mem_stage_data_memory_write_select),
        .data_memory_read_select_input(mem_stage_data_memory_read_select),
        .data_memory_enable_input(mem_stage_data_memory_enable),
        .data_memory_write_enable_input(mem_stage_data_memory_write_enable),
        .hi_write_enable_input(mem_stage_hi_write_enable),
        .lo_write_enable_input(mem_stage_lo_write_enable),
        .rd_write_enable_input(mem_stage_rd_write_enable),
        .hi_source_select_input(mem_stage_hi_source_select),
        .lo_source_select_input(mem_stage_lo_source_select),
        .rd_source_select_input(mem_stage_rd_source_select),
        .rd_write_address_input(mem_stage_rd_write_address),
        .pc_plus_4_output(mem_stage_pc_plus_4_out),
        .rs_data_output(mem_stage_rs_data_out),
        .hi_data_output(mem_stage_hi_data_out),
        .lo_data_output(mem_stage_lo_data_out),
        .cp0_data_output(mem_stage_cp0_data_out),
        .alu_result_output(mem_stage_alu_result_out),
        .multiplier_hi_output(mem_stage_multiplier_hi_out),
        .multiplier_lo_output(mem_stage_multiplier_lo_out),
        .divider_remainder_output(mem_stage_divider_remainder_out),
        .divider_quotient_output(mem_stage_divider_quotient_out),
        .clz_result_output(mem_stage_clz_result_out),
        .data_memory_data_output(mem_stage_data_memory_data),
        .hi_write_enable_output(mem_stage_hi_write_enable_out),
        .lo_write_enable_output(mem_stage_lo_write_enable_out),
        .rd_write_enable_output(mem_stage_rd_write_enable_out),
        .hi_source_select_output(mem_stage_hi_source_select_out),
        .lo_source_select_output(mem_stage_lo_source_select_out),
        .rd_source_select_output(mem_stage_rd_source_select_out),
        .rd_write_address_output(mem_stage_rd_write_address_out)
    );

    mem_wb_pipeline_registers mem_wb_pipeline(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .write_enable_input(mem_wb_stage_reg_enable),
        .pc_plus_4_input(mem_stage_pc_plus_4_out),
        .rs_data_input(mem_stage_rs_data_out),
        .hi_data_input(mem_stage_hi_data_out),
        .lo_data_input(mem_stage_lo_data_out),
        .cp0_data_input(mem_stage_cp0_data_out),
        .alu_result_input(mem_stage_alu_result_out),
        .multiplier_hi_input(mem_stage_multiplier_hi_out),
        .multiplier_lo_input(mem_stage_multiplier_lo_out),
        .divider_remainder_input(mem_stage_divider_remainder_out),
        .divider_quotient_input(mem_stage_divider_quotient_out),
        .clz_result_input(mem_stage_clz_result_out),
        .data_memory_data_input(mem_stage_data_memory_data),
        .hi_write_enable_input(mem_stage_hi_write_enable_out),
        .lo_write_enable_input(mem_stage_lo_write_enable_out),
        .rd_write_enable_input(mem_stage_rd_write_enable_out),
        .hi_source_select_input(mem_stage_hi_source_select_out),
        .lo_source_select_input(mem_stage_lo_source_select_out),
        .rd_source_select_input(mem_stage_rd_source_select_out),
        .rd_write_address_input(mem_stage_rd_write_address_out),
        .pc_plus_4_output(wb_stage_pc_plus_4),
        .rs_data_output(wb_stage_rs_data),
        .hi_data_output(wb_stage_hi_data),
        .lo_data_output(wb_stage_lo_data),
        .cp0_data_output(wb_stage_cp0_data),
        .alu_result_output(wb_stage_alu_result),
        .multiplier_hi_output(wb_stage_multiplier_hi),
        .multiplier_lo_output(wb_stage_multiplier_lo),
        .divider_remainder_output(wb_stage_divider_remainder),
        .divider_quotient_output(wb_stage_divider_quotient),
        .clz_result_output(wb_stage_clz_result),
        .data_memory_data_output(wb_stage_data_memory_data),
        .hi_write_enable_output(wb_stage_hi_write_enable),
        .lo_write_enable_output(wb_stage_lo_write_enable),
        .rd_write_enable_output(wb_stage_rd_write_enable),
        .hi_source_select_output(wb_stage_hi_source_select),
        .lo_source_select_output(wb_stage_lo_source_select),
        .rd_source_select_output(wb_stage_rd_source_select),
        .rd_write_address_output(wb_stage_rd_write_address)
    );

    write_back_pipeline wb_stage(
        .pc_plus_4_input(wb_stage_pc_plus_4),
        .rs_data_input(wb_stage_rs_data),
        .hi_data_input(wb_stage_hi_data),
        .lo_data_input(wb_stage_lo_data),
        .cp0_data_input(wb_stage_cp0_data),
        .alu_result_input(wb_stage_alu_result),
        .multiplier_hi_input(wb_stage_multiplier_hi),
        .multiplier_lo_input(wb_stage_multiplier_lo),
        .divider_remainder_input(wb_stage_divider_quotient),
        .divider_quotient_input(wb_stage_divider_quotient),
        .clz_result_input(wb_stage_clz_result),
        .data_memory_data_input(wb_stage_data_memory_data),
        .hi_write_enable_input(wb_stage_hi_write_enable),
        .lo_write_enable_input(wb_stage_lo_write_enable),
        .rd_write_enable_input(wb_stage_rd_write_enable),
        .hi_source_select_input(wb_stage_hi_source_select),
        .lo_source_select_input(wb_stage_lo_source_select),
        .rd_source_select_input(wb_stage_rd_source_select),
        .rd_write_address_input(wb_stage_rd_write_address),
        .hi_write_enable_output(wb_stage_hi_write_enable_out),
        .lo_write_enable_output(wb_stage_lo_write_enable_out),
        .rd_write_enable_output(wb_stage_rd_write_enable_out),
        .rd_write_address_output(wb_stage_rd_write_address_out),
        .hi_data_output(wb_stage_hi_data_out),
        .lo_data_output(wb_stage_lo_data_out),
        .rd_data_output(wb_stage_rd_data_out)
    );

endmodule