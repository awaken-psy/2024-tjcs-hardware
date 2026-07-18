`timescale 1ns / 1ps

module register_file_unit(
    input               system_clock, 
    input               system_reset, 
    input               write_enable, 
    input       [4:0]   source_reg_addr, 
    input       [4:0]   target_reg_addr, 
    input               source_read_enable,
    input               target_read_enable,
    input       [4:0]   dest_reg_addr, 
    input       [31:0]  write_data, 
    output reg  [31:0]  source_reg_data, 
    output reg  [31:0]  target_reg_data,
    output      [31:0]  monitor_reg_6,
    output      [31:0]  monitor_reg_7,
    output      [31:0]  monitor_reg_15,
    output      [31:0]  monitor_reg_16
    );
    
    reg [31:0] register_bank [0:31];
    integer register_index;

    // 写操作 - 时钟沿触发
    always @(posedge system_clock or posedge system_reset) begin
        if (system_reset) begin
            for (register_index = 0; register_index < 32; register_index = register_index + 1)
                register_bank[register_index] <= 32'b0;
        end else begin
            if (write_enable && (dest_reg_addr != 0))
                register_bank[dest_reg_addr] <= write_data;
        end
    end

    // 源寄存器读操作 - 组合逻辑
    always @(*) begin
        if (system_reset) 
            source_reg_data <= 32'b0;
        else if (source_reg_addr == 5'b0) 
            source_reg_data <= 32'b0;
        else if ((source_reg_addr == dest_reg_addr) && write_enable && source_read_enable) 
            source_reg_data <= write_data;
        else if (source_read_enable) 
            source_reg_data <= register_bank[source_reg_addr];
        else 
            source_reg_data <= 32'bz;
    end

    // 目标寄存器读操作 - 组合逻辑
    always @(*) begin
        if (system_reset) 
            target_reg_data <= 32'b0;
        else if (target_reg_addr == 5'b0) 
            target_reg_data <= 32'b0;
        else if ((target_reg_addr == dest_reg_addr) && write_enable && target_read_enable) 
            target_reg_data <= write_data;
        else if (target_read_enable) 
            target_reg_data <= register_bank[target_reg_addr];
        else 
            target_reg_data <= 32'bz;
    end

    // 监控输出
    assign monitor_reg_6 = register_bank[6];
    assign monitor_reg_7 = register_bank[7];
    assign monitor_reg_15 = register_bank[15];
    assign monitor_reg_16 = register_bank[16];

endmodule