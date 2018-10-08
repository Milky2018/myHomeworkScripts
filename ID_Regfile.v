module ID_Regfile(
	input         clk,
	input         rst,

	input  [4 :0] raddr1,
	input  [4 :0] raddr2,

	input  [4 :0] waddr,
	input  [31:0] wdata,
	input         wen,

	output [31:0] rdata1,
	output [31:0] rdata2
);

	reg [31:0] r [31:0];
	
	/*
	wire [7:0] byte1;
	wire [7:0] byte2;
	wire [7:0] byte3;
	wire [7:0] byte4;
	assign byte1 = strb[0]? wdata[7:0] : r[waddr][7:0];
	assign byte2 = strb[1]? wdata[15:8] : r[waddr][15:8];
	assign byte3 = strb[2]? wdata[23:16] : r[waddr][23:16];
	assign byte4 = strb[3]? wdata[31:24] : r[waddr][31:24];
	*/
	
	always @(posedge clk or posedge rst) begin
		if (rst == 1) begin
			r[0] <= 32'd0;
		end
	end
		
	always @(posedge clk) begin
		if (wen == 1 && waddr != 0) begin
			r[waddr] <= wdata;
		end
	end
		
	assign rdata1 = r[raddr1];
	assign rdata2 = r[raddr2];

endmodule