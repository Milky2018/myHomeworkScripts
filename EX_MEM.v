`include "mycpu.h"

module EX_MEM(
    input         clk,
    input         rst,
    input         EX_stall,
    input         MEM_stall,

    input  [31:0] EX_out_ALUresult,
    input  [31:0] EX_out_MD_data,
    input  [31:0] EX_out_PC,
    input  [31:0] EX_out_instruction,
    input  [31:0] EX_out_data_sram_addr,
    input  [31:0] EX_out_data_sram_wdata,
    input  [2 :0] EX_out_RFdst,
    input  [3 :0] EX_out_RFsrc,

    output [31:0] MEM_in_ALUresult,
    output [31:0] MEM_in_MD_data,
    output [31:0] MEM_in_PC,
    output [31:0] MEM_in_instruction,
    output [31:0] MEM_in_data_sram_addr,
    output [31:0] MEM_in_data_sram_wdata,
    output [2 :0] MEM_in_RFdst,
    output [3 :0] MEM_in_RFsrc
);
	
	reg [31:0] reg_ALUresult;
	reg [31:0] reg_MD_data;
    reg [31:0] reg_PC;
    reg [31:0] reg_instruction;
    reg [31:0] reg_data_sram_addr;
    reg [31:0] reg_data_sram_wdata;
    reg [2 :0] reg_RFdst;
    reg [3 :0] reg_RFsrc;

    assign MEM_in_ALUresult       = reg_ALUresult;
    assign MEM_in_MD_data         = reg_MD_data;
    assign MEM_in_PC              = reg_PC;
    assign MEM_in_instruction     = reg_instruction;
    assign MEM_in_data_sram_addr  = reg_data_sram_addr;
    assign MEM_in_data_sram_wdata = reg_data_sram_wdata;
    assign MEM_in_RFdst           = reg_RFdst;
    assign MEM_in_RFsrc           = reg_RFsrc;

	always @(posedge clk) begin
		if (rst) begin
	        reg_ALUresult       <= 32'd0;
	        reg_MD_data         <= 32'd0;
	        reg_PC              <= 32'hbfc00000;
	        reg_instruction     <= 32'd0;
	        reg_data_sram_addr  <= 32'd0;
	        reg_data_sram_wdata <= 32'd0;
	        reg_RFdst           <= 3'b000;
	        reg_RFsrc           <= 4'b0000;
		end else if (MEM_stall) begin
			reg_ALUresult       <= reg_ALUresult;
			reg_MD_data         <= reg_MD_data;
	        reg_PC              <= reg_PC;
	        reg_instruction     <= reg_instruction;
	        reg_data_sram_addr  <= reg_data_sram_addr;
	        reg_data_sram_wdata <= reg_data_sram_wdata;
	        reg_RFdst           <= reg_RFdst;
	        reg_RFsrc           <= reg_RFsrc;
		end else if (EX_stall) begin
			reg_ALUresult       <= 32'd0;
			reg_MD_data         <= 32'd0;
	        reg_PC              <= 32'hbfc00000;
	        reg_instruction     <= 32'd0;
	        reg_data_sram_addr  <= 32'd0;
	        reg_data_sram_wdata <= 32'd0;
	        reg_RFdst           <= 3'b000;
	        reg_RFsrc           <= 4'b0000;
		end else begin
	        reg_ALUresult       <= EX_out_ALUresult;
	        reg_MD_data         <= EX_out_MD_data;
	        reg_PC              <= EX_out_PC;
	        reg_instruction     <= EX_out_instruction;
	        reg_data_sram_addr  <= EX_out_data_sram_addr;
	        reg_data_sram_wdata <= EX_out_data_sram_wdata;
	        reg_RFdst           <= EX_out_RFdst;
	        reg_RFsrc           <= EX_out_RFsrc;
		end
	end

endmodule