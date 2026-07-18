// 寄存器文件模块
`timescale 1ns / 1ps

module register_file(
    input               clock_signal,
    input               reset_signal,

    input               rs_read_enable,
    input               rt_read_enable,
    input               rd_write_enable,
    input   [4:0]       rd_address,
    input   [4:0]       rs_address,
    input   [4:0]       rt_address,
    input   [31:0]      rd_write_data,

    input   [31:0]      initial_floor_value,
    input   [31:0]      initial_resistance_value,

    output reg [31:0]   rs_data_output,
    output reg [31:0]   rt_data_output,

    output  [31:0]      attempt_count_result,
    output  [31:0]      broken_count_result,
    output              last_broken_status,
    output [15:0] upward_floor_count,
    output [15:0] downward_floor_count
);

    // 特殊寄存器映射
    assign attempt_count_result     = register_array[4];
    assign broken_count_result      = register_array[5];
    assign last_broken_status       = register_array[6][0];
    assign upward_floor_count       = register_array[16];
    assign downward_floor_count     = register_array[17];

    // 32个32位寄存器数组
    reg [31:0] register_array[31:0];

    // 寄存器写操作逻辑
    always @(posedge clock_signal or posedge reset_signal)
    begin
        // 复位信号处理
        if (reset_signal)
            begin
                register_array[0]  <= 32'h00000000;
                register_array[1]  <= 32'h00000000;
                register_array[2]  <= initial_floor_value;      // 初始化楼层数
                register_array[3]  <= initial_resistance_value; // 初始化耐摔值
                register_array[4]  <= 32'h00000000;             // 尝试次数计数器
                register_array[5]  <= 32'h00000000;             // 损坏次数计数器
                register_array[6]  <= 32'h00000000;             // 最后状态标志
                register_array[7]  <= 32'h00000000;
                register_array[8]  <= 32'h00000000;
                register_array[9]  <= 32'h00000000;
                register_array[10] <= 32'h00000000;
                register_array[11] <= 32'h00000000;
                register_array[12] <= 32'h00000000;
                register_array[13] <= 32'h00000000;
                register_array[14] <= 32'h00000000;
                register_array[15] <= 32'h00000000;
                register_array[16] <= 32'h00000000;             // 上行楼层数
                register_array[17] <= 32'h00000000;             // 下行楼层数
                register_array[18] <= 32'h00000000;
                register_array[19] <= 32'h00000000;
                register_array[20] <= 32'h00000000;
                register_array[21] <= 32'h00000000;
                register_array[22] <= 32'h00000000;
                register_array[23] <= 32'h00000000;
                register_array[24] <= 32'h00000000;
                register_array[25] <= 32'h00000000;
                register_array[26] <= 32'h00000000;
                register_array[27] <= 32'h00000000;
                register_array[28] <= 32'h00000000;
                register_array[29] <= 32'h00000000;
                register_array[30] <= 32'h00000000;
                register_array[31] <= 32'h00000000;
            end
        // 寄存器写操作（零寄存器不可写）
        else if(rd_write_enable && rd_address != 0)
        begin
            register_array[rd_address] <= rd_write_data;
        end
    end

    // 寄存器读操作逻辑
    always @(negedge clock_signal)
    begin
        if(reset_signal) 
        begin
            rs_data_output <= 32'h00000000;
            rt_data_output <= 32'h00000000;
        end
        else 
        begin
            // RS端口读操作（支持写前读旁路）
            if(rs_read_enable)
            begin
                rs_data_output <= ((rd_write_enable && (rd_address == rs_address)) ? 
                                  rd_write_data : register_array[rs_address]);
            end
            else
            begin
                rs_data_output <= 32'h00000000;
            end

            // RT端口读操作（支持写前读旁路）
            if(rt_read_enable)
            begin
                rt_data_output <= ((rd_write_enable && (rd_address == rt_address)) ? 
                                  rd_write_data : register_array[rt_address]);
            end
            else
            begin
                rt_data_output <= 32'h00000000;
            end
        end
    end

endmodule