`include "mips_definitions.vh"
`timescale 1ns / 1ps

module forwarding(
    input               clock_input,
    input               reset_input,
    input [5:0]         opcode,
    input [5:0]         function_code,
    input               rs_read_enable,
    input               rt_read_enable,
    input [4:0]         rs_address,
    input [4:0]         rt_address,

    input [5:0]         ex_opcode,
    input [5:0]         ex_function,
    input [31:0]        ex_hi_data,
    input [31:0]        ex_lo_data,
    input [31:0]        ex_rd_data,
    input               ex_hi_write_enable,
    input               ex_lo_write_enable,
    input               ex_rd_write_enable,
    input [4:0]         ex_rd_address,

    input [31:0]        mem_hi_data,
    input [31:0]        mem_lo_data,
    input [31:0]        mem_rd_data,
    input               mem_hi_write_enable,
    input               mem_lo_write_enable,
    input               mem_rd_write_enable,
    input [4:0]         mem_rd_address,

    output reg          stall_signal,
    output reg          forwarding_active,
    output reg          forward_rs,
    output reg          forward_rt,
    output reg [31:0]   forwarded_rs_data,
    output reg [31:0]   forwarded_rt_data,
    output reg [31:0]   forwarded_hi_data,
    output reg [31:0]   forwarded_lo_data
);

    always @(negedge clock_input or posedge reset_input) begin
        if (reset_input) begin
            stall_signal         <= 1'b0;
            forwarded_rs_data    <= 32'h0;
            forwarded_rt_data    <= 32'h0;
            forwarded_hi_data    <= 32'h0;
            forwarded_lo_data    <= 32'h0;
            forwarding_active    <= 1'b0;
            forward_rs           <= 1'b0;
            forward_rt           <= 1'b0;
        end else if (stall_signal) begin
            stall_signal <= 1'b0;
            if (forward_rs) begin
                forwarded_rs_data <= mem_rd_data;
            end else if (forward_rt) begin
                forwarded_rt_data <= mem_rd_data;
            end
        end else if (~stall_signal) begin
            forwarding_active = 1'b0;
            forward_rs = 1'b0;
            forward_rt = 1'b0;
            
            if (opcode == `OPCODE_MFHI && function_code == `FUNC_MFHI) begin
                if (ex_hi_write_enable) begin
                    forwarded_hi_data   <= ex_hi_data;
                    forwarding_active   <= 1'b1;
                end else if (mem_hi_write_enable) begin
                    forwarded_hi_data   <= mem_hi_data;
                    forwarding_active   <= 1'b1;
                end
            end else if (opcode == `OPCODE_MFLO && function_code == `FUNC_MFLO) begin
                if (ex_lo_write_enable) begin
                    forwarded_lo_data   <= ex_lo_data;
                    forwarding_active   <= 1'b1;
                end else if (mem_lo_write_enable) begin
                    forwarded_lo_data   <= mem_lo_data;
                    forwarding_active   <= 1'b1;
                end
            end else begin
                // Analyze RS conflict
                if (ex_rd_write_enable && rs_read_enable && ex_rd_address == rs_address) begin
                    if (ex_opcode == `OPCODE_LW || ex_opcode == `OPCODE_LH || 
                        ex_opcode == `OPCODE_LHU || ex_opcode == `OPCODE_LB || 
                        ex_opcode == `OPCODE_LBU) begin
                        forward_rs        <= 1'b1;
                        stall_signal      <= 1'b1;
                        forwarding_active <= 1'b1;
                    end else begin
                        forward_rs          <= 1'b1;
                        forwarded_rs_data   <= ex_rd_data;
                        forwarding_active   <= 1'b1;
                    end
                end else if (mem_rd_write_enable && rs_read_enable && mem_rd_address == rs_address) begin
                    forward_rs          <= 1'b1;
                    forwarded_rs_data   <= mem_rd_data;
                    forwarding_active   <= 1'b1;
                end
                
                // Analyze RT conflict
                if (ex_rd_write_enable && rt_read_enable && ex_rd_address == rt_address) begin
                    if (ex_opcode == `OPCODE_LW || ex_opcode == `OPCODE_LH || 
                        ex_opcode == `OPCODE_LHU || ex_opcode == `OPCODE_LB || 
                        ex_opcode == `OPCODE_LBU) begin
                        forward_rt        <= 1'b1;
                        stall_signal      <= 1'b1;
                        forwarding_active <= 1'b1;
                    end else begin
                        forward_rt          <= 1'b1;
                        forwarded_rt_data   <= ex_rd_data;
                        forwarding_active   <= 1'b1;
                    end
                end else if (mem_rd_write_enable && rt_read_enable && mem_rd_address == rt_address) begin
                    forward_rt          <= 1'b1;
                    forwarded_rt_data   <= mem_rd_data;
                    forwarding_active   <= 1'b1;
                end
            end
        end
    end      

endmodule