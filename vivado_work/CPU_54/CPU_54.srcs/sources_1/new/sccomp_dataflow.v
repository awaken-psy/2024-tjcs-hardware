module sccomp_dataflow(
    input clk_in,       //时钟信号
    input reset,        //复位信号
    output [31:0] inst, //输出指令
    output [31:0] pc    //执行地址
    );

wire [31:0] pc_out;
wire [31:0] dm_addr_temp;
wire [10:0] im_addr_in;     
wire [31:0] im_instr_out;   
wire dm_ena;                
wire dm_r, dm_w;           
wire [31:0] dm_addr;       
wire [31:0] dm_data_out;  
wire [31:0] dm_data_w;      
wire sb_flag;             
wire sh_flag;            
wire sw_flag;              
wire lb_flag;             
wire lh_flag;            
wire lbu_flag;            
wire lhu_flag;           
wire lw_flag;               
assign im_addr_in = (pc_out - 32'h00040000) / 4;    
assign dm_addr = dm_addr_temp - 32'h10010000;
assign pc = pc_out;
assign inst = im_instr_out;

IMEM imem(
    .addr(im_addr_in),
    .str(im_instr_out)
    );

DMEM dmem(
    .dm_clk(clk_in),
    .dm_ena(dm_ena),
    .dm_r(dm_r),
    .dm_w(dm_w),
    .sb_flag(sb_flag),
    .sh_flag(sh_flag),
    .sw_flag(sw_flag),
    .lb_flag(lb_flag),
    .lh_flag(lh_flag),
    .lbu_flag(lbu_flag),
    .lhu_flag(lhu_flag),
    .lw_flag(1),
    .dm_addr(dm_addr),
    .dm_data_in(dm_data_w),
    .dm_data_out(dm_data_out)
    );

cpu sccpu(
    .clk(clk_in),
    .ena(1'b1),
    .rst(reset),
    .IM_instr(im_instr_out),
    .dm_data(dm_data_out),
    .dm_ena(dm_ena),
    .dm_w(dm_w),
    .dm_r(dm_r),
    .pc_out(pc_out),
    .ALU_RES(dm_addr_temp),
    .dm_data_w(dm_data_w),
    .sb_flag(sb_flag),
    .sh_flag(sh_flag),
    .sw_flag(sw_flag),
    .lb_flag(lb_flag),
    .lh_flag(lh_flag),
    .lbu_flag(lbu_flag),
    .lhu_flag(lhu_flag),
    .lw_flag(lw_flag)
    );

endmodule