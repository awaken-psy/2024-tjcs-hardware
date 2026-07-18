// 系统测试平台模块
// 功能：用于验证CPU和整个系统的功能正确性
// 通过初始化参数、监控运行状态并记录结果到文件
`timescale 1ns / 1ps

module system_test_bench(
    );
    
    // 测试平台时钟和复位信号
    reg         system_clock;
    reg         system_reset;

    // 寄存器文件输出文件句柄
    integer     register_output_file;

    // 初始化配置信号
    reg [15:0]  initialization_data;
    reg         floor_initialization_enable;
    reg         resistance_initialization_enable;

    // 测试结果监控信号
    wire        last_egg_broken_status;

    // 测试序列初始化
    initial
    begin
        // 打开寄存器输出文件
        register_output_file = $fopen("register_output_results.txt");
        
        // 时钟和复位初始化
        system_clock = 0;
        system_reset = 1;
        
        // 测试序列：初始化楼层数为128
        #20 initialization_data = 16'd00128;
        #20 floor_initialization_enable = 1'b1;
        #20 floor_initialization_enable = 1'b0;
        
        // 测试序列：初始化耐摔值为20
        #20 initialization_data = 16'd0020;
        #20 resistance_initialization_enable = 1'b1;
        #20 resistance_initialization_enable = 1'b0;
        
        // 释放复位信号，开始测试
        #20 system_reset = 0;
        
    end

    // 时钟生成逻辑：周期为2个时间单位
    always 
    begin
        #1 system_clock = ~system_clock;
    end

    // 系统状态监控信号定义
    // 程序计数器和指令监控
    wire [31:0] program_counter          = system_test_bench.main_board_instance.program_counter_output;
    wire [31:0] current_instruction = system_test_bench.main_board_instance.current_instruction_output;
    
    // 成本计算结果监控
    wire [15:0] supply_cost_value = system_test_bench.main_board_instance.supply_cost_value;
    wire [15:0] labor_cost_value = system_test_bench.main_board_instance.labor_cost_value;

    // 系统配置和结果监控
    wire [31:0] configured_floors_count      = system_test_bench.main_board_instance.floor_config_value;
    wire [31:0] configured_resistance_value  = system_test_bench.main_board_instance.resistance_config_value;
    wire [31:0] total_attempts_count     = system_test_bench.main_board_instance.total_attempt_times;
    wire [31:0] total_broken_count       = system_test_bench.main_board_instance.total_broken_times;
    wire        last_attempt_broken  = system_test_bench.main_board_instance.final_result_broken_status;
    
    // 寄存器文件监控信号 - 监控前20个寄存器的值
    wire [31:0] register0_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[0];
    wire [31:0] register1_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[1];
    wire [31:0] register2_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[2];   
    wire [31:0] register3_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[3];
    wire [31:0] register4_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[4];
    wire [31:0] register5_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[5];
    wire [31:0] register6_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[6];
    wire [31:0] register7_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[7];
    wire [31:0] register8_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[8];
    wire [31:0] register9_value  = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[9];
    wire [31:0] register10_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[10];
    wire [31:0] register11_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[11];
    wire [31:0] register12_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[12];
    wire [31:0] register13_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[13];
    wire [31:0] register14_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[14];
    wire [31:0] register15_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[15];
    wire [31:0] register16_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[16];
    wire [31:0] register17_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[17];
    wire [31:0] register18_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[18];
    wire [31:0] register19_value = system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[19];
   
    // 寄存器状态记录逻辑 - 每个时钟周期记录所有寄存器状态
    always @(posedge system_clock) 
    begin
        if (!system_reset)
        begin
            // 记录程序计数器和当前指令
            $fdisplay(register_output_file, "Program Counter: %h",     
                     system_test_bench.main_board_instance.program_counter_output);
            $fdisplay(register_output_file, "Current Instruction: %h",  
                     system_test_bench.main_board_instance.current_instruction_output);
            
            // 记录所有32个寄存器的值
            $fdisplay(register_output_file, "Register0:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[0]);
            $fdisplay(register_output_file, "Register1:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[1]);
            $fdisplay(register_output_file, "Register2:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[2]);
            $fdisplay(register_output_file, "Register3:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[3]);
            $fdisplay(register_output_file, "Register4:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[4]);
            $fdisplay(register_output_file, "Register5:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[5]);
            $fdisplay(register_output_file, "Register6:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[6]);
            $fdisplay(register_output_file, "Register7:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[7]);
            $fdisplay(register_output_file, "Register8:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[8]);
            $fdisplay(register_output_file, "Register9:  %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[9]);
            $fdisplay(register_output_file, "Register10: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[10]);
            $fdisplay(register_output_file, "Register11: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[11]);
            $fdisplay(register_output_file, "Register12: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[12]);
            $fdisplay(register_output_file, "Register13: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[13]);
            $fdisplay(register_output_file, "Register14: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[14]);
            $fdisplay(register_output_file, "Register15: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[15]);
            $fdisplay(register_output_file, "Register16: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[16]);
            $fdisplay(register_output_file, "Register17: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[17]);
            $fdisplay(register_output_file, "Register18: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[18]);
            $fdisplay(register_output_file, "Register19: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[19]);
            $fdisplay(register_output_file, "Register20: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[20]);
            $fdisplay(register_output_file, "Register21: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[21]);
            $fdisplay(register_output_file, "Register22: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[22]);
            $fdisplay(register_output_file, "Register23: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[23]);
            $fdisplay(register_output_file, "Register24: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[24]);
            $fdisplay(register_output_file, "Register25: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[25]);
            $fdisplay(register_output_file, "Register26: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[26]);
            $fdisplay(register_output_file, "Register27: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[27]);
            $fdisplay(register_output_file, "Register28: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[28]);
            $fdisplay(register_output_file, "Register29: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[29]);
            $fdisplay(register_output_file, "Register30: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[30]);
            $fdisplay(register_output_file, "Register31: %h", 
                     system_test_bench.main_board_instance.processor_core_instance.decode_stage_unit.register_file_unit.register_array[31]);
            
            // 添加分隔线便于阅读
            $fdisplay(register_output_file, "----------------------------------------");
        end
    end

    // 主板顶层模块实例化
    main_board_controller main_board_instance(
        .system_clock(system_clock),
        .system_reset(system_reset),
        .input_data(initialization_data),
        .floor_init_enable(floor_initialization_enable),
        .resistance_init_enable(resistance_initialization_enable),
        .final_result_broken_status(last_egg_broken_status)
    );

endmodule