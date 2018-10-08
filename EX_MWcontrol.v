`include "mycpu.h"

module EX_MWcontrol(
	input  [31:0] rt_data,
	input  [15:0] offset,
	input  [31:0] rs_data,

	input         data_en,
	input  [3 :0] data_wen,

	output [31:0] data_wdata,
	output [31:0] data_addr
);
	assign data_wdata = rt_data;
	assign data_addr  = rs_data + {{16{offset[15]}}, offset};	

endmodule