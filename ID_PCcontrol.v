`include "mycpu.h"

module ID_PCcontrol(
	input  [31:0] oriPC,
	input  [31:0] curPC,
	input  [25:0] target,
	input  [15:0] offset,

	input  [31:0] rs_data,
	input  [31:0] rt_data,

	input  [4 :0] PCsrc,

	output [31:0] nextPC
);

	wire [31:0] PC_next_plus   = curPC + 3'd4;
	wire [31:0] PC_next_target = {oriPC[31:28], target, 2'd0};
	wire [31:0] PC_next_offset = oriPC + {{14{offset[15]}}, offset, 2'd0} + 32'd4;
	wire [31:0] PC_next_reg    = rs_data;

	wire beq_cond = rs_data == rt_data;
	wire bne_cond = ~beq_cond;

	assign nextPC = ({32{PCsrc[`PC_from_PCplus]}}          & PC_next_plus)   |
				    ({32{PCsrc[`PC_from_target]}}          & PC_next_target) |
				    ({32{PCsrc[`PC_from_reg]}}             & PC_next_reg)    |
				    ({32{PCsrc[`PC_from_beq] &  beq_cond}} & PC_next_offset) |
				    ({32{PCsrc[`PC_from_beq] & ~beq_cond}} & PC_next_plus )  |
				    ({32{PCsrc[`PC_from_bne] &  bne_cond}} & PC_next_offset) |
				    ({32{PCsrc[`PC_from_bne] & ~bne_cond}} & PC_next_plus);

endmodule