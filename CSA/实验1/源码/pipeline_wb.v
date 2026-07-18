// 写回阶段处理模块
`timescale 1ns / 1ps

module writeback_stage(
    input   [4:0]   rd_write_addr_input,
    input           rd_write_enable_input,
    input           rd_select_input,

    input   [31:0]  alu_result_input,
    input   [31:0]  data_memory_input,

    output  [4:0]   rd_write_addr_output,
    output          rd_write_enable_output,
    output  [31:0]  rd_write_data_output
    );

    // 寄存器写入地址和使能信号直通
    assign rd_write_addr_output = rd_write_addr_input;
    assign rd_write_enable_output = rd_write_enable_input;
    
    // 写回数据选择：ALU结果或存储器数据
    assign rd_write_data_output = rd_select_input ? alu_result_input : data_memory_input;

endmodule