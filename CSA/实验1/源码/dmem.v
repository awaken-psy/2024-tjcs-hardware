// 数据存储器模块
`timescale 1ns / 1ps

module data_memory_unit(
    input           clock_signal,
    input           enable_signal,
    input           write_enable,
    input   [31:0]  address_input,
    input   [1:0]   access_type,
    input   [31:0]  write_data,
    output  [31:0]  read_data
);

    // 存储器阵列定义：2048个32位存储单元
    reg [31:0] memory_array[0:2047];

    // 存储器写操作逻辑
    always @(negedge clock_signal)
    begin
        if(enable_signal && write_enable)
            case(access_type)
                2'b10:   // 字节写入模式
                    memory_array[address_input][7:0] <= write_data[7:0];
                2'b01:   // 半字写入模式
                    memory_array[address_input][15:0] <= write_data[15:0];
                2'b00:   // 全字写入模式
                    memory_array[address_input] <= write_data;
                default: // 默认情况处理
                    memory_array[address_input] <= 32'bz;
            endcase
        else
            ; // 空语句，保持结构清晰
    end

    // 存储器读操作逻辑
    assign read_data = enable_signal ? memory_array[address_input] : 32'bz;

endmodule