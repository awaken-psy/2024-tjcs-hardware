`include "mips_definitions.vh"
`timescale 1ns / 1ps

module controller (
    input           branch_signal,
    input [31:0]    status_register,
    input [31:0]    current_instruction,

    output [2:0]    program_counter_select,
    output          immediate_sign_extend,
    output          extend_5bit_select,
    output          rs_read_enable,
    output          rt_read_enable,
    output          alu_a_select,
    output [1:0]    alu_b_select,
    output [3:0]    alu_control,
    output          multiplier_enable,
    output          divider_enable,
    output          clz_enable,
    output          multiplier_signed,
    output          divider_signed,
    output          cutter_sign_extend,
    output          cutter_address_select,
    output [2:0]    cutter_select,
    output          data_memory_enable,
    output          data_memory_write_enable,
    output [1:0]    data_memory_write_select,
    output [1:0]    data_memory_read_select,
    output          exception_return,
    output [4:0]    exception_cause,
    output          exception_signal,
    output [4:0]    cp0_register_address,
    output          move_from_cp0,
    output          move_to_cp0,
    output          hi_write_enable,
    output          lo_write_enable,
    output          rd_write_enable,
    output [1:0]    hi_source_select,
    output [1:0]    lo_source_select,
    output [2:0]    rd_source_select,
    output [4:0]    rd_destination
    );

    wire [5:0] opcode_field = current_instruction[31:26];
    wire [5:0] function_field = current_instruction[5:0];

    wire add_immediate    = (opcode_field == 6'b001000);
    wire add_immediate_u  = (opcode_field == 6'b001001);
    wire and_immediate    = (opcode_field == 6'b001100);
    wire or_immediate     = (opcode_field == 6'b001101);
    wire slt_immediate_u  = (opcode_field == 6'b001011);
    wire load_upper_imm   = (opcode_field == 6'b001111);
    wire xor_immediate    = (opcode_field == 6'b001110);
    wire slt_immediate    = (opcode_field == 6'b001010);
    wire add_unsigned     = (opcode_field == 6'b000000 && function_field == 6'b100001);
    wire and_operation    = (opcode_field == 6'b000000 && function_field == 6'b100100);
    wire branch_equal     = (opcode_field == 6'b000100);
    wire branch_not_equal = (opcode_field == 6'b000101);
    wire jump             = (opcode_field == 6'b000010);
    wire jump_and_link    = (opcode_field == 6'b000011);
    wire jump_register    = (opcode_field == 6'b000000 && function_field == 6'b001000);
    wire load_word        = (opcode_field == 6'b100011);
    wire xor_operation    = (opcode_field == 6'b000000 && function_field == 6'b100110);
    wire nor_operation    = (opcode_field == 6'b000000 && function_field == 6'b100111);
    wire or_operation     = (opcode_field == 6'b000000 && function_field == 6'b100101);
    wire shift_left_logic = (opcode_field == 6'b000000 && function_field == 6'b000000);
    wire shift_left_logic_var = (opcode_field == 6'b000000 && function_field == 6'b000100);
    wire set_less_than_u  = (opcode_field == 6'b000000 && function_field == 6'b101011);
    wire shift_right_arithmetic = (opcode_field == 6'b000000 && function_field == 6'b000011);
    wire shift_right_logic = (opcode_field == 6'b000000 && function_field == 6'b000010);
    wire sub_unsigned     = (opcode_field == 6'b000000 && function_field == 6'b100011);
    wire store_word       = (opcode_field == 6'b101011);
    wire add_signed       = (opcode_field == 6'b000000 && function_field == 6'b100000);
    wire sub_signed       = (opcode_field == 6'b000000 && function_field == 6'b100010);
    wire set_less_than    = (opcode_field == 6'b000000 && function_field == 6'b101010);
    wire shift_right_logic_var = (opcode_field == 6'b000000 && function_field == 6'b000110);
    wire shift_right_arithmetic_var = (opcode_field == 6'b000000 && function_field == 6'b000111);
    wire count_leading_zeros = (opcode_field == 6'b011100 && function_field == 6'b100000);
    wire divide_unsigned  = (opcode_field == 6'b000000 && function_field == 6'b011011);
    wire exception_return_inst = (opcode_field == 6'b010000 && function_field == 6'b011000);
    wire jump_and_link_reg = (opcode_field == 6'b000000 && function_field == 6'b001001);
    wire load_byte_signed = (opcode_field == 6'b100000);
    wire load_byte_unsigned = (opcode_field == 6'b100100);
    wire load_halfword_unsigned = (opcode_field == 6'b100101);
    wire store_byte       = (opcode_field == 6'b101000);
    wire store_halfword   = (opcode_field == 6'b101001);
    wire load_halfword_signed = (opcode_field == 6'b100001);
    wire move_from_cp0_inst = (current_instruction[31:21] == 11'b01000000000 && current_instruction[10:3] == 8'b0);
    wire move_from_hi     = (opcode_field == 6'b000000 && function_field == 6'b010000);
    wire move_from_lo     = (opcode_field == 6'b000000 && function_field == 6'b010010);
    wire move_to_cp0_inst = (current_instruction[31:21] == 11'b01000000100 && current_instruction[10:3] == 8'b0);
    wire move_to_hi      = (opcode_field == 6'b000000 && function_field == 6'b010001);
    wire move_to_lo      = (opcode_field == 6'b000000 && function_field == 6'b010011);
    wire multiply_signed  = (opcode_field == 6'b011100 && function_field == 6'b000010);
    wire multiply_unsigned = (opcode_field == 6'b000000 && function_field == 6'b011001);
    wire syscall_inst    = (opcode_field == 6'b000000 && function_field == 6'b001100);
    wire divide_signed   = (opcode_field == 6'b000000 && function_field == 6'b011010);
    wire trap_equal      = (opcode_field == 6'b000000 && function_field == 6'b110100);
    wire branch_greater_equal_zero = (opcode_field == 6'b000001);
    wire break_inst      = (opcode_field == 6'b000000 && function_field == 6'b001101);

    // Program Counter Selection Logic
    assign program_counter_select[2] = (branch_equal & branch_signal) | 
                                      (branch_not_equal & branch_signal) | 
                                      (branch_greater_equal_zero & branch_signal) | 
                                      exception_return_inst;
    
    assign program_counter_select[1] = ~(jump | jump_register | jump_and_link | jump_and_link_reg | 
                                        (branch_equal & branch_signal) | 
                                        (branch_not_equal & branch_signal) | 
                                        (branch_greater_equal_zero & branch_signal) | 
                                        exception_return_inst);
    
    assign program_counter_select[0] = exception_return_inst | exception_signal | jump_register | jump_and_link_reg;

    // Immediate Extension Selection
    assign extend_5bit_select = shift_left_logic_var | shift_right_arithmetic_var | shift_right_logic_var;
    assign immediate_sign_extend = add_immediate | add_immediate_u | slt_immediate_u | slt_immediate;

    // ALU Control Signals
    assign alu_control[3] = load_upper_imm | shift_right_logic | set_less_than | set_less_than_u | 
                           shift_left_logic_var | shift_right_logic_var | shift_right_arithmetic_var | 
                           shift_right_arithmetic | slt_immediate | slt_immediate_u | shift_left_logic;
    
    assign alu_control[2] = and_operation | or_operation | xor_operation | nor_operation | 
                           shift_left_logic | shift_right_logic | shift_right_arithmetic | 
                           shift_left_logic_var | shift_right_logic_var | shift_right_arithmetic_var | 
                           and_immediate | or_immediate | xor_immediate;
    
    assign alu_control[1] = add_signed | sub_signed | xor_operation | nor_operation | 
                           set_less_than | set_less_than_u | shift_left_logic | shift_left_logic_var | 
                           add_immediate | xor_immediate | branch_equal | branch_not_equal | 
                           slt_immediate | slt_immediate_u | branch_greater_equal_zero | trap_equal;
    
    assign alu_control[0] = sub_unsigned | sub_signed | or_operation | nor_operation | 
                           set_less_than | shift_left_logic_var | shift_right_logic_var | 
                           shift_left_logic | shift_right_logic | slt_immediate | or_immediate | 
                           branch_equal | branch_not_equal | branch_greater_equal_zero | trap_equal;
    
    assign alu_a_select = ~(shift_left_logic | shift_right_logic | shift_right_arithmetic | 
                           divide_signed | divide_unsigned | multiply_signed | multiply_unsigned | 
                           jump | jump_register | jump_and_link | jump_and_link_reg | 
                           move_from_cp0_inst | move_to_cp0_inst | move_from_hi | move_from_lo | 
                           move_to_hi | move_to_lo | count_leading_zeros | exception_return_inst | 
                           syscall_inst | break_inst);
    
    assign alu_b_select[1] = branch_greater_equal_zero;
    assign alu_b_select[0] = add_immediate | add_immediate_u | and_immediate | or_immediate | 
                            xor_immediate | slt_immediate | slt_immediate_u | 
                            load_byte_signed | load_byte_unsigned | load_halfword_signed | 
                            load_halfword_unsigned | load_word | store_byte | store_halfword | 
                            store_word | load_upper_imm;

    // Multiplier/Divider/CLZ Control
    assign multiplier_enable = multiply_signed | multiply_unsigned;
    assign divider_enable = divide_signed | divide_unsigned;
    assign multiplier_signed = multiply_signed;
    assign divider_signed = divide_signed;
    assign clz_enable = count_leading_zeros;

    // Data Memory Control
    assign data_memory_enable = load_word | store_word | load_halfword_signed | 
                                store_halfword | load_byte_signed | store_byte | 
                                load_halfword_unsigned | load_byte_unsigned;
    
    assign data_memory_write_enable = store_word | store_halfword | store_byte;
    assign data_memory_write_select[1] = store_halfword | store_byte;
    assign data_memory_write_select[0] = store_word | store_byte;
    assign data_memory_read_select[1] = load_halfword_signed | load_byte_signed | 
                                        load_halfword_unsigned | load_byte_unsigned;
    assign data_memory_read_select[0] = load_word | load_byte_signed | load_byte_unsigned;
    assign cutter_sign_extend = load_halfword_signed | load_byte_signed;

    // Cutter Control
    assign cutter_address_select = ~(store_byte | store_halfword | store_word);
    assign cutter_select[2] = store_halfword;
    assign cutter_select[1] = load_byte_signed | load_byte_unsigned | store_byte;
    assign cutter_select[0] = load_halfword_signed | load_halfword_unsigned | store_byte;

    // Register File Control
    assign rs_read_enable = add_immediate | add_immediate_u | and_immediate | or_immediate | 
                           slt_immediate_u | xor_immediate | slt_immediate | add_unsigned | 
                           and_operation | branch_equal | branch_not_equal | jump_register | 
                           load_word | xor_operation | nor_operation | or_operation | 
                           shift_left_logic_var | set_less_than_u | sub_unsigned | store_word | 
                           add_signed | sub_signed | set_less_than | shift_right_logic_var | 
                           shift_right_arithmetic_var | count_leading_zeros | divide_unsigned | 
                           jump_and_link_reg | load_byte_signed | load_byte_unsigned | 
                           load_halfword_unsigned | store_byte | store_halfword | 
                           load_halfword_signed | multiply_signed | multiply_unsigned | 
                           trap_equal | divide_signed;
    
    assign rt_read_enable = add_unsigned | and_operation | branch_equal | branch_not_equal | 
                           xor_operation | nor_operation | or_operation | shift_left_logic | 
                           shift_left_logic_var | set_less_than_u | shift_right_arithmetic | 
                           shift_right_logic | sub_unsigned | store_word | add_signed | 
                           sub_signed | set_less_than | shift_right_logic_var | 
                           shift_right_arithmetic_var | divide_unsigned | store_byte | 
                           store_halfword | move_to_cp0_inst | multiply_signed | 
                           multiply_unsigned | trap_equal | divide_signed;
    
    assign rd_write_enable = add_immediate | add_immediate_u | and_immediate | or_immediate | 
                            slt_immediate_u | load_upper_imm | xor_immediate | slt_immediate | 
                            add_unsigned | and_operation | xor_operation | nor_operation | 
                            or_operation | shift_left_logic | shift_left_logic_var | 
                            set_less_than_u | shift_right_arithmetic | shift_right_logic | 
                            sub_unsigned | add_signed | sub_signed | set_less_than | 
                            shift_right_logic_var | shift_right_arithmetic_var | 
                            load_byte_signed | load_byte_unsigned | load_halfword_signed | 
                            load_halfword_unsigned | load_word | move_from_cp0_inst | 
                            count_leading_zeros | jump_and_link | jump_and_link_reg | 
                            move_from_hi | move_from_lo | multiply_signed;
    
    assign rd_destination = (add_signed | add_unsigned | sub_signed | sub_unsigned | 
                            and_operation | or_operation | xor_operation | nor_operation | 
                            set_less_than | set_less_than_u | shift_left_logic | shift_right_logic | 
                            shift_right_arithmetic | shift_left_logic_var | shift_right_logic_var | 
                            shift_right_arithmetic_var | count_leading_zeros | jump_and_link_reg | 
                            move_from_hi | move_from_lo | multiply_signed) ? 
                            current_instruction[15:11] : 
                            ((add_immediate | add_immediate_u | and_immediate | or_immediate | 
                            xor_immediate | load_byte_signed | load_byte_unsigned | 
                            load_halfword_signed | load_halfword_unsigned | load_word | 
                            slt_immediate | slt_immediate_u | load_upper_imm | move_from_cp0_inst) ? 
                            current_instruction[20:16] : 
                            (jump_and_link ? 5'd31 : 5'b0));
    
    assign rd_source_select[2] = ~(branch_equal | branch_not_equal | branch_greater_equal_zero | 
                                  divide_signed | divide_unsigned | store_byte | multiply_unsigned | 
                                  store_halfword | store_word | jump | jump_register | jump_and_link | 
                                  jump_and_link_reg | move_from_cp0_inst | move_to_cp0_inst | 
                                  move_from_lo | move_to_hi | move_to_lo | count_leading_zeros | 
                                  exception_return_inst | syscall_inst | trap_equal | break_inst);
    
    assign rd_source_select[1] = multiply_signed | move_from_cp0_inst | move_to_cp0_inst | 
                                count_leading_zeros | move_from_hi;
    
    assign rd_source_select[0] = ~(branch_equal | branch_not_equal | branch_greater_equal_zero | 
                                  divide_signed | divide_unsigned | multiply_unsigned | 
                                  load_byte_signed | load_byte_unsigned | load_halfword_signed | 
                                  load_halfword_unsigned | load_word | store_byte | store_halfword | 
                                  store_word | jump | move_to_cp0_inst | move_from_hi | move_from_lo | 
                                  move_to_hi | move_to_lo | count_leading_zeros | exception_return_inst | 
                                  syscall_inst | trap_equal | break_inst);

    // HI/LO Register Control
    assign hi_write_enable = multiply_signed | multiply_unsigned | divide_signed | 
                            divide_unsigned | move_to_hi;
    assign hi_source_select[1] = move_to_hi;
    assign hi_source_select[0] = multiply_signed | multiply_unsigned;
    assign lo_write_enable = multiply_signed | multiply_unsigned | divide_signed | 
                            divide_unsigned | move_to_lo;
    assign lo_source_select[1] = move_to_lo;
    assign lo_source_select[0] = multiply_signed | multiply_unsigned;
    
    // CP0 Control
    assign move_from_cp0 = move_from_cp0_inst;
    assign move_to_cp0 = move_to_cp0_inst;
    assign cp0_register_address = current_instruction[15:11];
    
    // Exception Control
    assign exception_cause = break_inst ? `CAUSE_BREAK : 
                            (syscall_inst ? `CAUSE_SYSCALL : 
                            (trap_equal ? `CAUSE_TEQ : 5'bz));
    
    assign exception_return = exception_return_inst;
    assign exception_signal = status_register[0] && 
                            ((syscall_inst && status_register[1]) || 
                             (break_inst && status_register[2]) || 
                             (trap_equal && status_register[3]));

endmodule