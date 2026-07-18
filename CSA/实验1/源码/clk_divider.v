// 时钟分频模块
`timescale 1ns / 1ps

module frequency_divider(
    input      clock_input,
    output reg clock_output = 1'b0
);

    parameter DIVISION_FACTOR = 20;  // 分频系数
    integer counter_value = 0;       // 计数寄存器

    // 时钟分频逻辑
    always @(posedge clock_input)
    begin
        // 计数器递增并取模
        counter_value = (counter_value + 1) % (DIVISION_FACTOR / 2);
        // 计数器归零时翻转输出时钟
        if(counter_value == 0)
            clock_output <= ~clock_output;
    end

endmodule