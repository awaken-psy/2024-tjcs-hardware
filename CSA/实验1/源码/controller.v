// 指令译码与控制信号生成单元
`timescale 1ns / 1ps

module instruction_decoder(
    input           branch_condition,
    input [31:0]    current_instruction,
    
    output          read_enable_rs,
    output          read_enable_rt,
    output          write_enable_rd,
    output [4:0]    destination_addr,
    output          destination_select,

    output          data_mem_enable,
    output          data_mem_write,
    output [1:0]    data_mem_access_type,

    output          sign_extension_flag, 
    output          alu_input_a_select,
    output          alu_input_b_select,
    output [3:0]    alu_operation_code,
    output [1:0]    program_counter_select
    );

    // 指令字段解析
    wire [5:0] opcode_field    = current_instruction[31:26];
    wire [5:0] function_field  = current_instruction[5:0];
    wire [4:0] rs_address      = current_instruction[25:21];
    wire [4:0] rt_address      = current_instruction[20:16];
    wire [4:0] rd_address      = current_instruction[15:11];

    // R型指令识别
    wire is_add    = (opcode_field == 6'b000000 && function_field == 6'b100000);
    wire is_addu   = (opcode_field == 6'b000000 && function_field == 6'b100001);
    wire is_sub    = (opcode_field == 6'b000000 && function_field == 6'b100010);
    wire is_subu   = (opcode_field == 6'b000000 && function_field == 6'b100011);
    wire is_and    = (opcode_field == 6'b000000 && function_field == 6'b100100);
    wire is_or     = (opcode_field == 6'b000000 && function_field == 6'b100101);
    wire is_xor    = (opcode_field == 6'b000000 && function_field == 6'b100110);
    wire is_nor    = (opcode_field == 6'b000000 && function_field == 6'b100111);
    wire is_slt    = (opcode_field == 6'b000000 && function_field == 6'b101010);
    wire is_sltu   = (opcode_field == 6'b000000 && function_field == 6'b101011);
    wire is_sll    = (opcode_field == 6'b000000 && function_field == 6'b000000);
    wire is_srl    = (opcode_field == 6'b000000 && function_field == 6'b000010);
    wire is_sra    = (opcode_field == 6'b000000 && function_field == 6'b000011);
    wire is_sllv   = (opcode_field == 6'b000000 && function_field == 6'b000100);
    wire is_srlv   = (opcode_field == 6'b000000 && function_field == 6'b000110);
    wire is_srav   = (opcode_field == 6'b000000 && function_field == 6'b000111);
    wire is_jr     = (opcode_field == 6'b000000 && function_field == 6'b001000);
    wire is_rtype  = (opcode_field == 6'b000000);
        
    // I型指令识别
    wire is_addi   = (opcode_field == 6'b001000);
    wire is_addiu  = (opcode_field == 6'b001001);
    wire is_andi   = (opcode_field == 6'b001100);
    wire is_ori    = (opcode_field == 6'b001101);
    wire is_xori   = (opcode_field == 6'b001110);
    wire is_lw     = (opcode_field == 6'b100011);
    wire is_sw     = (opcode_field == 6'b101011);
    wire is_beq    = (opcode_field == 6'b000100);
    wire is_bne    = (opcode_field == 6'b000101);
    wire is_slti   = (opcode_field == 6'b001010);
    wire is_sltiu  = (opcode_field == 6'b001011);
    wire is_lui    = (opcode_field == 6'b001111);
    wire is_itype  = is_addi | is_addiu | is_andi | is_ori | is_xori | 
                     is_lw | is_sw | is_beq | is_bne | is_slti | is_sltiu | is_lui;
    
    // J型指令识别
    wire is_j      = (opcode_field == 6'b000010);
    wire is_jal    = (opcode_field == 6'b000011);
    wire is_jtype  = is_j | is_jal;

    // 寄存器读控制信号
    assign read_enable_rs = is_add | is_addu | is_sub | is_subu | is_and | is_or | 
                           is_xor | is_nor | is_slt | is_sltu | is_sllv | is_srlv | 
                           is_jr | is_addi | is_addiu | is_andi | is_ori | is_xori | 
                           is_lw | is_sw | is_beq | is_bne | is_slti | is_sltiu;
    
    assign read_enable_rt = is_add | is_addu | is_sub | is_subu | is_and | is_or | 
                           is_xor | is_nor | is_slt | is_sltu | is_sll | is_srl | 
                           is_sra | is_sllv | is_srlv | is_srav | is_beq | is_bne | is_sw;

    // 寄存器写控制信号
    assign write_enable_rd = is_add | is_addu | is_sub | is_subu | is_and | is_or | 
                            is_xor | is_nor | is_slt | is_sltu | is_sll | is_srl | 
                            is_sra | is_sllv | is_srlv | is_srav | is_addi | is_addiu | 
                            is_andi | is_ori | is_xori | is_lw | is_slti | is_sltiu | 
                            is_lui | is_jal;

    assign destination_select = ~is_lw;

    // 数据存储器控制信号
    assign data_mem_enable = is_sw | is_lw;
    assign data_mem_write = is_sw;
    assign data_mem_access_type = 2'b00;

    // 立即数符号扩展控制
    assign sign_extension_flag = is_addi | is_addiu | is_lw | is_sw | is_slti | is_sltiu;

    // ALU输入选择控制
    assign alu_input_a_select = is_sll | is_srl | is_sra;
    assign alu_input_b_select = is_addi | is_addiu | is_andi | is_ori | 
                               is_xori | is_lw | is_sw | is_slti | is_sltiu | is_lui;

    // 程序计数器选择控制
    assign program_counter_select[1] = is_j;
    assign program_counter_select[0] = (is_beq | is_bne) & branch_condition;

    // ALU操作码生成
    assign alu_operation_code[3] = is_slt | is_sltu | is_sll | is_srl | is_sra | 
                                  is_sllv | is_srlv | is_srav | is_slti | is_sltiu | is_lui;
    assign alu_operation_code[2] = is_and | is_or | is_xor | is_nor | is_sra | 
                                  is_srav | is_andi | is_ori | is_xori | is_lui;
    assign alu_operation_code[1] = is_sub | is_subu | is_xor | is_nor | is_sll | 
                                  is_srl | is_sllv | is_srlv | is_xori | is_beq | is_bne;
    assign alu_operation_code[0] = is_addu | is_subu | is_or | is_nor | is_sltu | 
                                  is_srl | is_srlv | is_addiu | is_ori | is_sltiu | is_lui;

    // 目标地址多路选择器
    mux_4to1_5bit destination_address_mux(
        .input0(5'b11111),
        .input1(rt_address),
        .input2(rd_address),
        .input3(5'b11111),
        .select_signal({is_rtype, is_itype}),
        .output_result(destination_addr)
    );

endmodule