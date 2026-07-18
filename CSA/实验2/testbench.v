`timescale 1ns / 1ps

module simulation_testbench();
    reg             clock_signal, reset_signal, enable_signal;
    wire [7:0]      segments, digit_selectors;

    // 初始化
    initial begin
        clock_signal = 1'b0;
        reset_signal = 1'b1;
        enable_signal = 1'b1;
        #1 
        reset_signal = 1'b0;
    end

    // 时钟生成
    always begin
        #1 
        clock_signal = ~clock_signal;
    end

    // 监控信号定义
    wire [31:0] program_counter = simulation_testbench.board_top_module.cpu_module.program_counter;
    wire [31:0] instruction = simulation_testbench.board_top_module.cpu_module.current_instruction;
    
    wire [31:0] register_0 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[0];
    wire [31:0] register_1 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[1];
    wire [31:0] register_2 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[2];   
    wire [31:0] register_3 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[3];
    wire [31:0] register_4 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[4];
    wire [31:0] register_5 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[5];
    wire [31:0] register_6 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[6];
    wire [31:0] register_7 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[7];
    wire [31:0] register_8 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[8];
    wire [31:0] register_9 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[9];
    wire [31:0] register_10 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[10];
    wire [31:0] register_11 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[11];
    wire [31:0] register_12 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[12];
    wire [31:0] register_13 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[13];
    wire [31:0] register_14 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[14];
    wire [31:0] register_15 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[15];
    wire [31:0] register_16 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[16];
    wire [31:0] register_17 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[17];
    wire [31:0] register_18 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[18];
    wire [31:0] register_19 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[19];
    wire [31:0] register_20 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[20];
    wire [31:0] register_21 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[21];
    wire [31:0] register_22 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[22];
    wire [31:0] register_23 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[23];
    wire [31:0] register_24 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[24];
    wire [31:0] register_25 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[25];
    wire [31:0] register_26 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[26];
    wire [31:0] register_27 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[27];
    wire [31:0] register_28 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[28];
    wire [31:0] register_29 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[29];
    wire [31:0] register_30 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[30];
    wire [31:0] register_31 = simulation_testbench.board_top_module.cpu_module.pipeline_id_stage.register_file_module.register_bank[31];

    // 实例化顶层模块
    board_top board_top_module(
        .clk(clock_signal), 
        .rst(reset_signal), 
        .ena(enable_signal), 
        .o_seg(segments), 
        .o_sel(digit_selectors)
    );

endmodule