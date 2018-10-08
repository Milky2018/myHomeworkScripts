`define DivFree            2'b00
`define DivByZero          2'b01
`define DivOn              2'b10
`define DivEnd             2'b11
`define DivResultReady     1'b1
`define DivResultNotReady  1'b0
`define DivStart           1'b1
`define DivStop            1'b0

module my_div(
	input  	          clk,
	input  	          rst,

	input             signed_div_i,
	input      [31:0] opdata1_i,
	input      [31:0] opdata2_i,
	input             start_i,
	input             annul_i,

	output reg [63:0] result_o,
	output reg        ready_o
);

	wire [32:0] div_temp;

	reg [5 :0] cnt;
	reg [64:0] dividend;
	reg [1 :0] state;
	reg [31:0] divisor; 
	reg [31:0] temp_op1;
	reg [31:0] temp_op2;

	assign div_temp = {1'b0, dividend[63:32]} - {1'b0, divisor};

	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			state    <= `DivFree;
			ready_o  <= `DivResultNotReady;
			result_o <= {32'd0,32'd0};
		end else begin
			case (state)
				`DivFree: begin 
					if(start_i == `DivStart && annul_i == 1'b0) begin
			  			if(opdata2_i == 32'd0) begin
			    			state <= `DivByZero; 
			  			end else begin
			    			state <= `DivOn; 
			    			cnt <= 6'b000000;
			    			if(signed_div_i == 1'b1 && opdata1_i[31] == 1'b1 ) begin
			      				temp_op1 = ~opdata1_i + 1; 
			    			end else begin
			      				temp_op1 = opdata1_i;
			    			end
			    			if(signed_div_i == 1'b1 && opdata2_i[31] == 1'b1 ) begin
			      				temp_op2 = ~opdata2_i + 1; 
			    			end else begin
			      				temp_op2 = opdata2_i;
			    			end
				    		dividend <= {32'd0,32'd0};
				    		dividend[32:1] <= temp_op1;
				    		divisor <= temp_op2;
			  			end
					end else begin 
			  			ready_o <= `DivResultNotReady;
			  			result_o <= {32'd0,32'd0};
					end
				end
				`DivByZero: begin 
					dividend <= {32'd0,32'd0};
					state <= `DivEnd;		 		
				end
				`DivOn: begin 
					if(annul_i == 1'b0) begin
			  			if(cnt != 6'b100000) begin 
			    			if(div_temp[32] == 1'b1) begin 
			          			dividend <= {dividend[63:0] , 1'b0};
			    			end else begin
			          			dividend <= {div_temp[31:0] , dividend[31:0] , 1'b1};
			    			end
			    			cnt <= cnt + 1;
			  			end else begin 
			    			if((signed_div_i == 1'b1) && ((opdata1_i[31] ^ opdata2_i[31]) == 1'b1)) begin
			        			dividend[31:0] <= (~dividend[31:0] + 1);
			    			end
			    			if((signed_div_i == 1'b1) && ((opdata1_i[31] ^ dividend[64]) == 1'b1)) begin              
			        			dividend[64:33] <= (~dividend[64:33] + 1);
			    			end
			    			state <= `DivEnd; 
			    			cnt <= 6'd0; 
			  			end
					end else begin
			  			state <= `DivFree; 
					end	
				end
				`DivEnd: begin 
					result_o <= {dividend[64:33], dividend[31:0]};  
					ready_o <= `DivResultReady;
					if(start_i == `DivStop) begin
			 	 		state <= `DivFree;
			  			ready_o <= `DivResultNotReady;
			  			result_o <= {32'd0,32'd0};       	
					end		  	
				end
			endcase
	   	end
	end

endmodule