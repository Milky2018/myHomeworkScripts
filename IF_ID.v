`include "mycpu.h"

module IF_ID(
	input             clk,
	input             rst,
	input             IF_stall,
	input             ID_stall,

	input      [31:0] IF_out_PC,

	output     [31:0] ID_in_PC
);

	reg [31:0] reg_PC;

	always @(posedge clk) begin
		if (rst) begin
			reg_PC <= 32'hbfc00000;
		end else if (ID_stall) begin
			reg_PC <= reg_PC;
		end else if (IF_stall) begin
			reg_PC <= 32'hbfc00000;
		end else begin
			reg_PC <= IF_out_PC;
		end
	end

	assign ID_in_PC = reg_PC;

endmodule