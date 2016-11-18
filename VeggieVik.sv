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
										 VGA_HS,
					  output [6:0]  HEX0, HEX1);					//VGA horizontal sync signal)
						
					  					  // initializing basic variable stuff
					  logic		Clk;
					  logic 		Reset_h;  // The push buttons are active low
					  logic 		graphics_clk;
					 
					  assign Clk = CLOCK_50;
					  assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
					  assign VGA_CLK = graphics_clk;					 
					  
					  
					  // NIOS stuff
					  /*output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
					  inout  [31:0] DRAM_DQ,				// SDRAM Data 32 Bits
					  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
					  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
					  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
					  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
					  output			 DRAM_CKE,				// SDRAM Clock Enable
					  output			 DRAM_WE_N,				// SDRAM Write Enable
					  output			 DRAM_CS_N,				// SDRAM Chip Select
					  output			 DRAM_CLK);*/				// SDRAM Clock
					  
					  // VGA controller stuff
					  vga_controller vgasync_instance(
									.Clk(Clk), 
									.Reset(Reset_h), 
									.hs(VGA_HS), 
									.vs(VGA_VS),
									.sync(VGA_SYNC_N), 
									.blank(VGA_BLANK_N), 
									.DrawX(DrawX), 
									.DrawY(DrawY), 
									.pixel_clk(graphics_clk));
								
					  
					  // nios system stuff
					  /*nios_system nios_system(
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
//								 .bmp_pixout_export(bmp_Pixel)
									);*/
					  
					  
					  // hardware-software communication
	/*			  io_module io_module_inst (.clk(Clk),
										.reset_n(Reset_h),
										.to_sw_sig,
										.to_hw_sig,
										.to_hw_port0,
										.msg_en(msg_en),
										.key(aes_key),
										.msg_de(msg_de),
										.io_ready(io_ready),
										.aes_ready(aes_ready)
					);

		*/			  

					  
					  // frame buffer stuff
					  logic 		[7:0]  frame_input;		// input data to frame buffer
//					  logic 		[18:0] frame_rdAddress;	// read address for frame buffer
					  logic 		[18:0] frame_wrAddress;	// write address for frame buffer
					  logic 		frame_we;					// write enable for frame buffer
					  logic 		[7:0] frame_output;		// output from frame buffer
					  
						assign frame_we = 1'b0;
						assign frame_rdAddress = 19'h00029;
						// frame buffer initialization
						Frame_Buffer frame_buffer_inst(
									.clock(Clk),
									.data(frame_input),
									.rdaddress(frame_rdAddress),
									.wraddress(frame_wrAddress),
									.wren(frame_we),
									.q(frame_output)
									);
						
						HexDriver hex0(.In0(frame_output[7:4]), .Out0(HEX1));
						HexDriver hex1(.In0(frame_output[3:0]), .Out0(HEX0));
						// frame displayer initialization
						frame_displayer frame_displayer_inst(
									.Clk(Clk), 
									.pixel_clk(graphics_clk),
									.reset(reset_h),
								//	.drawingCode,
									.DrawX(DrawX),
									.DrawY(DrawY),
									.frame_output(frame_output),
									.frame_rdAddress(frame_rdAddress),
									.Red(VGA_R),
									.Green(VGA_G),
									.Blue(VGA_B)
									);
									
						
	
			
endmodule