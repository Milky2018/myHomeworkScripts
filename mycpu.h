`define INST_R_TYPE  6'b000000

`define INST_JAL     6'b000011
`define INST_BEQ     6'b000100
`define INST_BNE     6'b000101

`define INST_ADDI    6'b001000
`define INST_ADDIU   6'b001001
`define INST_SLTI    6'b001010
`define INST_SLTIU   6'b001011
`define INST_ANDI    6'b001100
`define INST_ORI     6'b001101
`define INST_XORI    6'b001110
`define INST_LUI     6'b001111

`define INST_LW      6'b100011

`define INST_SW      6'b101011

`define R_FUNC_SLL   6'b000000

`define R_FUNC_SRL   6'b000010
`define R_FUNC_SRA   6'b000011
`define R_FUNC_SLLV  6'b000100

`define R_FUNC_SRLV  6'b000110
`define R_FUNC_SRAV  6'b000111
`define R_FUNC_JR    6'b001000

`define R_FUNC_MFHI  6'b010000
`define R_FUNC_MTHI  6'b010001
`define R_FUNC_MFLO  6'b010010
`define R_FUNC_MTLO  6'b010011

`define R_FUNC_MULT  6'b011000
`define R_FUNC_MULTU 6'b011001
`define R_FUNC_DIV   6'b011010
`define R_FUNC_DIVU  6'b011011

`define R_FUNC_ADD   6'b100000
`define R_FUNC_ADDU  6'b100001
`define R_FUNC_SUB   6'b100010
`define R_FUNC_SUBU  6'b100011
`define R_FUNC_AND   6'b100100
`define R_FUNC_OR    6'b100101
`define R_FUNC_XOR   6'b100110
`define R_FUNC_NOR   6'b100111

`define R_FUNC_SLT  6'b101010
`define R_FUNC_SLTU 6'b101011

`define ALUOP_ADD   4'd0
`define ALUOP_SUB   4'd1
`define ALUOP_AND   4'd2
`define ALUOP_OR    4'd3
`define ALUOP_XOR   4'd4
`define ALUOP_NOR   4'd5
`define ALUOP_SLL   4'd6
`define ALUOP_SLT   4'd7
`define ALUOP_SLTU  4'd8
`define ALUOP_SRL   4'd9
`define ALUOP_SRA   4'd10
`define ALUOP_LUI   4'd11

`define PC_from_PCplus 3'd0
`define PC_from_target 3'd1
`define PC_from_reg    3'd2
`define PC_from_beq    3'd3
`define PC_from_bne    3'd4

`define RF_in_rd 2'd0
`define RF_in_rt 2'd1
`define RF_in_ra 2'd2

`define RF_from_mem     2'd0
`define RF_from_alu     2'd1
`define RF_from_PCplus8 2'd2
`define RF_from_MD      2'd3

`define ALU_from_rs_rt        2'd0
`define ALU_from_rs_imm       2'd1
`define ALU_from_sa_rt        2'd2
`define ALU_from_rs_signedimm 2'd3