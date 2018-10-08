module Divider(
	input clk,
	input rst,
	input div,
	input sign, 
	input [31:0] x,
	input [31:0] y, 
	output [63:0] result,
	output complete
);

my_div u_my_div(
	.clk(clk),
	.rst(rst),
   
	.signed_div_i(sign),
	.opdata1_i(x),
	.opdata2_i(y),
	.start_i(div),
	.annul_i(1'b0),
 
	.result_o(result),
	.ready_o(complete)
);

endmodule