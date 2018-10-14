`include "mycpu.h"

module IF_ID(
	input         clk,
	input         rst,
	input         IF_stall,
	input         ID_stall,

	input  [31:0] IF_out_PC,
	input  [31:0] IF_out_instruction,

	output [31:0] ID_in_PC,
	output [31:0] ID_in_instruction
);

	reg [31:0] reg_PC;
	reg [31:0] reg_instruction;

	always @(posedge clk) begin
		if (rst) begin
			reg_PC <= 32'hbfc00000;
			reg_instruction <= 32'd0;
		end else if (ID_stall) begin
			reg_PC <= reg_PC;
			reg_instruction <= reg_instruction;
		end else if (IF_stall) begin
			reg_PC <= 32'hbfc00000;
			reg_instruction <= 32'd0;
		end else begin
			reg_PC <= IF_out_PC;
			reg_instruction <= IF_out_instruction;
		end
	end

	assign ID_in_PC = reg_PC;
	assign ID_in_instruction = reg_instruction;

endmodule