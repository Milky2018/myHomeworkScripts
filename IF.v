`include "mycpu.h"

module IF(
	input             clk,
	input             rst,
	input             IF_stall,

	input      [31:0] next_PC,

	output     [31:0] IF_in_PC
);
	reg [31:0] reg_PC;
	always @(posedge clk) begin
		if (rst) begin
			reg_PC <= 32'hbfc00000;
		end else if (IF_stall) begin
			reg_PC <= reg_PC;
		end else begin
			reg_PC <= next_PC;
		end
	end
	assign IF_in_PC = reg_PC;

endmodule