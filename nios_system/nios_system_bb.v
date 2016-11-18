
module nios_system (
	clk_clk,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	to_hw_port0_export,
	to_hw_port1_export,
	to_hw_port2_export,
	to_hw_port3_export,
	to_hw_port4_export,
	to_hw_port5_export,
	to_hw_port6_export,
	to_hw_port7_export,
	to_hw_port8_export,
	to_hw_port9_export);	

	input		clk_clk;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[31:0]	to_hw_port0_export;
	output	[31:0]	to_hw_port1_export;
	output	[31:0]	to_hw_port2_export;
	output	[31:0]	to_hw_port3_export;
	output	[31:0]	to_hw_port4_export;
	output	[31:0]	to_hw_port5_export;
	output	[31:0]	to_hw_port6_export;
	output	[31:0]	to_hw_port7_export;
	output	[31:0]	to_hw_port8_export;
	output	[31:0]	to_hw_port9_export;
endmodule
