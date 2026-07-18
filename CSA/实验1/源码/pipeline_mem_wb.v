// 存储器访问-写回级流水线寄存器模块
`timescale 1ns / 1ps

module memory_writeback_pipeline_register(
    input               clock_input,
    input               reset_signal,

    input       [4:0]   rd_write_addr_input,
    input               rd_select_input,
    input               rd_write_enable_input,

    input       [31:0]  alu_result_input,
    input       [31:0]  data_memory_result_input,

    output reg  [4:0]   rd_write_addr_output,
    output reg          rd_write_enable_output,
    output reg          rd_select_output,

    output reg  [31:0]  alu_result_output,
    output reg  [31:0]  data_memory_result_output
    );

    // 流水线寄存器更新逻辑
    always @(posedge clock_input or posedge reset_signal) 
    begin
        // 复位信号处理
        if(reset_signal == 1'b1) 
        begin
            rd_write_addr_output        <= 5'b00000;
            rd_select_output            <= 1'b0;
            rd_write_enable_output      <= 1'b0;

            alu_result_output           <= 32'h00000000;
            data_memory_result_output   <= 32'h00000000;
        end
        // 正常流水线推进
        else 
        begin
            rd_write_addr_output        <= rd_write_addr_input;
            rd_select_output            <= rd_select_input;
            rd_write_enable_output      <= rd_write_enable_input;

            alu_result_output           <= alu_result_input;
            data_memory_result_output   <= data_memory_result_input;
        end
    end 
endmodule