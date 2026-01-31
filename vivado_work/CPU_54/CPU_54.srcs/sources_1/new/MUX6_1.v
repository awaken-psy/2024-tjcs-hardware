
module MUX6_1(
    input [2:0] sel,    
    input [31:0] in1, 
    input [31:0] in2,   
    input [31:0] in3,   
    input [31:0] in4,  
    input [31:0] in5,  
    input [31:0] in6, 
    output [31:0] out   
    );
    reg [31:0] out_temp;
    always @(*) begin
        case(sel)
            3'b001: out_temp = in1;
            3'b010: out_temp = in2;
            3'b011: out_temp = in3;
            3'b100: out_temp = in4;
            3'b101: out_temp = in5;
            3'b110: out_temp = in6;
            default: out_temp = 32'b0;
        endcase
    end
    assign out = out_temp;
endmodule