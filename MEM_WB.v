module MEM_WB(
 	input         clk,
    input         rst,
    input         MEM_stall,

    input  [31:0] MEM_out_RF_wdata,
    input  [4 :0] MEM_out_RF_waddr,
	input  [3 :0] MEM_out_RF_strb,
    input         MEM_out_RF_wen,
    input  [31:0] MEM_out_PC,

    output [31:0] WB_in_RF_wdata,
    output [4 :0] WB_in_RF_waddr,
	output [3 :0] WB_in_RF_strb,
    output        WB_in_RF_wen,
    output [31:0] WB_in_PC
);
    reg [31:0] reg_RF_wdata;
    reg [4 :0] reg_RF_waddr;
	reg [3 :0] reg_RF_strb;
    reg        reg_RF_wen;
    reg [31:0] reg_PC;

    assign WB_in_RF_wdata = reg_RF_wdata;
    assign WB_in_RF_waddr = reg_RF_waddr;
	assign WB_in_RF_strb  = reg_RF_strb;
    assign WB_in_RF_wen   = reg_RF_wen;
    assign WB_in_PC       = reg_PC;

	always @(posedge clk) begin
		if (rst) begin
			reg_RF_wdata <= 32'd0;
			reg_RF_waddr <= 5'd0;
			reg_RF_strb  <= 4'b1111;
			reg_RF_wen   <= 1'b0;
			reg_PC       <= 32'hbfc00000;
		end else if (MEM_stall) begin
			reg_RF_wdata <= 32'd0;
			reg_RF_waddr <= 5'd0;
			reg_RF_strb  <= 4'b1111;
			reg_RF_wen   <= 1'b0;
			reg_PC       <= 32'hbfc00000;
		end else begin
			reg_RF_wdata <= MEM_out_RF_wdata;
			reg_RF_waddr <= MEM_out_RF_waddr;
			reg_RF_strb  <= MEM_out_RF_strb;
			reg_RF_wen   <= MEM_out_RF_wen;
			reg_PC       <= MEM_out_PC;
		end
	end

endmodule