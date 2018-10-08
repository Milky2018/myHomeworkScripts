`timescale 10 ns / 1 ns

`include "mycpu.h"

module ID_Control(
	input  [31:0] instruction,

	output [3 :0] ALUsrc,
	output [11:0] ALUop,
	output [7 :0] MDop,
	output [4 :0] PCsrc,
	output [2 :0] RFdst,
	output [3 :0] RFsrc,
	output        data_en,
	output [3 :0] data_wen
);
	wire [5:0] op   = instruction[31:26];
	wire [4:0] rs   = instruction[25:21];
	wire [4:0] rt   = instruction[20:16];
	wire [4:0] rd   = instruction[15:11];
	wire [4:0] sa   = instruction[10:6];
	wire [5:0] func = instruction[5:0];

	wire inst_sll   = (op == `INST_R_TYPE) && (func == `R_FUNC_SLL)  && (rs == 5'b00000);
	wire inst_srl   = (op == `INST_R_TYPE) && (func == `R_FUNC_SRL)  && (rs == 5'b00000);
	wire inst_sra   = (op == `INST_R_TYPE) && (func == `R_FUNC_SRA)  && (rs == 5'b00000);
	wire inst_jr    = (op == `INST_R_TYPE) && (func == `R_FUNC_JR)   && (rt == 5'b00000) && (rd == 5'b00000);
	wire inst_addu  = (op == `INST_R_TYPE) && (func == `R_FUNC_ADDU) && (sa == 5'b00000);
	wire inst_subu  = (op == `INST_R_TYPE) && (func == `R_FUNC_SUBU) && (sa == 5'b00000);
	wire inst_and   = (op == `INST_R_TYPE) && (func == `R_FUNC_AND)  && (sa == 5'b00000);
	wire inst_or    = (op == `INST_R_TYPE) && (func == `R_FUNC_OR)   && (sa == 5'b00000);
	wire inst_xor   = (op == `INST_R_TYPE) && (func == `R_FUNC_XOR)  && (sa == 5'b00000);
	wire inst_nor   = (op == `INST_R_TYPE) && (func == `R_FUNC_NOR)  && (sa == 5'b00000);
	wire inst_slt   = (op == `INST_R_TYPE) && (func == `R_FUNC_SLT)  && (sa == 5'b00000);
	wire inst_sltu  = (op == `INST_R_TYPE) && (func == `R_FUNC_SLTU) && (sa == 5'b00000);
	wire inst_add   = (op == `INST_R_TYPE) && (func == `R_FUNC_ADD)  && (sa == 5'b00000);
	wire inst_sub   = (op == `INST_R_TYPE) && (func == `R_FUNC_SUB)  && (sa == 5'b00000);
	wire inst_sllv  = (op == `INST_R_TYPE) && (func == `R_FUNC_SLLV) && (sa == 5'b00000);
	wire inst_srav  = (op == `INST_R_TYPE) && (func == `R_FUNC_SRAV) && (sa == 5'b00000);
	wire inst_srlv  = (op == `INST_R_TYPE) && (func == `R_FUNC_SRLV) && (sa == 5'b00000);
	wire inst_div   = (op == `INST_R_TYPE) && (func == `R_FUNC_DIV)  && (rd == 5'b00000) && (sa == 5'b00000);
	wire inst_divu  = (op == `INST_R_TYPE) && (func == `R_FUNC_DIVU) && (rd == 5'b00000) && (sa == 5'b00000);
	wire inst_mult  = (op == `INST_R_TYPE) && (func == `R_FUNC_MULT) && (rd == 5'b00000) && (sa == 5'b00000);
	wire inst_multu = (op == `INST_R_TYPE) && (func == `R_FUNC_MULTU)&& (rd == 5'b00000) && (sa == 5'b00000);
	wire inst_mfhi  = (op == `INST_R_TYPE) && (func == `R_FUNC_MFHI) && (rs == 5'b00000) && (rt == 5'b00000) && (sa == 5'b00000);
	wire inst_mflo  = (op == `INST_R_TYPE) && (func == `R_FUNC_MFLO) && (rs == 5'b00000) && (rt == 5'b00000) && (sa == 5'b00000);
	wire inst_mthi  = (op == `INST_R_TYPE) && (func == `R_FUNC_MTHI) && (rt == 5'b00000) && (rd == 5'b00000) && (sa == 5'b00000);
	wire inst_mtlo  = (op == `INST_R_TYPE) && (func == `R_FUNC_MTLO) && (rt == 5'b00000) && (rd == 5'b00000) && (sa == 5'b00000);
	wire inst_jal   = op == `INST_JAL;
	wire inst_beq   = op == `INST_BEQ;
	wire inst_bne   = op == `INST_BNE;
	wire inst_addiu = op == `INST_ADDIU;
	wire inst_lui   = op == `INST_LUI && (rs == 5'b00000);
	wire inst_lw    = op == `INST_LW;
	wire inst_sw    = op == `INST_SW;
	wire inst_addi  = op == `INST_ADDI;
	wire inst_slti  = op == `INST_SLTI;
	wire inst_sltiu = op == `INST_SLTIU;
	wire inst_andi  = op == `INST_ANDI;
	wire inst_ori   = op == `INST_ORI;
	wire inst_xori  = op == `INST_XORI;

	// To ALUcontrol
	wire ALU_nop = inst_jr   | inst_jal | inst_beq | inst_bne | inst_div | inst_divu | inst_mult | inst_multu |
				   inst_mfhi | inst_mflo| inst_mthi| inst_mtlo;

	assign ALUsrc[`ALU_from_rs_rt]        = inst_sltu | inst_addu |
							     			inst_subu | inst_and  |
							     			inst_or   | inst_xor  |
							     			inst_nor  | inst_slt  |
							     			inst_add  | inst_sub  |
							     			inst_sllv | inst_srav |
							     			inst_srlv;
	assign ALUsrc[`ALU_from_rs_imm]       = inst_lui  | inst_andi |
											inst_ori  | inst_xori;
	assign ALUsrc[`ALU_from_sa_rt] 	      = inst_sll  | inst_srl  |
						         			inst_sra;
	assign ALUsrc[`ALU_from_rs_signedimm] = inst_addiu| inst_lw   |
	                             			inst_sw   | inst_addi |
	                             			inst_slti | inst_sltiu;        

	assign ALUop[`ALUOP_ADD ] = inst_addiu| inst_addu | inst_lw | inst_sw | inst_add | inst_addi;
	assign ALUop[`ALUOP_SUB ] = inst_subu | inst_sub;
	assign ALUop[`ALUOP_AND ] = inst_and  | inst_andi;
	assign ALUop[`ALUOP_OR  ] = inst_or   | inst_ori;
	assign ALUop[`ALUOP_XOR ] = inst_xor  | inst_xori;
	assign ALUop[`ALUOP_NOR ] = inst_nor;
	assign ALUop[`ALUOP_SLL ] = inst_sll  | inst_sllv;
	assign ALUop[`ALUOP_SLT ] = inst_slt  | inst_slti;
	assign ALUop[`ALUOP_SLTU] = inst_sltu | inst_sltiu;
	assign ALUop[`ALUOP_SRL ] = inst_srl  | inst_srlv;
	assign ALUop[`ALUOP_SRA ] = inst_sra  | inst_srav;
	assign ALUop[`ALUOP_LUI ] = inst_lui;

	// To MulDiv
	assign MDop = {inst_div, inst_divu, inst_mult, inst_multu, inst_mfhi, inst_mflo, inst_mthi, inst_mtlo};

	// To PCcontrol
	assign PCsrc[`PC_from_PCplus] = inst_sll | inst_srl | inst_sra | inst_addu | inst_subu | inst_and | inst_or  |
							        inst_xor | inst_nor | inst_slt | inst_sltu | inst_addiu| inst_lui | inst_sw  |
							        inst_lw  | inst_add | inst_addi| inst_sub  | inst_slti |inst_sltiu| inst_andi|
							        inst_ori | inst_xori| inst_sllv| inst_srav | inst_srlv | inst_div | inst_divu|
							        inst_mult|inst_multu| inst_mfhi| inst_mflo | inst_mthi | inst_mtlo;
	assign PCsrc[`PC_from_target] = inst_jal;
	assign PCsrc[`PC_from_reg]    = inst_jr;
	assign PCsrc[`PC_from_beq]    = inst_beq;
	assign PCsrc[`PC_from_bne]    = inst_bne;

	// To RFcontrol
	wire RF_nop = inst_sw | inst_jr | inst_div | inst_divu | inst_mult | inst_multu | inst_mthi | inst_mtlo;

	assign RFdst[`RF_in_rd] = inst_sll | inst_srl | inst_sra | inst_addu | inst_subu | inst_and | inst_or  |
						      inst_xor | inst_nor | inst_slt | inst_sltu | inst_add  | inst_sub | inst_sllv|
						      inst_srav| inst_srlv| inst_mfhi| inst_mflo;
	assign RFdst[`RF_in_rt] = inst_lw  | inst_lui |inst_addiu| inst_addi | inst_slti |inst_sltiu| inst_andi|
						      inst_ori | inst_xori;
	assign RFdst[`RF_in_ra] = inst_jal;

	assign RFsrc[`RF_from_mem]     = inst_lw;
	assign RFsrc[`RF_from_alu]     = inst_sll | inst_srl | inst_sra | inst_addu | inst_subu | inst_and | inst_or  |
						             inst_xor | inst_nor | inst_slt | inst_sltu | inst_addiu| inst_lui | inst_add |
						             inst_addi| inst_sub | inst_slti| inst_sltiu| inst_andi | inst_ori | inst_xori|
						             inst_sllv| inst_srav| inst_srlv;
	assign RFsrc[`RF_from_PCplus8] = inst_jal;
	assign RFsrc[`RF_from_MD]      = inst_mfhi| inst_mflo;

	// To MEMcontrol
	assign data_en = inst_sw | inst_lw;
	assign data_wen = ({4{inst_sw}} & 4'b1111);

endmodule