`timescale 10 ns / 1 ns

module mycpu_top(
    input clk,
    input resetn,            //low active

    output        inst_sram_en,
    output [3 :0] inst_sram_wen,
    output [31:0] inst_sram_addr,
    output [31:0] inst_sram_wdata,
    input  [31:0] inst_sram_rdata,
    
    output        data_sram_en,
    output [3 :0] data_sram_wen,
    output [31:0] data_sram_addr,
    output [31:0] data_sram_wdata,
    input  [31:0] data_sram_rdata,

    //debug interface
    output [31:0] debug_wb_pc,
    output [3 :0] debug_wb_rf_wen,
    output [4 :0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
);

wire rst = ~resetn;

assign inst_sram_wen = 4'b0000;
assign inst_sram_wdata = 32'd0;
assign inst_sram_en = resetn;

wire [31:0] IF_in_PC;
wire [31:0] IF_out_PC = IF_in_PC;
wire [31:0] ID_in_PC;
wire [31:0] ID_out_PC = ID_in_PC;
wire [31:0] EX_in_PC;
wire [31:0] EX_out_PC = EX_in_PC;
wire [31:0] MEM_in_PC;
wire [31:0] MEM_out_PC = MEM_in_PC;
wire [31:0] WB_in_PC;

wire [31:0] ID_in_instruction;
wire [31:0] ID_out_instruction = ID_in_instruction;
wire [31:0] EX_in_instruction;
wire [31:0] EX_out_instruction = EX_in_instruction;
wire [31:0] MEM_in_instruction;

wire [4:0] ID_out_PCsrc;

wire [31:0] ID_out_nextPC;

wire [2:0] ID_out_RFdst;
wire [2:0] EX_in_RFdst;
wire [2:0] EX_out_RFdst = EX_in_RFdst;
wire [2:0] MEM_in_RFdst;

wire [3:0] ID_out_RFsrc;
wire [3:0] EX_in_RFsrc;
wire [3:0] EX_out_RFsrc = EX_in_RFsrc;
wire [3:0] MEM_in_RFsrc;

wire [31:0] ID_out_RF_rs_data;
wire [31:0] EX_in_RF_rs_data;

wire [31:0] ID_out_RF_rt_data;
wire [31:0] EX_in_RF_rt_data;

wire [31:0] EX_out_ALUresult;
wire [31:0] MEM_in_ALUresult;

wire [31:0] EX_out_MD_data;
wire [31:0] MEM_in_MD_data;

wire [3:0] ID_out_ALUsrc;
wire [3:0] EX_in_ALUsrc;

wire [11:0] ID_out_ALUop;
wire [11:0] EX_in_ALUop;

wire [7:0] ID_out_MDop;
wire [7:0] EX_in_MDop;

wire ID_out_data_sram_en;
wire EX_in_data_sram_en;

wire [3:0] ID_out_data_sram_wen;
wire [3:0] EX_in_data_sram_wen;

wire [4:0] MEM_out_RF_waddr;
wire [4:0] WB_in_RF_waddr;

wire [31:0] MEM_out_RF_wdata;
wire [31:0] WB_in_RF_wdata;

wire MEM_out_RF_wen;
wire WB_in_RF_wen;

wire [31:0] EX_out_data_sram_wdata;
wire [31:0] MEM_in_data_sram_wdata;

wire [31:0] EX_out_data_sram_addr;
wire [31:0] MEM_in_data_sram_addr;

wire [31:0] MEM_in_mem_rdata = data_sram_rdata;
wire [31:0] MEM_out_mem_rdata;

wire IF_stall, ID_stall, EX_stall, MEM_stall;
wire ID_bypass_stall, EX_MD_stall;

// Stall control
assign IF_stall = ID_stall;
assign ID_stall = EX_stall | ID_bypass_stall;
assign EX_stall = MEM_stall | EX_MD_stall;
assign MEM_stall = 1'b0;

// IF
IF u_IF(
    .clk(clk),
    .rst(rst),
    .IF_stall(IF_stall),

    .next_PC(ID_out_nextPC),

    .IF_in_PC(IF_in_PC)
);

assign inst_sram_addr = IF_in_PC;

// IF_ID
IF_ID u_IF_ID(
    .clk(clk),
    .rst(rst),
    .IF_stall(IF_stall),
    .ID_stall(ID_stall),

    .IF_out_PC(IF_out_PC),

    .ID_in_PC(ID_in_PC)
);


// ID
ID_Control u_ID_Control(
    .instruction(ID_in_instruction),

    .ALUsrc(ID_out_ALUsrc),
    .ALUop(ID_out_ALUop),
    .MDop(ID_out_MDop),

    .PCsrc(ID_out_PCsrc),

    .RFdst(ID_out_RFdst),
    .RFsrc(ID_out_RFsrc),
    .data_en(ID_out_data_sram_en),
    .data_wen(ID_out_data_sram_wen)
);

ID_IRbuffer u_ID_IRbuffer(
    .clk(clk),
    .rst(rst),
    .ID_stall(ID_stall),
    .inst_sram_rdata(inst_sram_rdata),
    
    .ID_instruction(ID_in_instruction)
);

wire [31:0] RF_rs_data, RF_rt_data;
ID_Regfile u_ID_Regfile(   
    .clk(clk),
    .rst(rst),

    .raddr1(ID_in_instruction[25:21]),
    .raddr2(ID_in_instruction[20:16]),

    .waddr(WB_in_RF_waddr),
    .wdata(WB_in_RF_wdata),
    .wen(WB_in_RF_wen),

    .rdata1(RF_rs_data),
    .rdata2(RF_rt_data)
);

ID_RAWbypass u_ID_RAWbypass(
    .ID_instruction(ID_in_instruction),
    .EX_instruction(EX_in_instruction),
    .MEM_RF_waddr(MEM_out_RF_waddr),
    .WB_RF_waddr(WB_in_RF_waddr),

    .ID_RFsrc(ID_out_RFsrc),

    .EX_RFdst(EX_in_RFdst),

    .rs_data(RF_rs_data),
    .rt_data(RF_rt_data),

    .EX_ALUresult(EX_out_ALUresult),
    .MEM_RF_wdata(MEM_out_RF_wdata),
    .WB_RF_wdata(WB_in_RF_wdata),

    .ID_out_RF_rs_data(ID_out_RF_rs_data),
    .ID_out_RF_rt_data(ID_out_RF_rt_data),
    .ID_bypass_stall(ID_bypass_stall)
);

ID_PCcontrol u_ID_PCcontrol(
    .oriPC(ID_in_PC),
    .curPC(IF_in_PC),
    .target(ID_in_instruction[25:0]),
    .offset(ID_in_instruction[15:0]),

    .rs_data(ID_out_RF_rs_data),
    .rt_data(ID_out_RF_rt_data),

    .PCsrc(ID_out_PCsrc),

    .nextPC(ID_out_nextPC)
);

// ID_EX
ID_EX u_ID_EX(
    .clk(clk),
    .rst(rst),
    .ID_stall(ID_stall),
    .EX_stall(EX_stall),

    .ID_out_PC(ID_out_PC),
    .ID_out_instruction(ID_out_instruction),
    .ID_out_RFdst(ID_out_RFdst),
    .ID_out_RFsrc(ID_out_RFsrc),
    .ID_out_ALUsrc(ID_out_ALUsrc),
    .ID_out_ALUop(ID_out_ALUop),
    .ID_out_MDop(ID_out_MDop),
    .ID_out_data_sram_en(ID_out_data_sram_en),
    .ID_out_data_sram_wen(ID_out_data_sram_wen),
    .ID_out_RF_rs_data(ID_out_RF_rs_data),
    .ID_out_RF_rt_data(ID_out_RF_rt_data),

    .EX_in_PC(EX_in_PC),
    .EX_in_instruction(EX_in_instruction),
    .EX_in_RFdst(EX_in_RFdst),
    .EX_in_RFsrc(EX_in_RFsrc),
    .EX_in_ALUsrc(EX_in_ALUsrc),
    .EX_in_ALUop(EX_in_ALUop),
    .EX_in_MDop(EX_in_MDop),
    .EX_in_data_sram_en(EX_in_data_sram_en),
    .EX_in_data_sram_wen(EX_in_data_sram_wen),
    .EX_in_RF_rs_data(EX_in_RF_rs_data),
    .EX_in_RF_rt_data(EX_in_RF_rt_data)
);

// EX
wire [31:0] ALU_inputA, ALU_inputB;
EX_ALUcontrol u_EX_ALUcontrol(
    .ALUsrc(EX_in_ALUsrc),

    .rs_data(EX_in_RF_rs_data),
    .rt_data(EX_in_RF_rt_data),
    .imm(EX_in_instruction[15:0]),
    .shamt(EX_in_instruction[10:6]),

    .A(ALU_inputA),
    .B(ALU_inputB)
);

EX_ALU u_EX_ALU(
    .A(ALU_inputA),
    .B(ALU_inputB),
    .OHC_ALUop(EX_in_ALUop),

    .result(EX_out_ALUresult)
);

EX_MulDiv u_EX_MulDiv(
    .clk(clk),
    .rst(rst),

    .MDop(EX_in_MDop),
    .rs_data(EX_in_RF_rs_data),
    .rt_data(EX_in_RF_rt_data),

    .MD_data(EX_out_MD_data),
    .EX_MD_stall(EX_MD_stall)
);

EX_MWcontrol u_EX_MWcontrol(
    .rt_data(EX_in_RF_rt_data),
    .offset(EX_in_instruction[15:0]),
    .rs_data(EX_in_RF_rs_data),

    .data_en(EX_in_data_sram_en),
    .data_wen(EX_in_data_sram_wen),

    .data_wdata(EX_out_data_sram_wdata),
    .data_addr(EX_out_data_sram_addr)
);
assign data_sram_wdata = EX_out_data_sram_wdata;
assign data_sram_addr = EX_out_data_sram_addr;
assign data_sram_en = EX_in_data_sram_en;
assign data_sram_wen = EX_in_data_sram_wen;

// EX_MEM
EX_MEM u_EX_MEM(
    .clk(clk),
    .rst(rst),
    .EX_stall(EX_stall),
    .MEM_stall(MEM_stall),

    .EX_out_ALUresult(EX_out_ALUresult),
    .EX_out_MD_data(EX_out_MD_data),
    .EX_out_PC(EX_out_PC),
    .EX_out_instruction(EX_out_instruction),
    .EX_out_data_sram_addr(EX_out_data_sram_addr),
    .EX_out_data_sram_wdata(EX_out_data_sram_wdata),
    .EX_out_RFdst(EX_out_RFdst),
    .EX_out_RFsrc(EX_out_RFsrc),

    .MEM_in_ALUresult(MEM_in_ALUresult),
    .MEM_in_MD_data(MEM_in_MD_data),
    .MEM_in_PC(MEM_in_PC),
    .MEM_in_instruction(MEM_in_instruction),
    .MEM_in_data_sram_addr(MEM_in_data_sram_addr),
    .MEM_in_data_sram_wdata(MEM_in_data_sram_wdata),
    .MEM_in_RFdst(MEM_in_RFdst),
    .MEM_in_RFsrc(MEM_in_RFsrc)
);

// MEM
MEM_MRcontrol u_MEM_MRcontrol(
    .data_rdata(MEM_in_mem_rdata),

    .mem_data(MEM_out_mem_rdata)
);

MEM_RFcontrol u_MEM_RFcontrol(
    .RFdst(MEM_in_RFdst),
    .RFsrc(MEM_in_RFsrc),

    .mem_data(MEM_out_mem_rdata),
    .alu_result(MEM_in_ALUresult),
    .PC(MEM_in_PC),
    .MD_data(MEM_in_MD_data),

    .rd(MEM_in_instruction[15:11]),
    .rt(MEM_in_instruction[20:16]),
    //output
    .RF_wdata(MEM_out_RF_wdata),
    .RF_waddr(MEM_out_RF_waddr),
    .RF_wen(MEM_out_RF_wen)
);

// MEM_WB
MEM_WB u_MEM_WB(
    .clk(clk),
    .rst(rst),
    .MEM_stall(MEM_stall),

    .MEM_out_RF_wdata(MEM_out_RF_wdata),
    .MEM_out_RF_waddr(MEM_out_RF_waddr),
    .MEM_out_RF_wen(MEM_out_RF_wen),
    .MEM_out_PC(MEM_out_PC),

    .WB_in_RF_wdata(WB_in_RF_wdata),
    .WB_in_RF_waddr(WB_in_RF_waddr),
    .WB_in_RF_wen(WB_in_RF_wen),
    .WB_in_PC(WB_in_PC)
);

// WB
assign debug_wb_rf_wnum = WB_in_RF_waddr;
assign debug_wb_pc = WB_in_PC;
assign debug_wb_rf_wdata = WB_in_RF_wdata;
assign debug_wb_rf_wen = {4{WB_in_RF_wen}};
	
endmodule