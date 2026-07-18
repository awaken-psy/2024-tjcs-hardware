// 指令取指阶段处理模块
`timescale 1ns / 1ps

module instruction_fetch_stage(
    input           clock_signal,
    input           reset_signal,
    input           stall_signal,
    input   [31:0]  jump_target_address,
    input   [31:0]  branch_target_address,
    input   [1:0]   program_counter_select,
    output  [31:0]  current_pc_output,
    output  [31:0]  next_sequential_pc,
    output  [31:0]  fetched_instruction
    );

    wire [31:0] selected_next_pc;

    // 程序计数器寄存器实例化
    program_counter_register pc_register_unit(
        .clock_signal(clock_signal),
        .enable_signal(1'b1),
        .reset_signal(reset_signal),
        .stall_signal(stall_signal),
        .next_pc_value(selected_next_pc),
        .current_pc_value(current_pc_output)
    );
       
    // 下一条指令地址选择器
    program_counter_mux pc_selection_mux(
        .sequential_pc_input(next_sequential_pc),
        .branch_target_input(branch_target_address),
        .jump_target_input(jump_target_address),
        .reserved_input(32'bz),
        .selected_pc_output(selected_next_pc),
        .selection_signal(program_counter_select)
    );
    
    // 顺序下一条PC计算
    assign next_sequential_pc = current_pc_output + 32'h00000004;

    // 指令存储器实例化
    instruction_memory instruction_mem_unit(
        .address_input(current_pc_output >> 2), 
        .instruction_output(fetched_instruction)
    );
    
endmodule