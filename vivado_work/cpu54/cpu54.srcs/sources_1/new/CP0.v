module CP0(
    input cp0_clk,         
    input cp0_rst,      
    input cp0_ena,     
    input MFC0,            
    input MTC0,           
    input ERET,            
    input [31:0] PC,       
    input [4:0] addr,      
    input [4:0] cause,     
    input [31:0] data_in,   
    output [31:0] CP0_out,  
    output [31:0] EPC_out  
    );
parameter SYSCALL = 5'b01000,  
          BREAK   = 5'b01001,  
          TEQ     = 5'b01101;  
parameter STATUS = 4'd12,      
          CAUSE  = 4'd13,     
          EPC    = 4'd14;     

reg [31:0] cp0_reg [31:0];    
assign EPC_out = ERET && cp0_ena? cp0_reg [EPC] : 32'hz;
assign CP0_out = MFC0 && cp0_ena? cp0_reg [addr[4:0]] : 32'hz; 

always @(negedge cp0_clk or posedge cp0_rst)
begin
    if(cp0_rst && cp0_ena) begin 
        cp0_reg [0] <=0 ;
        cp0_reg [1] <=0 ;
        cp0_reg [2] <=0 ;
        cp0_reg [3] <=0 ;
        cp0_reg [4] <=0 ;
        cp0_reg [5] <=0 ;
        cp0_reg [6] <=0 ;
        cp0_reg [7] <=0 ;
        cp0_reg [8] <=0 ;
        cp0_reg [9] <=0 ;
        cp0_reg [10] <=0 ;
        cp0_reg [11] <=0 ;
        cp0_reg [12] <=0 ;
        cp0_reg [13] <=0 ;
        cp0_reg [14] <=0 ;
        cp0_reg [15] <=0 ;
        cp0_reg [16] <=0 ;
        cp0_reg [17] <=0 ;
        cp0_reg [18] <=0 ;
        cp0_reg [19] <=0 ;
        cp0_reg [20] <=0 ;
        cp0_reg [21] <=0 ;
        cp0_reg [22] <=0 ;
        cp0_reg [23] <=0 ;
        cp0_reg [24] <=0 ;
        cp0_reg [25] <=0 ;
        cp0_reg [26] <=0 ;
        cp0_reg [27] <=0 ;
        cp0_reg [28] <=0 ;
        cp0_reg [29] <=0 ;
        cp0_reg [30] <=0 ;
        cp0_reg [31] <=0 ;        
    end
    
    else if(cp0_ena) begin
        if(MTC0)  
            cp0_reg [addr] <= data_in;
        else if (cause == SYSCALL || cause == BREAK || cause == TEQ) begin
            cp0_reg [STATUS] <= cp0_reg [STATUS] << 5;  
            cp0_reg [CAUSE]  <= {24'b0 , cause , 2'b0}; 
            cp0_reg [EPC]    <= PC;                     
        end
        else if(ERET) //   ж ָ  
            cp0_reg [STATUS] <= cp0_reg [STATUS] >> 5;  
    end
end 
endmodule
