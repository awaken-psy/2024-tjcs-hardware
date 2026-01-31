module cpu(
    input clk,                  
    input ena,                
    input rst,               
    input [31:0] IM_instr, 
    input [31:0] dm_data,      
    output dm_ena,              
    output dm_w,               
    output dm_r,               
    output [31:0] pc_out,       
    output [31:0] ALU_RES,     
    output [31:0] dm_data_w,    
    output sb_flag,            
    output sh_flag,            
    output sw_flag,         
    output lb_flag,             
    output lh_flag,            
    output lbu_flag,           
    output lhu_flag,          
    output lw_flag         
    );
parameter ADD=0;
parameter ADDU=1;
parameter SUB=2;
parameter SUBU=3;
parameter AND=4;
parameter OR=5;
parameter XOR=6;
parameter NOR=7;
parameter SLT=8;
parameter SLTU=9;
parameter SLL=10;
parameter SRL=11;
parameter SRA=12;
parameter SLLV=13;
parameter SRLV=14;
parameter SRAV=15;
parameter JR=16;
    parameter ADDI=17;
    parameter ADDIU=18;
    parameter ANDI=19;
    parameter ORI=20;
    parameter XORI=21;
    parameter LW=22;
    parameter SW=23;
    parameter BEQ=24;
    parameter BNE=25;
    parameter SLTI=26;
    parameter SLTIU=27;
    parameter LUI=28;
    parameter J=29;
    parameter JAL=30;
    parameter BREAK=31;
    parameter SYSCALL=32;
    parameter TEQ=33;
    parameter ERET=34;
    parameter MFC0=35;
    parameter MTC0=36;
    parameter CLZ=37;
    parameter DIVU=38;
    parameter DIV=39;
    parameter LB=40;
    parameter LBU=41;
    parameter LH=42;
    parameter LHU=43;
    parameter SB=44;
    parameter SH=45;
    parameter MFHI=46;
    parameter MFLO=47;
    parameter MTHI=48;
    parameter MTLO=49;
    parameter MULT=50;
    parameter MULTU=51;
    parameter BGEZ=52;
    parameter JALR=53;
    wire [53:0] order;
    wire [31:0] PC_in;
    wire [31:0] PC_out;
    wire [31:0] NPC;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_r;
    wire[3:0]aluc;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
 assign ALU_RES = alu_r;
    wire [31:0] Rs;
    wire [31:0] Rt;
    wire [31:0] Rd;
    wire [4:0] Rsc;
    wire [4:0] Rtc;
    wire [4:0] Rdc;
    wire Rs_ena;
    wire Rt_ena;
    wire Rd_ena1;
    wire Rd_ena2;
    wire RF_W;
    wire RF_R;
    wire RF_CLK;
    wire [31:0] MUL_H;
    wire [31:0] MUL_L;
    wire [31:0] DIV_Q;
    wire [31:0] DIV_R;
    wire sign_flag;
    wire [31:0] HI_in;
    wire [31:0] LO_in;
    wire [31:0] HI_LO;
    wire [31:0] HI_w;
    wire [31:0] LO_w;
    wire [31:0] HI_out;
    wire [31:0] LO_out;
    wire [31:0] MUX1_out;
    wire [31:0] MUX2_out;
    wire [31:0] MUX3_out;
    wire [31:0] MUX4_out;
    wire [31:0] MUX5_out;
    wire [31:0] MUX6_out;
    wire [31:0] MUX7_out;
    wire [31:0] MUX8_out;

    wire [2:0] M1;        
    wire [1:0] M2;       
    wire M3;              
    wire M4_ena1,M4_ena2; 
    wire [2:0] M5;       
    wire M6_ena1,M6_ena2; 
    wire M7_ena1,M7_ena2; 
    wire M8;             
    wire[31:0]UEXT16;
    wire[31:0]SEXT16;
    wire[31:0]EXT16;
    wire[31:0]EXT5;
    wire[31:0]EXT18;
    wire[31:0]CAT;

    Decoder decoder(
        .instr(IM_instr),
        .order(order)
    );



    wire[31:0]exc_addr;
    wire[31:0]cp0_rdata;
    wire exception;
    wire [31:0]cp0_wdata;
    wire [31:0]status;
    wire [31:0] cp0_out;       
    wire [31:0] epc_out;        
    wire [4:0] cause;          
    assign cause = order[BREAK]?5'b01001:(order[SYSCALL]?5'b01000:(order[TEQ]?5'b01101:5'b00000));
    wire [31:0] CLZ_tmp;
    assign CLZ_tmp =Rs[31]==1? 32'h00000000:Rs[30]==1? 32'h00000001:
    Rs[29]==1? 32'h00000002:Rs[28]==1? 32'h00000003:Rs[27]==1? 32'h00000004:
    Rs[26]==1? 32'h00000005:Rs[25]==1? 32'h00000006:Rs[24]==1? 32'h00000007:
    Rs[23]==1? 32'h00000008:Rs[22]==1? 32'h00000009:
    Rs[21]==1? 32'h0000000a:Rs[20]==1? 32'h0000000b:Rs[19]==1? 
    32'h0000000c:Rs[18]==1? 32'h0000000d:Rs[17]==1? 32'h0000000e:
    Rs[16]==1? 32'h0000000f:Rs[15]==1? 32'h00000010:Rs[14]==1? 32'h00000011:Rs[13]==1? 
    32'h00000012:Rs[12]==1? 32'h00000013:
    Rs[11]==1? 32'h00000014:Rs[10]==1? 32'h00000015:Rs[9]==1? 32'h00000016:Rs[8]==1? 32'h00000017:Rs[7]==1? 32'h00000018:
    Rs[6]==1? 32'h00000019:Rs[5]==1? 32'h0000001a:Rs[4]==1? 32'h0000001b:Rs[3]==1? 32'h0000001c:Rs[2]==1? 32'h0000001d:
    Rs[1]==1? 32'h0000001e:Rs[0]==1? 32'h0000001f:32'h00000020;

    assign UEXT16={16'h0,IM_instr[15:0]};
    assign SEXT16={{16{IM_instr[15]}},IM_instr[15:0]};
    assign EXT16=(order[ADDI]||order[ADDIU]||order[LW]||order[SW]||order[SLTI]||order[SLTIU]
    ||order[LB]
    ||order[LBU]||order[LH]||order[LHU]||order[SB]||order[SH])?SEXT16:UEXT16;
    assign EXT5=(order[SLL]||order[SRL]||order[SRA])?{27'b0,IM_instr[10:6]}:32'hz;
    assign EXT18=(order[BEQ]||order[BNE]||order[BGEZ])?{{14{IM_instr[15]}},IM_instr[15:0],2'b0}:32'hz;
    assign pc_out = PC_out;
    assign NPC=PC_out+4;
    assign CAT=(order[J]||order[JAL])?{PC_out[31:28],IM_instr[25:0],2'b0}:32'hz;
    assign HI_w = order[MTHI]||order[MULTU]||order[MULT]||order[DIV]||order[DIVU];
    assign LO_w = order[MTLO]||order[MULTU]||order[MULT]||order[DIV]||order[DIVU]; 
    assign sign_flag = order[MULT]||order[DIV];
    assign sb_flag = order[SB];
    assign sh_flag = order[SH];
    assign sw_flag = order[SW];
    assign lb_flag = order[LB];
    assign lh_flag = order[LH];
    assign lbu_flag = order[LBU];
    assign lhu_flag = order[LHU];
    assign lw_flag = order[LW];
    assign dm_w=order[SW]||order[SB]||order[SH];
    assign dm_r=order[LW]||order[LB]||order[LBU]||order[LH]||order[LHU];
    assign dm_data_w=dm_w?Rt:32'bz;
    assign dm_ena=order[SW]||order[LW]||order[SB]||order[SH]||order[LB]
    ||order[LBU]||order[LH]||order[LHU];
    assign aluc[3]=order[SLT]||order[SLTU]||order[SLL]||order[SRL]||order[SRA]||order[SLLV]
    ||order[SRLV]||
    order[SRAV]||order[SLTI]||order[SLTIU]||order[LUI];
    assign aluc[2]=order[AND]||order[OR]||order[XOR]||order[NOR]||order[SLL]||order[SRL]
    ||order[SRA]||order[SLLV]||order[SRLV]||order[SRAV]||order[ANDI]||order[ORI]||order[XORI];
    assign aluc[1]=order[SUB]||order[SUBU]||order[XOR]||order[NOR]||order[SLT]||order[SLTU]
    ||order[SLL]||order[SLLV]||order[XORI]||order[BEQ]||order[BNE]||order[SLTI]||order[SLTIU]
    ||order[TEQ]||order[BGEZ];
    assign aluc[0]=order[ADD]||order[SUB]||order[OR]||order[NOR]||order[SLT]||order[SRL]
    ||order[SRLV]||order[ADDI]||
    order[ORI]||order[SLTI]||order[LB]||order[LBU]||order[LH]
    ||order[LHU]||order[SB]||order[SH]||order[BGEZ]||order[JALR]||order[LW]||order[SW];
    assign RF_W=order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]||order[SRL]
    ||order[SRA]
    ||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]||order[ADDIU]
    ||order[ANDI]
    ||order[ORI]||order[XORI]||order[LW]||order[SLTI]||order[SLTIU]||order[LUI]
    ||order[JAL]
    ||order[MFC0]||order[CLZ]||order[LB]||order[LBU]||order[LH]||order[LHU]
    ||order[MFHI]||order[MFLO]||order[JALR];
    assign Rs_ena=order[ADD]||order[ADDU]
    ||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[JR]||order[SLLV]
    ||order[SRLV]
    ||order[SRAV]||order[ADDI]||order[ADDIU]||order[ANDI]||order[ORI]
    ||order[XORI]||order[SW]||order[LW]||order[BEQ]||order[BNE]||order[SLTI]
    ||order[SLTIU]
    ||order[LB]
    ||order[LBU]||order[LH]||order[LHU]||order[SB]
    ||order[SH]
    ||order[BGEZ]||order[DIV]||order[DIVU]||order[MULT]||order[MULTU]
    ||order[MTHI]
    ||order[MTLO]||order[CLZ]||order[JALR]||order[TEQ];
    assign Rsc=Rs_ena?IM_instr[25:21]:5'hz;
    assign Rt_ena=order[ADD]
    ||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]||order[NOR]
    ||order[SLT]||order[SLTU]||order[JR]||order[SLL]||order[SW]
    ||order[SRL]||order[SRA]
    ||order[SLLV]||order[SRLV]||order[SRAV]||order[BEQ]
    ||order[BNE]||order[TEQ]
    ||order[DIV]||order[DIVU]||order[MULT]||order[MULTU]
    ||order[SB]||order[SH]||order[MTC0]||order[MFC0];
    assign Rtc=Rt_ena?IM_instr[20:16]:5'hz;
    assign Rd_ena1=order[ADD]
    ||order[ADDU]||order[SUB]||order[SUBU]||order[AND]||order[OR]
    ||order[XOR]
    ||order[NOR]||order[SLT]||order[SLTU]||order[SLLV]
    ||order[SRL]||order[SRA]||order[SLL]||order[SRLV]||order[SRAV]
    ||order[CLZ]||order[MFHI]||order[MFLO];
    assign Rd_ena2=order[ADDI]||order[ADDIU]||order[ANDI]||order[ORI]
    ||order[XORI]||order[SLTI]||order[SLTIU]||order[LW]||order[LUI]
    ||order[LB]||order[LBU]||order[LH]||order[LHU]||order[MFC0];
    assign Rdc=Rd_ena1?IM_instr[15:11]:(Rd_ena2?IM_instr[20:16]:(order[JAL]||order[JALR]?5'd31:5'hz));
    wire signed [31:0]S_Rs;
    wire signed [31:0]S_Rt;
    assign S_Rs=Rs;
    assign S_Rt=Rt;
    wire signed [31:0]alur_temp;
    assign alur_temp = alu_r;
    assign M1[2] = (order[BEQ]&&zero)||(order[BNE]&&!zero)||order[J]
    ||order[JAL]||order[BREAK]
    ||order[SYSCALL]||(zero&&order[TEQ])
    ||(order[BGEZ]&&(alur_temp>=0));
    assign M1[1] = order[JR]||order[JALR]||order[BREAK]||order[SYSCALL]||(zero&&order[TEQ])||order[ERET];
    assign M1[0] = order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]
    ||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]
    ||order[SRL]
    ||order[SRA]||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]
    ||order[ADDIU]
    ||order[ANDI]||order[ORI]||order[XORI]||order[LW]||order[SW]
    ||(order[BEQ]&&!zero)||(order[BNE]&&zero)||order[SLTI]||order[SLTIU]||order[LUI]
    ||order[JAL]
    ||order[J]||order[CLZ]||order[DIV]||order[DIVU]||order[MULT]
    ||order[MULTU]||order[MTHI]||order[MTLO]||order[MFHI]||order[MFLO]||order[MFC0]
    ||order[MTC0]||order[SB]||order[SH]||order[LB]||order[LBU]||order[LH]
    ||order[LHU]||order[ERET]||(order[TEQ]&&!zero)||(order[BGEZ]&&(alur_temp<0));
    wire [31:0] NPC_18;
    wire [31:0] error_addr;
    assign error_addr = 32'h00400004;
    assign NPC_18 = EXT18 + NPC;
    MUX6_1 MUX1(
        .sel(M1),
        .in1(NPC),
        .in2(Rs),
        .in3(epc_out),
        .in4(NPC_18),
        .in5(CAT),
        .in6(error_addr),
        .out(MUX1_out)
    );
    assign PC_in = MUX1_out;
    assign M3 = order[SLL]||order[SRL]||order[SRA];
    assign alu_a = M3?EXT5:Rs;
    assign M4_ena1 = order[ADDI]||order[ADDIU]||order[ANDI]||order[ORI]||order[XORI]
    ||order[LUI]||order[SLTI]||order[SLTIU]||order[LW]||order[SB]||order[SH]||order[SW]
    ||order[LB]||order[LBU]||order[LH]||order[LHU];
    assign M4_ena2 = order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]
    ||order[OR]||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]
    ||order[SRL]||order[SRA]||order[SLLV]||order[SRLV]||order[SRAV]||order[BEQ]
    ||order[BNE]||order[TEQ];
    assign alu_b = M4_ena1?EXT16:(M4_ena2?Rt:(order[BGEZ])?32'd0:32'hz);
    assign M5[2] = order[ADD]
    ||order[ADDU]||order[SUB]||order[SUBU]||order[AND]
    ||order[OR]||order[XOR]
    ||order[NOR]||order[SLT]||order[SLTU]||order[SLL]
    ||order[SRL]||order[SRA]
    ||order[SLLV]||order[SRLV]||order[SRAV]||order[ADDI]
    ||order[ADDIU]||order[ANDI]
    ||order[ORI]||order[XORI]||order[LW]||order[SLTI]
    ||order[SLTIU]||order[LUI]
    ||order[MFHI]||order[MFLO]||order[LB]||order[LBU]
    ||order[LH]||order[LHU];
    assign M5[1] = order[JAL]||order[JALR]||order[CLZ]||order[MFHI]||order[MFLO];
    assign M5[0] = order[ADD]||order[ADDU]||order[SUB]||order[SUBU]||order[AND]
    ||order[OR]
    ||order[XOR]||order[NOR]||order[SLT]||order[SLTU]||order[SLL]
    ||order[SRL]
    ||order[SRA]||order[SLLV]
    ||order[SRLV]||order[SRAV]||order[ADDI]
    ||order[ADDIU]
    ||order[ANDI]||order[ORI]||order[XORI]||order[SLTI]||order[SLTIU]
    ||order[LUI]||order[CLZ]||order[MFC0];
    assign HI_LO = MUX8_out;
    MUX6_1 MUX5(
        .sel(M5),
        .in1(cp0_out),
        .in2(NPC),
        .in3(CLZ_tmp),
        .in4(dm_data),
        .in5(alu_r),
        .in6(HI_LO),
        .out(MUX5_out)
    );
    assign Rd = MUX5_out;
    assign M6_ena1 = order[MULT]||order[MULTU];
    assign M6_ena2 = order[DIV]||order[DIVU];
    assign MUX6_out = M6_ena1?MUL_H:(M6_ena2?DIV_R:(order[MTHI]?Rs:32'hz));
    assign HI_in = MUX6_out;
    assign M7_ena1 = order[MULT]||order[MULTU];
    assign M7_ena2 = order[DIV]||order[DIVU];
    assign MUX7_out = M7_ena1?MUL_L:(M7_ena2?DIV_Q:(order[MTLO]?Rs:32'hz));
    assign LO_in = MUX7_out;
    assign M8 = order[MFHI];
    assign MUX8_out = M8?HI_out:LO_out;
    ALU alu(
        .A(alu_a),
        .B(alu_b),
        .aluc(aluc),
        .F(alu_r),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
    );
    regfile cpu_ref(
        .RF_ena(1'b1),
        .RF_rst(rst),
        .RF_clk(clk),
        .RF_W(RF_W),
        .Rdc(Rdc),
        .Rsc(Rsc),
        .Rtc(Rtc),
        .Rs(Rs),
        .Rt(Rt),
        .Rd(Rd)
    );
    PC pc(
        .pc_clk(clk),
        .pc_ena(1'b1),
        .rst(rst),
        .pc_addr_in(PC_in),
        .pc_addr_out(PC_out)
    );
    HI_LO hi_lo(
        .HI_LO_clk(clk),
        .HI_LO_ena(1'b1),
        .HI_LO_rst(rst),
        .HI_in(HI_in),
        .LO_in(LO_in),
        .HI_w(HI_w),
        .LO_w(LO_w),
        .HI_out(HI_out),
        .LO_out(LO_out)
    );
    MUL mul(
        .sign_flag(sign_flag),
        .A(Rs),
        .B(Rt),
        .HI(MUL_H),
        .LO(MUL_L)
    );
    DIV div(
        .sign_flag(sign_flag),
        .A(Rs),
        .B(Rt),
        .Q(DIV_Q),
        .R(DIV_R)
    );
    CP0 cp0(
        .cp0_clk(clk),
        .cp0_rst(rst),
        .cp0_ena(1'b1),
        .MFC0(order[MFC0]),
        .MTC0(order[MTC0]),
        .ERET(order[ERET]),
        .PC(NPC),
        .addr(IM_instr[15:11]),
        .cause(cause),
        .data_in(Rt),
        .CP0_out(cp0_out),
        .EPC_out(epc_out)
    );
endmodule
