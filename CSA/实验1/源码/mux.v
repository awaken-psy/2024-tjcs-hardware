// 四选一多路选择器模块集合
`timescale 1ns / 1ps

// 5位宽四选一数据选择器
module quad_mux_5bit(
    input [4:0] input_channel0,
    input [4:0] input_channel1,
    input [4:0] input_channel2,
    input [4:0] input_channel3,
    input [1:0] selection_signal,
    output reg [4:0] selected_output
    );

    // 选择逻辑处理
    always @ (*)
    begin
        case(selection_signal)
            2'b00:  selected_output <= input_channel0;
            2'b01:  selected_output <= input_channel1;   
            2'b10:  selected_output <= input_channel2;
            2'b11:  selected_output <= input_channel3;
        endcase
    end

endmodule

// 32位宽四选一数据选择器
module quad_mux_32bit(
    input [31:0] input_data0,
    input [31:0] input_data1,
    input [31:0] input_data2,
    input [31:0] input_data3,
    input [1:0]  control_signal,
    output reg [31:0] output_result
    );

    // 通道选择处理逻辑
    always @ (*)
    begin
        case(control_signal)
            2'b00:  output_result <= input_data0;
            2'b01:  output_result <= input_data1;   
            2'b10:  output_result <= input_data2;
            2'b11:  output_result <= input_data3;
        endcase
    end

endmodule