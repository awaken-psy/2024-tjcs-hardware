// 主板顶层控制模块
`timescale 1ns / 1ps

module main_board_controller(
    input           system_clock,
    input           system_reset,

    input   [15:0]  input_data,
    input           floor_init_enable,
    input           resistance_init_enable,
    
    output  [7:0]   segment_display,
    output  [7:0]   digit_select,
    
    output          final_result_broken_status
    );

    // CPU接口信号定义
    wire    [31:0]  program_counter;
    wire    [31:0]  current_instruction; 

    // 配置寄存器组
    reg     [15:0]  floor_config_value;
    reg     [15:0]  resistance_config_value;
    reg     [15:0]  labor_cost_value;
    reg     [15:0]  supply_cost_value;
    wire    [15:0]  upward_floor_count;
    wire    [15:0]  downward_floor_count;

    // 结果输出信号
    wire    [31:0]  total_attempt_times;
    wire    [31:0]  total_broken_times;
    wire            divided_clock;
    
    // 时钟分频模块实例化
    clock_divider #(4) clock_divider_instance(
        .clock_input(system_clock),
        .clock_output(divided_clock)
    );

    // 配置寄存器更新逻辑
    always @(posedge system_clock) 
    begin
        // 楼层数配置更新
        if(floor_init_enable)
            floor_config_value <= input_data;
        // 耐摔值配置更新
        else if(resistance_init_enable)
            resistance_config_value <= input_data;
            
        // 成本计算逻辑
        supply_cost_value <= 2 * upward_floor_count + downward_floor_count + 4 * total_broken_times;
        labor_cost_value <= 4 * upward_floor_count + downward_floor_count + 2 * total_broken_times;
    end

    // 中央处理器实例化
    central_processing_unit cpu_core(
        .clock_signal(divided_clock),
        .reset_signal(system_reset),

        .initial_floor_value({ 16'h0000, floor_config_value }),
        .initial_resistance_value({ 16'h0000, resistance_config_value }),

        .program_counter_output(program_counter),
        .instruction_output(current_instruction),

        .attempt_count_result(total_attempt_times),
        .broken_count_result(total_broken_times),
        .last_broken_status(final_result_broken_status),
        .up_floor_output(upward_floor_count),    // 向上移动楼层数
        .down_floor_output(downward_floor_count) // 向下移动楼层数
    );

    // 七段数码管显示模块
    seven_segment_display display_unit(
        .clock_input(system_clock),
        .reset_input(system_reset),
        .chip_select(1'b1),
        .display_data({ supply_cost_value, labor_cost_value }),
        .segment_output(segment_display),
        .digit_selection(digit_select)
    );

endmodule