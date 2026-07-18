// 取指-译码级流水线寄存器模块
`timescale 1ns / 1ps

module fetch_decode_pipeline_register(
    input               clock_input,
    input               reset_signal,
    input               stall_signal,
    input               branch_signal,
    input       [31:0]  next_pc_input,
    input       [31:0]  instruction_input,
    output reg  [31:0]  next_pc_output,
    output reg  [31:0]  instruction_output
    );

    // 流水线寄存器更新逻辑
    always @(posedge clock_input or posedge reset_signal) 
    begin
        // 复位信号处理
        if(reset_signal) 
        begin
            next_pc_output        <= 32'h00000000;
            instruction_output    <= 32'h00000000;
        end
        // 流水线非暂停状态
        else if(~stall_signal) 
        begin
            // 分支发生时清空流水线
            if(branch_signal) 
            begin
                next_pc_output        <= 32'h00000000;
                instruction_output    <= 32'h00000000;
            end
            // 正常流水线推进
            else 
            begin
                next_pc_output        <= next_pc_input;
                instruction_output    <= instruction_input;
            end
        end
        // 流水线暂停时保持当前值
        else
        begin
            next_pc_output        <= next_pc_output;
            instruction_output    <= instruction_output;
        end
    end
    
endmodule