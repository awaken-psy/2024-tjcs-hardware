`timescale 1ns / 1ps

module multiplexer_2to1_5bit(
    input [4:0]     data_input_0,
    input [4:0]     data_input_1,
    input           selection_signal,
    output reg [4:0] selected_output
);
    
    always @(*) begin
        case (selection_signal)
            1'b0: selected_output <= data_input_0;
            1'b1: selected_output <= data_input_1;
            default: selected_output <= 5'h0;
        endcase
    end
    
endmodule

module multiplexer_2to1_32bit(
    input [31:0]    data_input_0,
    input [31:0]    data_input_1,
    input           selection_signal,
    output reg [31:0] selected_output
);
    
    always @(*) begin
        case (selection_signal)
            1'b0: selected_output <= data_input_0;
            1'b1: selected_output <= data_input_1;
            default: selected_output <= 32'h0;
        endcase
    end
    
endmodule

module multiplexer_4to1_32bit(
    input [31:0]    data_input_0,
    input [31:0]    data_input_1,
    input [31:0]    data_input_2,
    input [31:0]    data_input_3,
    input [1:0]     selection_signal,
    output reg [31:0] selected_output
);
    
    always @(*) begin
        case (selection_signal)
            2'b00: selected_output <= data_input_0;
            2'b01: selected_output <= data_input_1;
            2'b10: selected_output <= data_input_2;
            2'b11: selected_output <= data_input_3;
            default: selected_output <= 32'h0;
        endcase
    end

endmodule

module multiplexer_8to1_32bit(
    input [31:0]    data_input_0,
    input [31:0]    data_input_1,
    input [31:0]    data_input_2,
    input [31:0]    data_input_3,
    input [31:0]    data_input_4,
    input [31:0]    data_input_5,
    input [31:0]    data_input_6,
    input [31:0]    data_input_7,
    input [2:0]     selection_signal,
    output reg [31:0] selected_output
);
    
    always @(*) begin
        case (selection_signal)
            3'b000: selected_output <= data_input_0;
            3'b001: selected_output <= data_input_1;
            3'b010: selected_output <= data_input_2;
            3'b011: selected_output <= data_input_3;
            3'b100: selected_output <= data_input_4;
            3'b101: selected_output <= data_input_5;
            3'b110: selected_output <= data_input_6;
            3'b111: selected_output <= data_input_7;
            default: selected_output <= 32'h0;
        endcase
    end
    
endmodule