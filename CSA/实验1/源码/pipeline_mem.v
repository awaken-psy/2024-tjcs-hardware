// 存储器访问阶段处理模块
`timescale 1ns / 1ps

module memory_access_stage(
    input           clock_signal,

    input           data_mem_enable_input,
    input           data_mem_write_input,
    input   [1:0]   data_mem_access_type_input,

    input   [31:0]  rs_operand_input,
    input   [31:0]  rt_operand_input,
    input   [4:0]   rd_write_addr_input,
    input           rd_select_input,
    input           rd_write_enable_input,

    input   [31:0]  alu_result_input,

    output  [4:0]   rd_write_addr_output,
    output          rd_select_output,
    output          rd_write_enable_output,

    output  [31:0]  alu_result_output,
    output  [31:0]  data_memory_output
    );
    
    // 数据存储器地址计算
    wire [31:0] data_memory_address = (alu_result_input - 32'h10010000) / 4;

    // 直通信号连接
    assign rd_write_addr_output = rd_write_addr_input;
    assign rd_select_output     = rd_select_input;
    assign rd_write_enable_output = rd_write_enable_input;
    
    assign alu_result_output = alu_result_input;
    
    // 数据存储器实例化
    data_memory_unit data_memory_instance(
        .clock_signal(clock_signal),
        .enable_signal(data_mem_enable_input),
        .write_enable(data_mem_write_input),
        .address_input(data_memory_address),
        .access_type(data_mem_access_type_input),
        .write_data(rt_operand_input),
        .read_data(data_memory_output)
    );

endmodule