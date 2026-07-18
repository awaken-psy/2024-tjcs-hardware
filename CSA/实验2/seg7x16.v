`timescale 1ns / 1ps

module seven_segment_display(
    input           clock_input,
    input           reset_input,
    input           chip_select,
    input   [31:0]  display_data,
    output  [7:0]   segment_output,
    output  [7:0]   digit_select
    );

    reg [14:0] refresh_counter;
    
    // 刷新计数器
    always @(posedge clock_input or posedge reset_input) begin
        if (reset_input)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1'b1;
    end
 
    wire display_clock = refresh_counter[14]; 
     
    reg [2:0] current_digit;
     
    // 数字选择逻辑
    always @(posedge display_clock or posedge reset_input) begin
        if (reset_input)
            current_digit <= 0;
        else
            current_digit <= current_digit + 1'b1;
    end
          
    reg [7:0] digit_select_buffer;
     
    always @(*) begin
        case (current_digit)
            3'd7: digit_select_buffer = 8'b01111111;
            3'd6: digit_select_buffer = 8'b10111111;
            3'd5: digit_select_buffer = 8'b11011111;
            3'd4: digit_select_buffer = 8'b11101111;
            3'd3: digit_select_buffer = 8'b11110111;
            3'd2: digit_select_buffer = 8'b11111011;
            3'd1: digit_select_buffer = 8'b11111101;
            3'd0: digit_select_buffer = 8'b11111110;
        endcase
    end
    
    reg [31:0] data_storage;
    
    always @(posedge clock_input or posedge reset_input) begin
        if (reset_input)
            data_storage <= 0;
        else if (chip_select)
            data_storage <= display_data;
    end
          
    reg [3:0] current_nibble;
    
    always @(*) begin
        case (current_digit)
            3'd0: current_nibble = data_storage[3:0];
            3'd1: current_nibble = data_storage[7:4];
            3'd2: current_nibble = data_storage[11:8];
            3'd3: current_nibble = data_storage[15:12];
            3'd4: current_nibble = data_storage[19:16];
            3'd5: current_nibble = data_storage[23:20];
            3'd6: current_nibble = data_storage[27:24];
            3'd7: current_nibble = data_storage[31:28];
        endcase
    end
     
    reg [7:0] segment_buffer;
    
    always @(posedge clock_input or posedge reset_input) begin
        if (reset_input)
            segment_buffer <= 8'hff;
        else begin
            case (current_nibble)
                4'h0: segment_buffer <= 8'hC0;
                4'h1: segment_buffer <= 8'hF9;
                4'h2: segment_buffer <= 8'hA4;
                4'h3: segment_buffer <= 8'hB0;
                4'h4: segment_buffer <= 8'h99;
                4'h5: segment_buffer <= 8'h92;
                4'h6: segment_buffer <= 8'h82;
                4'h7: segment_buffer <= 8'hF8;
                4'h8: segment_buffer <= 8'h80;
                4'h9: segment_buffer <= 8'h90;
                4'hA: segment_buffer <= 8'h88;
                4'hB: segment_buffer <= 8'h83;
                4'hC: segment_buffer <= 8'hC6;
                4'hD: segment_buffer <= 8'hA1;
                4'hE: segment_buffer <= 8'h86;
                4'hF: segment_buffer <= 8'h8E;
            endcase
        end
    end
          
    assign digit_select = digit_select_buffer;
    assign segment_output = segment_buffer;

endmodule