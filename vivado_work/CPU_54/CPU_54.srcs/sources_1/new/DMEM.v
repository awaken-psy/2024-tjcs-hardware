module DMEM(                    
    input dm_clk,              
    input dm_ena,              
    input dm_r,               
    input dm_w,                
    input sb_flag,              
    input sh_flag,              
    input sw_flag,           
    input lb_flag,              
    input lh_flag,            
    input lbu_flag,           
    input lhu_flag,           
    input lw_flag,           
    input [31:0] dm_addr,      
    input [31:0] dm_data_in,  
    output [31:0] dm_data_out  
    );

reg [31:0] dmem [1023:0];

assign dm_data_out = (dm_ena && dm_r) ? (lb_flag ? { {24{dmem[dm_addr][7]}} , dmem[dm_addr][7:0] } : 
                     (lbu_flag ? { 24'h0 , dmem[dm_addr][7:0] } :
                     (lh_flag ? { {16{dmem[dm_addr>>1][15]}} , dmem[dm_addr>>1][15:0] } :
                     (lhu_flag ? { 16'h0 , dmem[dm_addr>>1][15:0] } :
                     (lw_flag ? dmem[dm_addr>>2]: 32'bz))))) : 32'bz;
always @(posedge dm_clk) begin
    if(dm_ena && dm_w) begin
        if(sb_flag)        
            dmem[dm_addr][7:0] <= dm_data_in[7:0];
        else if(sh_flag)   
            dmem[dm_addr >> 1][15:0] <= dm_data_in[15:0];
        else if(sw_flag)
            dmem[dm_addr >> 2] <= dm_data_in;
    end
end
endmodule

