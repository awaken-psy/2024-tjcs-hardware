`timescale 1ns / 1ps

module CP0(
    input        clk,      // 时钟信号
    input        rst,      // 复位信号
    input        exc,      // 异常/中断信号
    input        mfc0,     // 读CP0寄存器指令
    input        mtc0,     // 写CP0寄存器指令
    input        eret,     // 异常返回指令
    input [31:0] pc,       // 当前程序计数器
    input [4:0]  Rd,       // 寄存器选择
    input [4:0]  cause,    // 中断原因编码
    input [31:0] wdata,    // 写入数据
    output reg [31:0] rdata,   // 读取数据
    output [31:0] status,  // 状态寄存器值
    output [31:0] exc_addr // 异常处理地址
);
    // CP0寄存器定义
    reg [31:0] status12;   // 状态寄存器 (SR)
    reg [31:0] cause13;    // 原因寄存器
    reg [31:0] epc14;      // 异常PC寄存器

    // 连续赋值输出
    assign status = status12;      // 始终输出状态寄存器
    assign exc_addr = eret ? epc14 : 32'd0;  // eret时输出EPC

    // 组合逻辑：读取CP0寄存器
    always @(*) begin
        if (mfc0) begin
            case (Rd)
                5'd12: rdata = status12;
                5'd13: rdata = cause13;
                5'd14: rdata = epc14;
                default: rdata = 32'd0;
            endcase
        end else begin
            rdata = 32'd0;
        end
    end

    // 时序逻辑：CP0寄存器更新
    always @(posedge clk) begin
        if (rst) begin
            // 复位所有寄存器
            status12 <= 32'd0;
            cause13 <= 32'd0;
            epc14 <= 32'd0;
        end else if (exc) begin
            // 异常处理：更新状态和原因寄存器
            if (cause != 5'd0) begin
                // 左移状态寄存器保存当前状态
                status12 <= {status12[26:0], 5'b0};
                // 设置原因寄存器[7:2]位
                cause13 <= {24'd0, cause, 2'b00};
                // 保存异常发生时的PC
                epc14 <= pc;
            end
            // 异常返回：恢复先前状态
            else if (eret) begin
                status12 <= {5'b0, status12[31:5]};
            end
        end
        
        // MTC0指令写入（优先级低于异常处理）
        if (mtc0 && !rst) begin
            case (Rd)
                5'd12: status12 <= wdata;
                5'd13: cause13 <= wdata;
                5'd14: epc14 <= wdata;
            endcase
        end
    end
endmodule  
