// 执行阶段处理模块
`timescale 1ns / 1ps

module execute_stage(
    input           reset_signal,

    input           data_mem_enable_in,
    input           data_mem_write_in,
    input   [1:0]   data_mem_access_type_in,

    input   [31:0]  rs_operand_in,
    input   [31:0]  rt_operand_in,
    input   [4:0]   rd_write_addr_in,
    input           rd_select_in,
    input           rd_write_enable_in,

    input   [31:0]  immediate_value,
    input   [31:0]  shift_amount,

    input           alu_input_a_select,
    input           alu_input_b_select,
    input   [3:0]   alu_control_code,

    output          data_mem_enable_out,
    output          data_mem_write_out,
    output  [1:0]   data_mem_access_type_out,

    output  [31:0]  rs_operand_out,
    output  [31:0]  rt_operand_out,
    output  [4:0]   rd_write_addr_out,
    output          rd_select_out,
    output          rd_write_enable_out,

    output  [31:0]  alu_result_output
    );
    
    // ALU输入选择信号
    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;
    
    // ALU状态标志位
    wire zero_flag, carry_flag, negative_flag, overflow_flag;

    // 直通信号连接
    assign data_mem_enable_out      = data_mem_enable_in;
    assign data_mem_write_out       = data_mem_write_in;
    assign data_mem_access_type_out = data_mem_access_type_in;

    assign rs_operand_out           = rs_operand_in;
    assign rt_operand_out           = rt_operand_in;
    assign rd_write_addr_out        = rd_write_addr_in;
    assign rd_select_out            = rd_select_in;
    assign rd_write_enable_out      = rd_write_enable_in;

    // ALU输入多路选择
    assign alu_operand_a = alu_input_a_select ? shift_amount : rs_operand_in;
    assign alu_operand_b = alu_input_b_select ? immediate_value : rt_operand_in;

    // 算术逻辑单元实例化
    arithmetic_unit arithmetic_core(
        .operand_a(alu_operand_a), 
        .operand_b(alu_operand_b), 
        .result_output(alu_result_output),
        .operation_control(alu_control_code), 
        .zero_status(zero_flag),
        .carry_status(carry_flag),
        .negative_status(negative_flag),
        .overflow_status(overflow_flag)
    );

endmodule