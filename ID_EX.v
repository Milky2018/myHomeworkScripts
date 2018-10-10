`include "mycpu.h"

module ID_EX(
	input         clk,
	input         rst,
	input         ID_stall,
	input         EX_stall,

	input  [31:0] ID_out_PC,
	input  [31:0] ID_out_instruction,
	input  [2 :0] ID_out_RFdst,
	input  [3 :0] ID_out_RFsrc,
	input  [3 :0] ID_out_ALUsrc,
	input  [11:0] ID_out_ALUop,
	input  [7 :0] ID_out_MDop,
	input         ID_out_data_sram_en,
	input  [3 :0] ID_out_data_sram_wen,
	input  [31:0] ID_out_RF_rs_data,
	input  [31:0] ID_out_RF_rt_data,

	output [31:0] EX_in_PC,
	output [31:0] EX_in_instruction,
	output [2 :0] EX_in_RFdst,
	output [3 :0] EX_in_RFsrc,
	output [3 :0] EX_in_ALUsrc,
	output [11:0] EX_in_ALUop,
	output [7 :0] EX_in_MDop,
	output        EX_in_data_sram_en,
	output [3 :0] EX_in_data_sram_wen,
	output [31:0] EX_in_RF_rs_data,
	output [31:0] EX_in_RF_rt_data
);

	reg [31:0] reg_PC;
	reg [31:0] reg_instruction;
	reg [2 :0] reg_RFdst;
	reg [3 :0] reg_RFsrc;
	reg [3 :0] reg_ALUsrc;
	reg [11:0] reg_ALUop;
	reg [7 :0] reg_MDop;
	reg        reg_data_sram_en;
	reg [3 :0] reg_data_sram_wen;
	reg [31:0] reg_RF_rs_data;
	reg [31:0] reg_RF_rt_data;

	assign EX_in_PC            = reg_PC;
	assign EX_in_instruction   = reg_instruction;
	assign EX_in_RFdst         = reg_RFdst;
	assign EX_in_RFsrc         = reg_RFsrc;
	assign EX_in_ALUsrc        = reg_ALUsrc;
	assign EX_in_ALUop         = reg_ALUop;
	assign EX_in_MDop          = reg_MDop;
	assign EX_in_data_sram_en  = reg_data_sram_en;
	assign EX_in_data_sram_wen = reg_data_sram_wen;
	assign EX_in_RF_rs_data    = reg_RF_rs_data;
	assign EX_in_RF_rt_data    = reg_RF_rt_data;

	always @(posedge clk) begin
		if (rst) begin
			reg_PC            <= 32'hbfc00000;
			reg_instruction   <= 32'd0;
			reg_RFdst         <= 3'b000;
			reg_RFsrc         <= 4'b0000;
			reg_ALUsrc        <= 4'b0000;
			reg_ALUop         <= 12'd0;
			reg_MDop          <= 8'd0;
			reg_data_sram_en  <= 1'b0;
			reg_data_sram_wen <= 4'b0000;
			reg_RF_rs_data    <= 32'd0;
			reg_RF_rt_data    <= 32'd0;
		end else if (EX_stall) begin
			reg_PC            <= reg_PC ;
			reg_instruction   <= reg_instruction;
			reg_RFdst         <= reg_RFdst;
			reg_RFsrc         <= reg_RFsrc;
			reg_ALUsrc        <= reg_ALUsrc;
			reg_ALUop         <= reg_ALUop;
			reg_MDop          <= reg_MDop;
			reg_data_sram_en  <= reg_data_sram_en;
			reg_data_sram_wen <= reg_data_sram_wen;
			reg_RF_rs_data    <= reg_RF_rs_data;
			reg_RF_rt_data    <= reg_RF_rt_data;
		end else if (ID_stall) begin
			reg_PC            <= 32'hbfc00000;
			reg_instruction   <= 32'd0;
			reg_RFdst         <= 3'b000;
			reg_RFsrc         <= 4'b0000;
			reg_ALUsrc        <= 4'b0000;
			reg_ALUop         <= 12'd0;
			reg_MDop          <= 8'd0;
			reg_data_sram_en  <= 1'b0;
			reg_data_sram_wen <= 4'b0000;
			reg_RF_rs_data    <= 32'd0;
			reg_RF_rt_data    <= 32'd0;
		end else begin
			reg_PC            <= ID_out_PC;
			reg_instruction   <= ID_out_instruction;
			reg_RFdst         <= ID_out_RFdst;
			reg_RFsrc         <= ID_out_RFsrc;
			reg_ALUsrc        <= ID_out_ALUsrc;
			reg_ALUop         <= ID_out_ALUop;
			reg_MDop          <= ID_out_MDop;
			reg_data_sram_en  <= ID_out_data_sram_en;
			reg_data_sram_wen <= ID_out_data_sram_wen;
			reg_RF_rs_data    <= ID_out_RF_rs_data;
			reg_RF_rt_data    <= ID_out_RF_rt_data;
		end
	end

endmodule