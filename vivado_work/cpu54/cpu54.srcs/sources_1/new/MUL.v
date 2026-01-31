module MUL(
    input sign_flag,    
    input [31:0] A,     
    input [31:0] B,    
    output [31:0] HI,  
    output [31:0] LO    
    );




    wire [63:0] result;                
    wire [63:0] unsigned_result;        
    wire signed [63:0] signed_result;   
    wire [63:0] unsigned_A;             
    wire [63:0] unsigned_B;             
    wire signed [63:0] signed_A;       
    wire signed [63:0] signed_B;       
    
    assign unsigned_A = { 32'd0, A };
    assign unsigned_B = { 32'd0, B };
    assign unsigned_result = unsigned_A * unsigned_B;
    
    assign signed_A = { {32{A[31]}} , A };
    assign signed_B = { {32{B[31]}} , B };
    assign signed_result = signed_A * signed_B;
    
    assign result = sign_flag ? signed_result : unsigned_result;
    
    
    assign HI = result[63:32];
    assign LO = result[31:0];
    
endmodule
