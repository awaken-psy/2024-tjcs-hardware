module PC(                      
    input  pc_clk,             
    input  pc_ena,              
    input  rst,                 
    input  [31:0] pc_addr_in,   
    output [31:0] pc_addr_out  
    );

reg [31:0] pc_reg = 32'h00400000;


assign pc_addr_out = pc_ena ? pc_reg : 32'hz;   



always @(negedge pc_clk or posedge rst)   
begin
    if(rst && pc_ena)          
        pc_reg <= 32'h00400000; 
    else if(pc_ena)            
        pc_reg <= pc_addr_in;

end
endmodule
