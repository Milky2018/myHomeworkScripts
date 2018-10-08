module ID_IRbuffer(
	input clk,
	input rst,
	input ID_stall,
	input [31:0] inst_sram_rdata,
	
	output [31:0] ID_instruction
);

	reg [31:0] IR_buffer;
	reg ID_stall_reg;

	always @(posedge clk) begin
		if (rst) begin
			IR_buffer <= 32'd0;
			ID_stall_reg <= 1'b0;
		end else begin
			IR_buffer <= ID_instruction;
			ID_stall_reg <= ID_stall;
		end
	end

	assign ID_instruction = ID_stall_reg? IR_buffer : inst_sram_rdata;

endmodule