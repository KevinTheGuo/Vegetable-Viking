// THIS IS IT LADIES AND GENTS

module VeggieVik(input CLOCK_50,
					  // VGA Interface 
					  input  [3:0]  KEY, //bit 0 is set up as Reset
					  output [7:0]  VGA_R,					//VGA Red
										 VGA_G,					//VGA Green
										 VGA_B,					//VGA Blue
					  output        VGA_CLK,				//VGA Clock
										 VGA_SYNC_N,			//VGA Sync signal
										 VGA_BLANK_N,			//VGA Blank signal
										 VGA_VS,					//VGA virtical sync signal	
										 VGA_HS,					//VGA horizontal sync signal)
					  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
					  inout  [31:0] DRAM_DQ,				// SDRAM Data 32 Bits
					  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
					  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
					  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
					  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
					  output			 DRAM_CKE,				// SDRAM Clock Enable
					  output			 DRAM_WE_N,				// SDRAM Write Enable
					  output			 DRAM_CS_N,				// SDRAM Chip Select
					  output			 DRAM_CLK);				// SDRAM Clock
					  
					  // initializing variable stuff
					  logic		Clk;
					  logic 		Reset_h;  // The push buttons are active low
					  logic 		[23:0] bmp_Pixel;		
					  
					  // frame buffer stuff
					  logic 		[7:0]  frame_data;		// input data to frame buffer
					  logic 		[18:0] frame_rdAddress;	// read address for frame buffer
					  logic 		[18:0] frame_wrAddress;	// write address for frame buffer
					  logic 		frame_wrEn;					// write enable for frame buffer
					  logic 		[7:0] frame_output;		// output from frame buffer
					  
					  
					  assign 	Clk = CLOCK_50;
					  assign 	Reset_h = ~(KEY[0]);  // The push buttons are active low
					  
					  
					  nios_system nios_system(
								 .clk_clk(Clk),         
								 .reset_reset_n((KEY[0])),   
								 .sdram_wire_addr(DRAM_ADDR), 
								 .sdram_wire_ba(DRAM_BA),   
								 .sdram_wire_cas_n(DRAM_CAS_N),
								 .sdram_wire_cke(DRAM_CKE),  
								 .sdram_wire_cs_n(DRAM_CS_N), 
								 .sdram_wire_dq(DRAM_DQ),   
								 .sdram_wire_dqm(DRAM_DQM),  
								 .sdram_wire_ras_n(DRAM_RAS_N),
								 .sdram_wire_we_n(DRAM_WE_N), 
								 .sdram_clk_clk(DRAM_CLK),
								 .bmp_pixout_export(bmp_Pixel));
								 
						frame_buffer frame_buffer_inst(
									.clock(Clk),
									.data(frame_data),
									.rdaddress(frame_rdAddress),
									.wraddress(frame_wrAddress),
									.wren(frame_wrEn),
									.q(frame_output)
									);
									
						
	
			
endmodule