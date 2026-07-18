// 算术逻辑单元设计
`timescale 1ns / 1ps

module ArithmeticLogicUnit(
    input   [31:0]  operand1,      // 第一个操作数
    input   [31:0]  operand2,      // 第二个操作数  
    output  [31:0]  result,        // 运算结果
    input   [3:0]   control_code,  // 控制信号编码
    output          is_zero,       // 结果为零标志
    output          has_carry,     // 进位输出标志
    output          is_negative,   // 结果为负标志
    output          has_overflow   // 溢出检测标志
    );
    
    // 定义有符号运算变量
    wire signed [31:0] signed_op1, signed_op2;
    reg [32:0] temp_result;
    
    // 类型转换赋值
    assign signed_op1 = operand1;
    assign signed_op2 = operand2;
    
    // 操作码宏定义
    localparam OP_ADD   = 4'h0;   // 有符号加法
    localparam OP_ADDU  = 4'h1;   // 无符号加法  
    localparam OP_SUB   = 4'h2;   // 有符号减法
    localparam OP_SUBU  = 4'h3;   // 无符号减法
    localparam OP_AND   = 4'h4;   // 逻辑与运算
    localparam OP_OR    = 4'h5;   // 逻辑或运算
    localparam OP_XOR   = 4'h6;   // 逻辑异或运算
    localparam OP_NOR   = 4'h7;   // 逻辑或非运算
    localparam OP_SLT   = 4'h8;   // 有符号比较
    localparam OP_SLTU  = 4'h9;   // 无符号比较
    localparam OP_SLL   = 4'ha;   // 逻辑左移
    localparam OP_SRL   = 4'hb;   // 逻辑右移
    localparam OP_SRA   = 4'hc;   // 算术右移
    localparam OP_LUI   = 4'hd;   // 立即数加载
    
    // 组合逻辑处理单元
    always @ (*)
    begin
        case(control_code)
            OP_ADD:  // 有符号数相加
                temp_result = signed_op1 + signed_op2;
            OP_ADDU: // 无符号数相加
                temp_result = operand1 + operand2;
            OP_SUB:  // 有符号数相减
                temp_result = signed_op1 - signed_op2;
            OP_SUBU: // 无符号数相减
                temp_result = operand1 - operand2;
            OP_AND:  // 按位与操作
                temp_result = operand1 & operand2;
            OP_OR:   // 按位或操作
                temp_result = operand1 | operand2;
            OP_XOR:  // 按位异或操作
                temp_result = operand1 ^ operand2;
            OP_NOR:  // 按位或非操作
                temp_result = ~(operand1 | operand2);
            OP_SLT:  // 有符号数小于比较
                temp_result = (signed_op1 < signed_op2) ? 1 : 0;
            OP_SLTU: // 无符号数小于比较
                temp_result = (operand1 < operand2) ? 1 : 0;
            OP_SLL:  // 逻辑左移操作
                temp_result = (operand2 << operand1);
            OP_SRL:  // 逻辑右移处理
            begin
                if(operand1 == 0) 
                    { temp_result[31:0], temp_result[32] } = { operand2, 1'b0 };
                else
                    { temp_result[31:0], temp_result[32] } = operand2 >> (operand1 - 1);
            end
            OP_SRA:  // 算术右移处理
            begin
                if(operand1 == 0) 
                    { temp_result[31:0], temp_result[32] } = { signed_op2, 1'b0 };
                else
                    { temp_result[31:0], temp_result[32] } = signed_op2 >>> (operand1 - 1);
            end
            OP_LUI:  // 立即数加载高位
                temp_result = { operand2[15:0], 16'h0000 };
            default: // 默认情况处理
                temp_result = 33'b0;
        endcase
    end
    
    // 输出结果分配
    assign result = temp_result[31:0];
    // 状态标志生成
    assign is_zero = (temp_result[31:0] == 0) ? 1 : 0;
    assign has_carry = temp_result[32];
    assign is_negative = temp_result[31];
    assign has_overflow = temp_result[32] ^ temp_result[31];
    
endmodule