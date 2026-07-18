// MIPS Processor Definitions Header File

// Coprocessor 0 Register Addresses
`define CP0_STATUS_REG      12
`define CP0_CAUSE_REG       13
`define CP0_EPC_REG         14

// Exception Cause Codes
`define EXCEPTION_SYSCALL   5'b01000
`define EXCEPTION_BREAK     5'b01001
`define EXCEPTION_TEQ       5'b01101

// Instruction Opcode Definitions
`define OPCODE_ADDI         6'b001000
`define OPCODE_ADDIU        6'b001001
`define OPCODE_ANDI         6'b001100
`define OPCODE_ORI          6'b001101
`define OPCODE_SLTIU        6'b001011
`define OPCODE_LUI          6'b001111
`define OPCODE_XORI         6'b001110
`define OPCODE_SLTI         6'b001010
`define OPCODE_RTYPE        6'b000000
`define OPCODE_BEQ          6'b000100
`define OPCODE_BNE          6'b000101
`define OPCODE_J            6'b000010
`define OPCODE_JAL          6'b000011
`define OPCODE_LW           6'b100011
`define OPCODE_SW           6'b101011
`define OPCODE_COP0         6'b010000
`define OPCODE_SPECIAL2     6'b011100
`define OPCODE_LHU          6'b100101
`define OPCODE_SB           6'b101000
`define OPCODE_SH           6'b101001
`define OPCODE_LH           6'b100001
`define OPCODE_BGEZ         6'b000001
`define OPCODE_LB           6'b100000
`define OPCODE_LBU          6'b100100

// R-Type Function Code Definitions
`define FUNC_ADDU           6'b100001
`define FUNC_AND            6'b100100
`define FUNC_JR             6'b001000
`define FUNC_XOR            6'b100110
`define FUNC_NOR            6'b100111
`define FUNC_OR             6'b100101
`define FUNC_SLL            6'b000000
`define FUNC_SLLV           6'b000100
`define FUNC_SLTU           6'b101011
`define FUNC_SRA            6'b000011
`define FUNC_SRL            6'b000010
`define FUNC_SUBU           6'b100011
`define FUNC_ADD            6'b100000
`define FUNC_SUB            6'b100010
`define FUNC_SLT            6'b101010
`define FUNC_SRLV           6'b000110
`define FUNC_SRAV           6'b000111
`define FUNC_CLZ            6'b100000
`define FUNC_DIVU           6'b011011
`define FUNC_ERET           6'b011000
`define FUNC_JALR           6'b001001
`define FUNC_MFHI           6'b010000
`define FUNC_MFLO           6'b010010
`define FUNC_MTHI           6'b010001
`define FUNC_MTLO           6'b010011
`define FUNC_MUL            6'b000010
`define FUNC_MULTU          6'b011001
`define FUNC_SYSCALL        6'b001100
`define FUNC_TEQ            6'b110100
`define FUNC_BREAK          6'b001101
`define FUNC_DIV            6'b011010

// Special Function Code Aliases for Readability
`define FUNC_ADDU_SPECIAL   `FUNC_ADDU
`define FUNC_AND_SPECIAL    `FUNC_AND
`define FUNC_XOR_SPECIAL    `FUNC_XOR
`define FUNC_NOR_SPECIAL    `FUNC_NOR
`define FUNC_OR_SPECIAL     `FUNC_OR
`define FUNC_ADD_SPECIAL    `FUNC_ADD
`define FUNC_SUB_SPECIAL    `FUNC_SUB
`define FUNC_SLT_SPECIAL    `FUNC_SLT
`define FUNC_SLTU_SPECIAL   `FUNC_SLTU