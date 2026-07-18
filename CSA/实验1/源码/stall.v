// 数据冲突检测与流水线暂停控制模块
`timescale 1ns / 1ps

module hazard_detection_unit(
    input           clock_signal,
    input           reset_signal,

    input   [4:0]   rs_address_input,
    input   [4:0]   rt_address_input,
    input           rs_read_enable,
    input           rt_read_enable,

    input           execute_write_enable,
    input           memory_write_enable,
    input   [4:0]   execute_write_addr,
    input   [4:0]   memory_write_addr,

    output  reg     stall_signal_output
    );

    // 暂停周期计数器
    reg stall_cycle_counter;

    // 冲突检测与暂停控制逻辑
    always @ (negedge clock_signal or posedge reset_signal) 
    begin
        if(reset_signal) 
        begin
            stall_signal_output    <= 1'b1;
            stall_cycle_counter    <= 1'b0;
        end
        else if (stall_cycle_counter == 0) 
        begin
            // 暂停周期结束处理
            if(stall_signal_output) 
            begin
                stall_signal_output <= 1'b0;
            end
            // 正常流水线运行，检测数据冲突
            else
            begin
                // 执行级与译码级读写冲突，暂停2个周期
                if(execute_write_enable && 
                   ((rs_read_enable && (execute_write_addr == rs_address_input)) || 
                    (rt_read_enable && (execute_write_addr == rt_address_input)))) 
                begin
                    stall_cycle_counter <= 1'b1;
                    stall_signal_output   <= 1'b1;
                end
                // 存储器级与译码级读写冲突，暂停1个周期
                else if(memory_write_enable && 
                       ((rs_read_enable && (memory_write_addr == rs_address_input)) || 
                        (rt_read_enable && (memory_write_addr == rt_address_input)))) 
                begin
                    stall_cycle_counter <= 1'b0;
                    stall_signal_output   <= 1'b1;
                end
            end
        end
        else 
        begin
            // 暂停周期计数递减
            stall_cycle_counter = stall_cycle_counter - 1;
        end
	end
endmodule