// 程序计数器寄存器模块
`timescale 1ns / 1ps

module program_counter_register(
    input               clock_signal,
    input               enable_signal,
    input               reset_signal,
    input               stall_signal,
    input      [31:0]   next_pc_value,
    output reg [31:0]   current_pc_value
    );
    
    // 程序计数器更新逻辑
    always @(posedge clock_signal or posedge reset_signal)
    begin
        // 复位信号优先处理
        if(reset_signal)
        begin
            current_pc_value <= 32'h00400000;  // 复位到初始地址
        end
        // 使能信号有效时的处理
        else if(enable_signal)
        begin
            // 流水线暂停时保持当前值
            if(stall_signal)
            begin
                current_pc_value <= current_pc_value;
            end
            // 正常情况更新为下一个PC值
            else
            begin
                current_pc_value <= next_pc_value;
            end
        end
        // 使能信号无效时输出高阻态
        else
        begin
            current_pc_value <= 32'bz;
        end
    end
    
endmodule