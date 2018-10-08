`include "mycpu.h"

module MEM_MRcontrol(
	input  [31:0] data_rdata,

	output [31:0] mem_data
);

	assign mem_data = data_rdata;

endmodule