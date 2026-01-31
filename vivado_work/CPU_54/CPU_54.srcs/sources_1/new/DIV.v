module DIV(
    input sign_flag,    
    input [31:0] A,     
    input [31:0] B,     
    output [31:0] R,    
    output [31:0] Q    
    );
    wire signed [31:0] signed_A; 
    wire signed [31:0] signed_B; 
    assign signed_A = A;
    assign signed_B = B;
    assign R =  (B == 32'd0) ? 32'd0 : (sign_flag ? (signed_A % signed_B) : (A % B));
    assign Q =  (B == 32'd0) ? 32'd0 : (sign_flag ? (signed_A / signed_B) : (A / B));
    
endmodule
