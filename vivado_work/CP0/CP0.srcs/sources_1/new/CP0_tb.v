`timescale 1ns / 1ps

module CP0(
    input        clk,         // 时钟信号
    input        rst,         // 复位信号
    input        exc,         // 异常/中断信号
    input        mfc0,        // 读CP0寄存器指令
    input        mtc0,        // 写CP0寄存器指令
    input        eret,        // 异常返回指令
    input [31:0] pc,          // 当前程序计数器
    input [4:0]  Rd,          // 寄存器选择
    input [4:0]  cause,       // 中断原因编码
    input [31:0] wdata,       // 写入数据
    output [31:0] rdata,      // 读取数据
    output [31:0] status,     // 状态寄存器值
    output [31:0] exc_addr    // 异常处理地址
);

    // 中断原因编码定义
    parameter SYSCALL = 5'b01000,
              BREAK   = 5'b01001,
              TEQ     = 5'b01101;
              
    // CP0寄存器定义
    reg [31:0] reg_status;   // 12: 状态寄存器
    reg [31:0] reg_cause;    // 13: 原因寄存器
    reg [31:0] reg_epc;      // 14: 异常PC寄存器
    
    // 连续赋值输出
    assign status = reg_status;
    assign exc_addr = eret ? reg_epc : 32'd0;
    
    // 寄存器读取逻辑
    assign rdata = (Rd == 5'd12) ? reg_status :
                  (Rd == 5'd13) ? reg_cause :
                  (Rd == 5'd14) ? reg_epc : 32'd0;

    // 寄存器更新逻辑
    always @(posedge clk) begin
        if (rst) begin
            // 复位寄存器
            reg_status <= 32'd0;
            reg_cause <= 32'd0;
            reg_epc <= 32'd0;
        end
        else begin
            // 中断处理
            if (exc && (cause == SYSCALL || cause == BREAK || cause == TEQ)) begin
                reg_status <= reg_status << 5;          // 进入新的异常级别
                reg_cause <= {27'd0, cause} << 2;       // 记录中断原因
                reg_epc <= pc;                         // 保存异常点PC
            end
            // 异常返回
            else if (exc && eret) begin
                reg_status <= reg_status >> 5;          // 恢复先前异常级别
            end
            // MTC0写操作
            else if (mtc0) begin
                case (Rd)
                    5'd12: reg_status <= wdata;
                    5'd13: reg_cause <= wdata;
                    5'd14: reg_epc <= wdata;
                endcase
            end
        end
    end
endmodule
