`timescale 1ns / 1ps

module dmem(
    input               clock_input,
    input               enable_signal,
    input               write_enable,
    input [1:0]         write_select,
    input [1:0]         read_select, 
    input [31:0]        data_input,
    input [31:0]        address_input,
    output reg [31:0]   data_output
);

    reg [31:0] memory_array [0:2047];
    
    wire [9:0] high_address_bits = (address_input - 32'h10010000) >> 2;
    wire [1:0] low_address_bits = (address_input - 32'h10010000) & 2'b11;

    always @(*) begin
        if (enable_signal && ~write_enable) begin
            case (read_select)
                2'b01: begin
                    data_output <= memory_array[high_address_bits];
                end
                2'b10: begin
                    case (low_address_bits)
                        2'b00: data_output <= { 16'h0, memory_array[high_address_bits][15:0] };
                        2'b10: data_output <= { 16'h0, memory_array[high_address_bits][31:16] };
                        default: data_output <= 32'h0;
                    endcase
                end
                2'b11: begin
                    case (low_address_bits)
                        2'b00: data_output <= { 24'h0, memory_array[high_address_bits][7:0] };
                        2'b01: data_output <= { 24'h0, memory_array[high_address_bits][15:8] };
                        2'b10: data_output <= { 24'h0, memory_array[high_address_bits][23:16] };
                        2'b11: data_output <= { 24'h0, memory_array[high_address_bits][31:24] };
                        default: data_output <= 32'h0;
                    endcase
                end
                default: data_output <= 32'h0;
            endcase
        end
    end

    always @(posedge clock_input) begin
        if (enable_signal) begin
            if (write_enable) begin
                case (write_select)
                    2'b01: begin
                        memory_array[high_address_bits] <= data_input;
                    end
                    2'b10: begin
                        case (low_address_bits)
                            2'b00: memory_array[high_address_bits][15:0] <= data_input[15:0];
                            2'b10: memory_array[high_address_bits][31:16] <= data_input[15:0];
                            default: ; // No operation
                        endcase
                    end
                    2'b11: begin
                        case (low_address_bits)
                            2'b00: memory_array[high_address_bits][7:0] <= data_input[7:0];
                            2'b01: memory_array[high_address_bits][15:8] <= data_input[7:0];
                            2'b10: memory_array[high_address_bits][23:16] <= data_input[7:0];
                            2'b11: memory_array[high_address_bits][31:24] <= data_input[7:0];
                            default: ; // No operation
                        endcase
                    end
                    default: ; // No operation
                endcase
            end
        end
    end

endmodule

module data_cutter(
    input [31:0]        data_input,
    input [2:0]         cut_select,
    input               sign_extend_enable,
    output reg [31:0]   data_output
);
    
    always @(*) begin
        case (cut_select)
            3'b010: data_output <= { { 24{ sign_extend_enable & data_input[7] } }, data_input[7:0] };
            3'b011: data_output <= { 24'h0, data_input[7:0] };
            3'b001: data_output <= { { 16{ sign_extend_enable & data_input[15] } }, data_input[15:0] };
            3'b100: data_output <= { 16'h0, data_input[15:0] };
            default: data_output <= data_input;
        endcase
    end

endmodule