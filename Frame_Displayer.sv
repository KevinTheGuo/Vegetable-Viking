/*---------------------------------------------------------------------------
							Frame_Displayer
  ---------------------------------------------------------------------------*/
// A module that will take in a command and use it to display sprites!

// BEHOLD!!!!! THE GANKBRUSH 5000 :O

module frame_displayer
(
			input Clk, 
			input pixel_clk, 
			input reset, 
			input Display,
	//		input [32:0] drawingCode,		// this is for when we get hardware-software comms
			input [9:0] DrawX, DrawY, 	// our current coordinate
			input [7:0] frame_output, bgFrame_output,		// output from frame buffer (last clock cycle's data)
			//input [19:0] sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, sprite9, sprite10, sprite11, sprite12, sprite13, sprite14,
			input [9:0] xCoord1,
			input [9:0] xCoord2,
			input [9:0] xCoord3,
			input [9:0] xCoord4,
			input [9:0] xCoord5,
			input [9:0] xCoord6,
			input [9:0] xCoord7,
			input [9:0] xCoord8, /*xCoord9, xCoord10, xCoord11, xCoord12, xCoord13, xCoord14, xCoord15,*/
			input [9:0] yCoord1,
			input [9:0] yCoord2,
			input [9:0] yCoord3,
			input [9:0] yCoord4,
			input [9:0] yCoord5,
			input [9:0] yCoord6,
			input [9:0] yCoord7,
			input [9:0] yCoord8, /*yCoord9, yCoord10, yCoord11, yCoord12, yCoord13, yCoord14, yCoord15,*/
			input [2:0] state1,
			input [2:0] state2,
			input [2:0] state3,
			input [2:0] state4,
			input [2:0] state5,
			input [2:0] state6,
			input [2:0] state7,
			input [2:0] state8, /*state9, state10, state11, state12, state13, state14, state15,*/
			/*input [2:0] type1,
			input [2:0] type2,
			input [2:0] type3,
			input [2:0] type4,
			input [2:0] type5,
			input [2:0] type6,
			input [2:0] type7,
			input [2:0] type8, type9, type10, type11, type12, type13, type14, type15,*/
			input [9:0] cursorX,
			input [9:0] cursorY,
			input streakIndicator,
			output logic [18:0] frame_rdAddress, bgFrame_rdAddress,	// read address for frame buffer
			output logic [7:0]  Red, Green, Blue);	// output our RGB values!!!
			
			// create some of our parameters
			parameter [9:0] ScreenX = 640;     // width of x axis
			parameter [9:0] ScreenY = 480;     // width of y axis
			
			parameter [18:0] spriteOffset	= 307200;
			parameter [9:0] spriteWidth = 64;
			
			// Broccoli
			parameter [7:0]  sprite1Height = 65;
			parameter [18:0] broc_0_Offset = 0;
			parameter [18:0] broc_1_Offset = 32704; // 511 * 64
			parameter [18:0] broc_2_Offset = 64320; // 1005 * 64
			parameter [18:0] broc_3_Offset = 95936; // 1499 * 64
			
			// Eggplant
			parameter [7:0]  sprite2Height = 81;
			parameter [18:0] eggplant_0_Offset = 4160; // 65 * 64
			parameter [18:0] eggplant_1_Offset = 36800; // 575 * 64
			parameter [18:0] eggplant_2_Offset = 68352; // 1068 * 64
			parameter [18:0] eggplant_3_Offset = 99968; // 1562 * 64
			
			// Potatoes
			parameter [7:0] sprite3Height = 85;
			parameter [18:0] potato_0_Offset = 9344; // 146 * 64
			parameter [18:0] potato_1_Offset = 41984; // 656 * 64
			parameter [18:0] potato_2_Offset = 73600; // 1150 * 64
			parameter [18:0] potato_3_Offset = 105152; // 1643 * 64
			
			// Carrot
			parameter [7:0] sprite4Height = 39;
			parameter [18:0] carrot_0_Offset = 14784; // 231 * 64
			parameter [18:0] carrot_1_Offset = 44992; // 730 * 64
			parameter [18:0] carrot_2_Offset = 78336; // 1224 * 64
			parameter [18:0] carrot_3_Offset = 109888; // 1717 * 64
			
			// Cabbage
			parameter [7:0] sprite5Height = 66;
			parameter [18:0] cabbage_0_Offset = 17280; // 270 * 64
			parameter [18:0] cabbage_1_Offset = 49280; // 770 * 64
			parameter [18:0] cabbage_2_Offset = 80832; // 1263 * 64
			parameter [18:0] cabbage_3_Offset = 112384; // 1756 * 64
			
			// Radish
			parameter [7:0] sprite6Height = 64;
			parameter [18:0] radish_0_Offset = 21504; // 336 * 64
			parameter [18:0] radish_1_Offset = 53312; // 833 * 64
			parameter [18:0] radish_2_Offset = 84864; // 1326 * 64
			parameter [18:0] radish_3_Offset = 116416; // 1819 * 64
			
			// Tomato
			parameter [7:0] sprite7Height = 42;
			parameter [18:0] tomato_0_Offset = 25600; // 400 * 64
			parameter [18:0] tomato_1_Offset = 57472; // 898 * 64
			parameter [18:0] tomato_2_Offset = 89024; // 1391 * 64
			parameter [18:0] tomato_3_Offset = 119936; // 1874 * 64
			
			// Onion
			parameter [7:0] sprite8Height = 69;
			parameter [18:0] onion_0_Offset = 28288; // 442 * 64
			parameter [18:0] onion_1_Offset = 59968; // 937 * 64
			parameter [18:0] onion_2_Offset = 91520; // 1430 * 64
			parameter [18:0] onion_3_Offset = 122432; // 1913 * 64
			
			logic [18:0] sprite1Offset, sprite2Offset, sprite3Offset, sprite4Offset, sprite5Offset, sprite6Offset, sprite7Offset, sprite8Offset;
							 //sprite9Offset, sprite10Offset, sprite11Offset, sprite12Offset, sprite13Offset, sprite14Offset, sprite15Offset, sprite16Offset;
			
			// Determine what sprites 1 - 16 are
			always_comb
				begin
					// state 1
					if(state1 == 3'b010)
						sprite1Offset = broc_1_Offset;
					else if(state1 == 3'b011)
						sprite1Offset = broc_2_Offset;
					else if(state1 == 3'b100)
						sprite1Offset = broc_3_Offset;
					else 
						sprite1Offset = broc_0_Offset;
					
					// state 2
					if(state2 == 3'b010)
						sprite2Offset = eggplant_1_Offset;
					else if(state2 == 3'b011)
						sprite2Offset = eggplant_2_Offset;
					else if(state2 == 3'b100)
						sprite2Offset = eggplant_3_Offset;
					else 
						sprite2Offset = eggplant_0_Offset;
					
					// state3
					if(state3 == 3'b010)
						sprite3Offset = potato_1_Offset;
					else if(state3 == 3'b011)
						sprite3Offset = potato_2_Offset;
					else if(state3 == 3'b100)
						sprite3Offset = potato_3_Offset;
					else 
						sprite3Offset = potato_0_Offset;
					
					// state4
					if(state4 == 3'b010)
						sprite4Offset = carrot_1_Offset;
					else if(state4 == 3'b011)
						sprite4Offset = carrot_2_Offset;
					else if(state4 == 3'b100)
						sprite4Offset = carrot_3_Offset;
					else 
						sprite4Offset = carrot_0_Offset;;
					
					// state5
					if(state5 == 3'b010)
						sprite5Offset = cabbage_1_Offset;
					else if(state5 == 3'b011)
						sprite5Offset = cabbage_2_Offset;
					else if(state5 == 3'b100)
						sprite5Offset = cabbage_3_Offset;
					else 
						sprite5Offset = cabbage_0_Offset;
						
					// state6
					if(state6 == 3'b010)
						sprite6Offset = radish_1_Offset;
					else if(state6 == 3'b011)
						sprite6Offset = radish_2_Offset;
					else if(state6 == 3'b100)
						sprite6Offset = radish_3_Offset;
					else 
						sprite6Offset = radish_0_Offset;
					
					// state7
					if(state7 == 3'b010)
						sprite7Offset = tomato_1_Offset;
					else if(state7 == 3'b011)
						sprite7Offset = tomato_2_Offset;
					else if(state7 == 3'b100)
						sprite7Offset = tomato_3_Offset;
					else 
						sprite7Offset = tomato_0_Offset;
					
					// state8
					if(state8 == 3'b010)
						sprite8Offset = onion_1_Offset;
					else if(state8 == 3'b011)
						sprite8Offset = onion_2_Offset;
					else if(state8 == 3'b100)
						sprite8Offset = onion_3_Offset;
					else 
						sprite8Offset = onion_0_Offset;
					
				end
			// Declare and initialize the heights and offsets that will be used in the drawing process
			
			
			
			//parameter [2:0] positionMultiplier = 5;
			
			
			// spriteX[19:17] ===> sprite state (if it's 0, it doesn't exist yet)
			// spriteX[13:7]  ===> yPos
			// spriteX[6:0]   ===> xPos
			
			logic [1:0] palette; // 0 for background palette, 1 for vegetable sprite palette
			
			always_ff @ (posedge pixel_clk)
					begin
						if(Display)
							begin
							bgFrame_rdAddress = (DrawX + (DrawY*ScreenX));
							
							if((state1 != 3'b0) // Sprite 1
								&& (DrawX >= xCoord1) 
								&& (DrawX < (xCoord1 + spriteWidth)) 
								&& (DrawY >= yCoord1)
								&& (DrawY < (yCoord1 + sprite1Height)))
								begin
									frame_rdAddress = spriteOffset + sprite1Offset 
									+ (DrawX - xCoord1) + ((DrawY - yCoord1) * spriteWidth);
									palette = 2'b01;
								end
							else if((state2 != 3'b0) // Sprite 2
								&& (DrawX >= xCoord2) 
								&& (DrawX < (xCoord2 + spriteWidth)) 
								&& (DrawY >= yCoord2)
								&& (DrawY < (yCoord2 + sprite2Height)))
								begin
									frame_rdAddress = spriteOffset + sprite2Offset 
									+ (DrawX - xCoord2) + ((DrawY - yCoord2) * spriteWidth);
									palette = 2'b01;
								end
							else if((state3 != 3'b0) // Sprite 3
								&& (DrawX >= xCoord3) 
								&& (DrawX < (xCoord3 + spriteWidth)) 
								&& (DrawY >= yCoord3)
								&& (DrawY < (yCoord3 + sprite3Height)))
								begin
									frame_rdAddress = spriteOffset + sprite3Offset 
									+ (DrawX - xCoord3) + ((DrawY - yCoord3) * spriteWidth);
									palette = 2'b01;
								end
							else if((state4 != 3'b0) // Sprite 4
								&& (DrawX >= xCoord4) 
								&& (DrawX < (xCoord4 + spriteWidth)) 
								&& (DrawY >= yCoord4)
								&& (DrawY < (yCoord4 + sprite4Height)))
								begin
									frame_rdAddress = spriteOffset + sprite4Offset 
									+ (DrawX - xCoord4) + ((DrawY - yCoord4) * spriteWidth);
									palette = 2'b01;
								end
						  else if((state5 != 3'b0) // Sprite 5
								&& (DrawX >= xCoord5) 
								&& (DrawX < (xCoord5 + spriteWidth)) 
								&& (DrawY >= yCoord5)
								&& (DrawY < (yCoord5 + sprite5Height)))
								begin
									frame_rdAddress = spriteOffset + sprite5Offset 
									+ (DrawX - xCoord5) + ((DrawY - yCoord5) * spriteWidth);
									palette = 2'b01;
								end
						  else if((state6 != 3'b0) // Sprite 6
								&& (DrawX >= xCoord6) 
								&& (DrawX < (xCoord6 + spriteWidth)) 
								&& (DrawY >= yCoord6)
								&& (DrawY < (yCoord6 + sprite6Height)))
								begin
									frame_rdAddress = spriteOffset + sprite6Offset 
									+ (DrawX - xCoord6) + ((DrawY - yCoord6) * spriteWidth);
									palette = 2'b01;
								end
							else if((state7 != 3'b0) // Sprite 7
								&& (DrawX >= xCoord7) 
								&& (DrawX < (xCoord7 + spriteWidth)) 
								&& (DrawY >= yCoord7)
								&& (DrawY < (yCoord7 + sprite7Height)))
								begin
									frame_rdAddress = spriteOffset + sprite7Offset 
									+ (DrawX - xCoord7) + ((DrawY - yCoord7) * spriteWidth);
									palette = 2'b01;
								end
							else if((state8 != 3'b0) // Sprite 8
								&& (DrawX >= xCoord8) 
								&& (DrawX < (xCoord8 + spriteWidth)) 
								&& (DrawY >= yCoord8)
								&& (DrawY < (yCoord8 + sprite8Height)))
								begin
									frame_rdAddress = spriteOffset + sprite8Offset 
									+ (DrawX - xCoord8) + ((DrawY - yCoord8) * spriteWidth);
									palette = 2'b01;
								end
							else
								begin
									frame_rdAddress = (DrawX + (DrawY*ScreenX));
									palette = 2'b00;
								end
							end
						else
							begin
							frame_rdAddress = 19'h00000;
							bgFrame_rdAddress = 19'h00000;
							end
					end
			
			logic [1:0] actualPalette;
			
			always_comb
				begin 
					if(Display)
						begin	
							if(frame_output == 8'h54)
								actualPalette = 2'b00;
							else
								actualPalette = palette;
								
							if(((DrawX - cursorX) * (DrawX - cursorX) + (DrawY - (480 - cursorY)) * (DrawY - (480 - cursorY))) <= 100)
								begin
									if(streakIndicator)
										begin
											Red = 8'hff;
											Green = 8'hff;
											Blue = 8'hff;
										end
									else
										begin
											Red = 8'hCF;
											Green = 8'hB5;
											Blue = 8'h3B;
										end
								end
							else if(actualPalette == 2'b01)
								begin
									unique case(frame_output)
									8'h0:
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'h0;
	end
8'h1:
	begin
		Red = 8'h80;
		Green = 8'h0;
		Blue = 8'h0;
	end
8'h2:
	begin
		Red = 8'h0;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h3:
	begin
		Red = 8'h80;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h4:
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h5:
	begin
		Red = 8'h80;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h6:
	begin
		Red = 8'h0;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'h7:
	begin
		Red = 8'hc0;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'h8:
	begin
		Red = 8'hc0;
		Green = 8'hdc;
		Blue = 8'hc0;
	end
8'h9:
	begin
		Red = 8'ha6;
		Green = 8'hca;
		Blue = 8'hf0;
	end
8'ha:
	begin
		Red = 8'h40;
		Green = 8'h20;
		Blue = 8'h0;
	end
8'hb:
	begin
		Red = 8'h60;
		Green = 8'h20;
		Blue = 8'h0;
	end
8'hc:
	begin
		Red = 8'h80;
		Green = 8'h20;
		Blue = 8'h0;
	end
8'hd:
	begin
		Red = 8'ha0;
		Green = 8'h20;
		Blue = 8'h0;
	end
8'he:
	begin
		Red = 8'hc0;
		Green = 8'h20;
		Blue = 8'h0;
	end
8'hf:
	begin
		Red = 8'he0;
		Green = 8'h20;
		Blue = 8'h0;
	end
8'h10:
	begin
		Red = 8'h0;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h11:
	begin
		Red = 8'h20;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h12:
	begin
		Red = 8'h40;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h13:
	begin
		Red = 8'h60;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h14:
	begin
		Red = 8'h80;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h15:
	begin
		Red = 8'ha0;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h16:
	begin
		Red = 8'hc0;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h17:
	begin
		Red = 8'he0;
		Green = 8'h40;
		Blue = 8'h0;
	end
8'h18:
	begin
		Red = 8'h0;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h19:
	begin
		Red = 8'h20;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h1a:
	begin
		Red = 8'h40;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h1b:
	begin
		Red = 8'h60;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h1c:
	begin
		Red = 8'h80;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h1d:
	begin
		Red = 8'ha0;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h1e:
	begin
		Red = 8'hc0;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h1f:
	begin
		Red = 8'he0;
		Green = 8'h60;
		Blue = 8'h0;
	end
8'h20:
	begin
		Red = 8'h0;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h21:
	begin
		Red = 8'h20;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h22:
	begin
		Red = 8'h40;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h23:
	begin
		Red = 8'h60;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h24:
	begin
		Red = 8'h80;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h25:
	begin
		Red = 8'ha0;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h26:
	begin
		Red = 8'hc0;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h27:
	begin
		Red = 8'he0;
		Green = 8'h80;
		Blue = 8'h0;
	end
8'h28:
	begin
		Red = 8'h0;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h29:
	begin
		Red = 8'h20;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h2a:
	begin
		Red = 8'h40;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h2b:
	begin
		Red = 8'h60;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h2c:
	begin
		Red = 8'h80;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h2d:
	begin
		Red = 8'ha0;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h2e:
	begin
		Red = 8'hc0;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h2f:
	begin
		Red = 8'he0;
		Green = 8'ha0;
		Blue = 8'h0;
	end
8'h30:
	begin
		Red = 8'h0;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h31:
	begin
		Red = 8'h20;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h32:
	begin
		Red = 8'h40;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h33:
	begin
		Red = 8'h60;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h34:
	begin
		Red = 8'h80;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h35:
	begin
		Red = 8'ha0;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h36:
	begin
		Red = 8'hc0;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h37:
	begin
		Red = 8'he0;
		Green = 8'hc0;
		Blue = 8'h0;
	end
8'h38:
	begin
		Red = 8'h0;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h39:
	begin
		Red = 8'h20;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h3a:
	begin
		Red = 8'h40;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h3b:
	begin
		Red = 8'h60;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h3c:
	begin
		Red = 8'h80;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h3d:
	begin
		Red = 8'ha0;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h3e:
	begin
		Red = 8'hc0;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h3f:
	begin
		Red = 8'he0;
		Green = 8'he0;
		Blue = 8'h0;
	end
8'h40:
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h41:
	begin
		Red = 8'h20;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h42:
	begin
		Red = 8'h40;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h43:
	begin
		Red = 8'h60;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h44:
	begin
		Red = 8'h80;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h45:
	begin
		Red = 8'ha0;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h46:
	begin
		Red = 8'hc0;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h47:
	begin
		Red = 8'he0;
		Green = 8'h0;
		Blue = 8'h40;
	end
8'h48:
	begin
		Red = 8'h0;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h49:
	begin
		Red = 8'h20;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h4a:
	begin
		Red = 8'h40;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h4b:
	begin
		Red = 8'h60;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h4c:
	begin
		Red = 8'h80;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h4d:
	begin
		Red = 8'ha0;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h4e:
	begin
		Red = 8'hc0;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h4f:
	begin
		Red = 8'he0;
		Green = 8'h20;
		Blue = 8'h40;
	end
8'h50:
	begin
		Red = 8'h0;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h51:
	begin
		Red = 8'h20;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h52:
	begin
		Red = 8'h40;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h53:
	begin
		Red = 8'h60;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h54:
	begin
		Red = 8'h80;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h55:
	begin
		Red = 8'ha0;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h56:
	begin
		Red = 8'hc0;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h57:
	begin
		Red = 8'he0;
		Green = 8'h40;
		Blue = 8'h40;
	end
8'h58:
	begin
		Red = 8'h0;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h59:
	begin
		Red = 8'h20;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h5a:
	begin
		Red = 8'h40;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h5b:
	begin
		Red = 8'h60;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h5c:
	begin
		Red = 8'h80;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h5d:
	begin
		Red = 8'ha0;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h5e:
	begin
		Red = 8'hc0;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h5f:
	begin
		Red = 8'he0;
		Green = 8'h60;
		Blue = 8'h40;
	end
8'h60:
	begin
		Red = 8'h0;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h61:
	begin
		Red = 8'h20;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h62:
	begin
		Red = 8'h40;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h63:
	begin
		Red = 8'h60;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h64:
	begin
		Red = 8'h80;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h65:
	begin
		Red = 8'ha0;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h66:
	begin
		Red = 8'hc0;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h67:
	begin
		Red = 8'he0;
		Green = 8'h80;
		Blue = 8'h40;
	end
8'h68:
	begin
		Red = 8'h0;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h69:
	begin
		Red = 8'h20;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h6a:
	begin
		Red = 8'h40;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h6b:
	begin
		Red = 8'h60;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h6c:
	begin
		Red = 8'h80;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h6d:
	begin
		Red = 8'ha0;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h6e:
	begin
		Red = 8'hc0;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h6f:
	begin
		Red = 8'he0;
		Green = 8'ha0;
		Blue = 8'h40;
	end
8'h70:
	begin
		Red = 8'h0;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h71:
	begin
		Red = 8'h20;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h72:
	begin
		Red = 8'h40;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h73:
	begin
		Red = 8'h60;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h74:
	begin
		Red = 8'h80;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h75:
	begin
		Red = 8'ha0;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h76:
	begin
		Red = 8'hc0;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h77:
	begin
		Red = 8'he0;
		Green = 8'hc0;
		Blue = 8'h40;
	end
8'h78:
	begin
		Red = 8'h0;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h79:
	begin
		Red = 8'h20;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h7a:
	begin
		Red = 8'h40;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h7b:
	begin
		Red = 8'h60;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h7c:
	begin
		Red = 8'h80;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h7d:
	begin
		Red = 8'ha0;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h7e:
	begin
		Red = 8'hc0;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h7f:
	begin
		Red = 8'he0;
		Green = 8'he0;
		Blue = 8'h40;
	end
8'h80:
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h81:
	begin
		Red = 8'h20;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h82:
	begin
		Red = 8'h40;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h83:
	begin
		Red = 8'h60;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h84:
	begin
		Red = 8'h80;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h85:
	begin
		Red = 8'ha0;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h86:
	begin
		Red = 8'hc0;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h87:
	begin
		Red = 8'he0;
		Green = 8'h0;
		Blue = 8'h80;
	end
8'h88:
	begin
		Red = 8'h0;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h89:
	begin
		Red = 8'h20;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h8a:
	begin
		Red = 8'h40;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h8b:
	begin
		Red = 8'h60;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h8c:
	begin
		Red = 8'h80;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h8d:
	begin
		Red = 8'ha0;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h8e:
	begin
		Red = 8'hc0;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h8f:
	begin
		Red = 8'he0;
		Green = 8'h20;
		Blue = 8'h80;
	end
8'h90:
	begin
		Red = 8'h0;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h91:
	begin
		Red = 8'h20;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h92:
	begin
		Red = 8'h40;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h93:
	begin
		Red = 8'h60;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h94:
	begin
		Red = 8'h80;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h95:
	begin
		Red = 8'ha0;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h96:
	begin
		Red = 8'hc0;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h97:
	begin
		Red = 8'he0;
		Green = 8'h40;
		Blue = 8'h80;
	end
8'h98:
	begin
		Red = 8'h0;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h99:
	begin
		Red = 8'h20;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h9a:
	begin
		Red = 8'h40;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h9b:
	begin
		Red = 8'h60;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h9c:
	begin
		Red = 8'h80;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h9d:
	begin
		Red = 8'ha0;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h9e:
	begin
		Red = 8'hc0;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'h9f:
	begin
		Red = 8'he0;
		Green = 8'h60;
		Blue = 8'h80;
	end
8'ha0:
	begin
		Red = 8'h0;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha1:
	begin
		Red = 8'h20;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha2:
	begin
		Red = 8'h40;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha3:
	begin
		Red = 8'h60;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha4:
	begin
		Red = 8'h80;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha5:
	begin
		Red = 8'ha0;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha6:
	begin
		Red = 8'hc0;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha7:
	begin
		Red = 8'he0;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'ha8:
	begin
		Red = 8'h0;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'ha9:
	begin
		Red = 8'h20;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'haa:
	begin
		Red = 8'h40;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'hab:
	begin
		Red = 8'h60;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'hac:
	begin
		Red = 8'h80;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'had:
	begin
		Red = 8'ha0;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'hae:
	begin
		Red = 8'hc0;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'haf:
	begin
		Red = 8'he0;
		Green = 8'ha0;
		Blue = 8'h80;
	end
8'hb0:
	begin
		Red = 8'h0;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb1:
	begin
		Red = 8'h20;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb2:
	begin
		Red = 8'h40;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb3:
	begin
		Red = 8'h60;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb4:
	begin
		Red = 8'h80;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb5:
	begin
		Red = 8'ha0;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb6:
	begin
		Red = 8'hc0;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb7:
	begin
		Red = 8'he0;
		Green = 8'hc0;
		Blue = 8'h80;
	end
8'hb8:
	begin
		Red = 8'h0;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hb9:
	begin
		Red = 8'h20;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hba:
	begin
		Red = 8'h40;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hbb:
	begin
		Red = 8'h60;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hbc:
	begin
		Red = 8'h80;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hbd:
	begin
		Red = 8'ha0;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hbe:
	begin
		Red = 8'hc0;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hbf:
	begin
		Red = 8'he0;
		Green = 8'he0;
		Blue = 8'h80;
	end
8'hc0:
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc1:
	begin
		Red = 8'h20;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc2:
	begin
		Red = 8'h40;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc3:
	begin
		Red = 8'h60;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc4:
	begin
		Red = 8'h80;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc5:
	begin
		Red = 8'ha0;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc6:
	begin
		Red = 8'hc0;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc7:
	begin
		Red = 8'he0;
		Green = 8'h0;
		Blue = 8'hc0;
	end
8'hc8:
	begin
		Red = 8'h0;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hc9:
	begin
		Red = 8'h20;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hca:
	begin
		Red = 8'h40;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hcb:
	begin
		Red = 8'h60;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hcc:
	begin
		Red = 8'h80;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hcd:
	begin
		Red = 8'ha0;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hce:
	begin
		Red = 8'hc0;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hcf:
	begin
		Red = 8'he0;
		Green = 8'h20;
		Blue = 8'hc0;
	end
8'hd0:
	begin
		Red = 8'h0;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd1:
	begin
		Red = 8'h20;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd2:
	begin
		Red = 8'h40;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd3:
	begin
		Red = 8'h60;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd4:
	begin
		Red = 8'h80;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd5:
	begin
		Red = 8'ha0;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd6:
	begin
		Red = 8'hc0;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd7:
	begin
		Red = 8'he0;
		Green = 8'h40;
		Blue = 8'hc0;
	end
8'hd8:
	begin
		Red = 8'h0;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hd9:
	begin
		Red = 8'h20;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hda:
	begin
		Red = 8'h40;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hdb:
	begin
		Red = 8'h60;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hdc:
	begin
		Red = 8'h80;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hdd:
	begin
		Red = 8'ha0;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hde:
	begin
		Red = 8'hc0;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'hdf:
	begin
		Red = 8'he0;
		Green = 8'h60;
		Blue = 8'hc0;
	end
8'he0:
	begin
		Red = 8'h0;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he1:
	begin
		Red = 8'h20;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he2:
	begin
		Red = 8'h40;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he3:
	begin
		Red = 8'h60;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he4:
	begin
		Red = 8'h80;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he5:
	begin
		Red = 8'ha0;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he6:
	begin
		Red = 8'hc0;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he7:
	begin
		Red = 8'he0;
		Green = 8'h80;
		Blue = 8'hc0;
	end
8'he8:
	begin
		Red = 8'h0;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'he9:
	begin
		Red = 8'h20;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'hea:
	begin
		Red = 8'h40;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'heb:
	begin
		Red = 8'h60;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'hec:
	begin
		Red = 8'h80;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'hed:
	begin
		Red = 8'ha0;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'hee:
	begin
		Red = 8'hc0;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'hef:
	begin
		Red = 8'he0;
		Green = 8'ha0;
		Blue = 8'hc0;
	end
8'hf0:
	begin
		Red = 8'h0;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'hf1:
	begin
		Red = 8'h20;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'hf2:
	begin
		Red = 8'h40;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'hf3:
	begin
		Red = 8'h60;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'hf4:
	begin
		Red = 8'h80;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'hf5:
	begin
		Red = 8'ha0;
		Green = 8'hc0;
		Blue = 8'hc0;
	end
8'hf6:
	begin
		Red = 8'hff;
		Green = 8'hfb;
		Blue = 8'hf0;
	end
8'hf7:
	begin
		Red = 8'ha0;
		Green = 8'ha0;
		Blue = 8'ha4;
	end
8'hf8:
	begin
		Red = 8'h80;
		Green = 8'h80;
		Blue = 8'h80;
	end
8'hf9:
	begin
		Red = 8'hff;
		Green = 8'h0;
		Blue = 8'h0;
	end
8'hfa:
	begin
		Red = 8'h0;
		Green = 8'hff;
		Blue = 8'h0;
	end
8'hfb:
	begin
		Red = 8'hff;
		Green = 8'hff;
		Blue = 8'h0;
	end
8'hfc:
	begin
		Red = 8'h0;
		Green = 8'h0;
		Blue = 8'hff;
	end
8'hfd:
	begin
		Red = 8'hff;
		Green = 8'h0;
		Blue = 8'hff;
	end
8'hfe:
	begin
		Red = 8'h0;
		Green = 8'hff;
		Blue = 8'hff;
	end
8'hff:
	begin
		Red = 8'hff;
		Green = 8'hff;
		Blue = 8'hff;
	end

		endcase
								end
							else if(actualPalette == 2'b00)
								begin
									unique case(bgFrame_output)
		8'h0:
		begin
			Red = 8'h0;
			Green = 8'h0;
			Blue = 8'h0;
		end
	8'h1:
		begin
			Red = 8'h80;
			Green = 8'h0;
			Blue = 8'h0;
		end
	8'h2:
		begin
			Red = 8'h0;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h3:
		begin
			Red = 8'h80;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h4:
		begin
			Red = 8'h0;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h5:
		begin
			Red = 8'h80;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h6:
		begin
			Red = 8'h0;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'h7:
		begin
			Red = 8'hc0;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'h8:
		begin
			Red = 8'hc0;
			Green = 8'hdc;
			Blue = 8'hc0;
		end
	8'h9:
		begin
			Red = 8'ha6;
			Green = 8'hca;
			Blue = 8'hf0;
		end
	8'ha:
		begin
			Red = 8'h40;
			Green = 8'h20;
			Blue = 8'h0;
		end
	8'hb:
		begin
			Red = 8'h60;
			Green = 8'h20;
			Blue = 8'h0;
		end
	8'hc:
		begin
			Red = 8'h80;
			Green = 8'h20;
			Blue = 8'h0;
		end
	8'hd:
		begin
			Red = 8'ha0;
			Green = 8'h20;
			Blue = 8'h0;
		end
	8'he:
		begin
			Red = 8'hc0;
			Green = 8'h20;
			Blue = 8'h0;
		end
	8'hf:
		begin
			Red = 8'he0;
			Green = 8'h20;
			Blue = 8'h0;
		end
	8'h10:
		begin
			Red = 8'h0;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h11:
		begin
			Red = 8'h20;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h12:
		begin
			Red = 8'h40;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h13:
		begin
			Red = 8'h60;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h14:
		begin
			Red = 8'h80;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h15:
		begin
			Red = 8'ha0;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h16:
		begin
			Red = 8'hc0;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h17:
		begin
			Red = 8'he0;
			Green = 8'h40;
			Blue = 8'h0;
		end
	8'h18:
		begin
			Red = 8'h0;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h19:
		begin
			Red = 8'h20;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h1a:
		begin
			Red = 8'h40;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h1b:
		begin
			Red = 8'h60;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h1c:
		begin
			Red = 8'h80;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h1d:
		begin
			Red = 8'ha0;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h1e:
		begin
			Red = 8'hc0;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h1f:
		begin
			Red = 8'he0;
			Green = 8'h60;
			Blue = 8'h0;
		end
	8'h20:
		begin
			Red = 8'h0;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h21:
		begin
			Red = 8'h20;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h22:
		begin
			Red = 8'h40;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h23:
		begin
			Red = 8'h60;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h24:
		begin
			Red = 8'h80;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h25:
		begin
			Red = 8'ha0;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h26:
		begin
			Red = 8'hc0;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h27:
		begin
			Red = 8'he0;
			Green = 8'h80;
			Blue = 8'h0;
		end
	8'h28:
		begin
			Red = 8'h0;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h29:
		begin
			Red = 8'h20;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h2a:
		begin
			Red = 8'h40;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h2b:
		begin
			Red = 8'h60;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h2c:
		begin
			Red = 8'h80;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h2d:
		begin
			Red = 8'ha0;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h2e:
		begin
			Red = 8'hc0;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h2f:
		begin
			Red = 8'he0;
			Green = 8'ha0;
			Blue = 8'h0;
		end
	8'h30:
		begin
			Red = 8'h0;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h31:
		begin
			Red = 8'h20;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h32:
		begin
			Red = 8'h40;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h33:
		begin
			Red = 8'h60;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h34:
		begin
			Red = 8'h80;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h35:
		begin
			Red = 8'ha0;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h36:
		begin
			Red = 8'hc0;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h37:
		begin
			Red = 8'he0;
			Green = 8'hc0;
			Blue = 8'h0;
		end
	8'h38:
		begin
			Red = 8'h0;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h39:
		begin
			Red = 8'h20;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h3a:
		begin
			Red = 8'h40;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h3b:
		begin
			Red = 8'h60;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h3c:
		begin
			Red = 8'h80;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h3d:
		begin
			Red = 8'ha0;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h3e:
		begin
			Red = 8'hc0;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h3f:
		begin
			Red = 8'he0;
			Green = 8'he0;
			Blue = 8'h0;
		end
	8'h40:
		begin
			Red = 8'h0;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h41:
		begin
			Red = 8'h20;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h42:
		begin
			Red = 8'h40;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h43:
		begin
			Red = 8'h60;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h44:
		begin
			Red = 8'h80;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h45:
		begin
			Red = 8'ha0;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h46:
		begin
			Red = 8'hc0;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h47:
		begin
			Red = 8'he0;
			Green = 8'h0;
			Blue = 8'h40;
		end
	8'h48:
		begin
			Red = 8'h0;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h49:
		begin
			Red = 8'h20;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h4a:
		begin
			Red = 8'h40;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h4b:
		begin
			Red = 8'h60;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h4c:
		begin
			Red = 8'h80;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h4d:
		begin
			Red = 8'ha0;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h4e:
		begin
			Red = 8'hc0;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h4f:
		begin
			Red = 8'he0;
			Green = 8'h20;
			Blue = 8'h40;
		end
	8'h50:
		begin
			Red = 8'h0;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h51:
		begin
			Red = 8'h20;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h52:
		begin
			Red = 8'h40;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h53:
		begin
			Red = 8'h60;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h54:
		begin
			Red = 8'h80;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h55:
		begin
			Red = 8'ha0;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h56:
		begin
			Red = 8'hc0;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h57:
		begin
			Red = 8'he0;
			Green = 8'h40;
			Blue = 8'h40;
		end
	8'h58:
		begin
			Red = 8'h0;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h59:
		begin
			Red = 8'h20;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h5a:
		begin
			Red = 8'h40;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h5b:
		begin
			Red = 8'h60;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h5c:
		begin
			Red = 8'h80;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h5d:
		begin
			Red = 8'ha0;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h5e:
		begin
			Red = 8'hc0;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h5f:
		begin
			Red = 8'he0;
			Green = 8'h60;
			Blue = 8'h40;
		end
	8'h60:
		begin
			Red = 8'h0;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h61:
		begin
			Red = 8'h20;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h62:
		begin
			Red = 8'h40;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h63:
		begin
			Red = 8'h60;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h64:
		begin
			Red = 8'h80;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h65:
		begin
			Red = 8'ha0;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h66:
		begin
			Red = 8'hc0;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h67:
		begin
			Red = 8'he0;
			Green = 8'h80;
			Blue = 8'h40;
		end
	8'h68:
		begin
			Red = 8'h0;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h69:
		begin
			Red = 8'h20;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h6a:
		begin
			Red = 8'h40;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h6b:
		begin
			Red = 8'h60;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h6c:
		begin
			Red = 8'h80;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h6d:
		begin
			Red = 8'ha0;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h6e:
		begin
			Red = 8'hc0;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h6f:
		begin
			Red = 8'he0;
			Green = 8'ha0;
			Blue = 8'h40;
		end
	8'h70:
		begin
			Red = 8'h0;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h71:
		begin
			Red = 8'h20;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h72:
		begin
			Red = 8'h40;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h73:
		begin
			Red = 8'h60;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h74:
		begin
			Red = 8'h80;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h75:
		begin
			Red = 8'ha0;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h76:
		begin
			Red = 8'hc0;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h77:
		begin
			Red = 8'he0;
			Green = 8'hc0;
			Blue = 8'h40;
		end
	8'h78:
		begin
			Red = 8'h0;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h79:
		begin
			Red = 8'h20;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h7a:
		begin
			Red = 8'h40;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h7b:
		begin
			Red = 8'h60;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h7c:
		begin
			Red = 8'h80;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h7d:
		begin
			Red = 8'ha0;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h7e:
		begin
			Red = 8'hc0;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h7f:
		begin
			Red = 8'he0;
			Green = 8'he0;
			Blue = 8'h40;
		end
	8'h80:
		begin
			Red = 8'h0;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h81:
		begin
			Red = 8'h20;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h82:
		begin
			Red = 8'h40;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h83:
		begin
			Red = 8'h60;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h84:
		begin
			Red = 8'h80;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h85:
		begin
			Red = 8'ha0;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h86:
		begin
			Red = 8'hc0;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h87:
		begin
			Red = 8'he0;
			Green = 8'h0;
			Blue = 8'h80;
		end
	8'h88:
		begin
			Red = 8'h0;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h89:
		begin
			Red = 8'h20;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h8a:
		begin
			Red = 8'h40;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h8b:
		begin
			Red = 8'h60;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h8c:
		begin
			Red = 8'h80;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h8d:
		begin
			Red = 8'ha0;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h8e:
		begin
			Red = 8'hc0;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h8f:
		begin
			Red = 8'he0;
			Green = 8'h20;
			Blue = 8'h80;
		end
	8'h90:
		begin
			Red = 8'h0;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h91:
		begin
			Red = 8'h20;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h92:
		begin
			Red = 8'h40;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h93:
		begin
			Red = 8'h60;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h94:
		begin
			Red = 8'h80;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h95:
		begin
			Red = 8'ha0;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h96:
		begin
			Red = 8'hc0;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h97:
		begin
			Red = 8'he0;
			Green = 8'h40;
			Blue = 8'h80;
		end
	8'h98:
		begin
			Red = 8'h0;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h99:
		begin
			Red = 8'h20;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h9a:
		begin
			Red = 8'h40;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h9b:
		begin
			Red = 8'h60;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h9c:
		begin
			Red = 8'h80;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h9d:
		begin
			Red = 8'ha0;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h9e:
		begin
			Red = 8'hc0;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'h9f:
		begin
			Red = 8'he0;
			Green = 8'h60;
			Blue = 8'h80;
		end
	8'ha0:
		begin
			Red = 8'h0;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha1:
		begin
			Red = 8'h20;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha2:
		begin
			Red = 8'h40;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha3:
		begin
			Red = 8'h60;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha4:
		begin
			Red = 8'h80;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha5:
		begin
			Red = 8'ha0;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha6:
		begin
			Red = 8'hc0;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha7:
		begin
			Red = 8'he0;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'ha8:
		begin
			Red = 8'h0;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'ha9:
		begin
			Red = 8'h20;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'haa:
		begin
			Red = 8'h40;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'hab:
		begin
			Red = 8'h60;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'hac:
		begin
			Red = 8'h80;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'had:
		begin
			Red = 8'ha0;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'hae:
		begin
			Red = 8'hc0;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'haf:
		begin
			Red = 8'he0;
			Green = 8'ha0;
			Blue = 8'h80;
		end
	8'hb0:
		begin
			Red = 8'h0;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb1:
		begin
			Red = 8'h20;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb2:
		begin
			Red = 8'h40;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb3:
		begin
			Red = 8'h60;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb4:
		begin
			Red = 8'h80;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb5:
		begin
			Red = 8'ha0;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb6:
		begin
			Red = 8'hc0;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb7:
		begin
			Red = 8'he0;
			Green = 8'hc0;
			Blue = 8'h80;
		end
	8'hb8:
		begin
			Red = 8'h0;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hb9:
		begin
			Red = 8'h20;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hba:
		begin
			Red = 8'h40;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hbb:
		begin
			Red = 8'h60;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hbc:
		begin
			Red = 8'h80;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hbd:
		begin
			Red = 8'ha0;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hbe:
		begin
			Red = 8'hc0;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hbf:
		begin
			Red = 8'he0;
			Green = 8'he0;
			Blue = 8'h80;
		end
	8'hc0:
		begin
			Red = 8'h0;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc1:
		begin
			Red = 8'h20;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc2:
		begin
			Red = 8'h40;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc3:
		begin
			Red = 8'h60;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc4:
		begin
			Red = 8'h80;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc5:
		begin
			Red = 8'ha0;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc6:
		begin
			Red = 8'hc0;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc7:
		begin
			Red = 8'he0;
			Green = 8'h0;
			Blue = 8'hc0;
		end
	8'hc8:
		begin
			Red = 8'h0;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hc9:
		begin
			Red = 8'h20;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hca:
		begin
			Red = 8'h40;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hcb:
		begin
			Red = 8'h60;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hcc:
		begin
			Red = 8'h80;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hcd:
		begin
			Red = 8'ha0;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hce:
		begin
			Red = 8'hc0;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hcf:
		begin
			Red = 8'he0;
			Green = 8'h20;
			Blue = 8'hc0;
		end
	8'hd0:
		begin
			Red = 8'h0;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd1:
		begin
			Red = 8'h20;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd2:
		begin
			Red = 8'h40;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd3:
		begin
			Red = 8'h60;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd4:
		begin
			Red = 8'h80;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd5:
		begin
			Red = 8'ha0;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd6:
		begin
			Red = 8'hc0;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd7:
		begin
			Red = 8'he0;
			Green = 8'h40;
			Blue = 8'hc0;
		end
	8'hd8:
		begin
			Red = 8'h0;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hd9:
		begin
			Red = 8'h20;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hda:
		begin
			Red = 8'h40;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hdb:
		begin
			Red = 8'h60;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hdc:
		begin
			Red = 8'h80;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hdd:
		begin
			Red = 8'ha0;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hde:
		begin
			Red = 8'hc0;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'hdf:
		begin
			Red = 8'he0;
			Green = 8'h60;
			Blue = 8'hc0;
		end
	8'he0:
		begin
			Red = 8'h0;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he1:
		begin
			Red = 8'h20;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he2:
		begin
			Red = 8'h40;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he3:
		begin
			Red = 8'h60;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he4:
		begin
			Red = 8'h80;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he5:
		begin
			Red = 8'ha0;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he6:
		begin
			Red = 8'hc0;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he7:
		begin
			Red = 8'he0;
			Green = 8'h80;
			Blue = 8'hc0;
		end
	8'he8:
		begin
			Red = 8'h0;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'he9:
		begin
			Red = 8'h20;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'hea:
		begin
			Red = 8'h40;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'heb:
		begin
			Red = 8'h60;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'hec:
		begin
			Red = 8'h80;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'hed:
		begin
			Red = 8'ha0;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'hee:
		begin
			Red = 8'hc0;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'hef:
		begin
			Red = 8'he0;
			Green = 8'ha0;
			Blue = 8'hc0;
		end
	8'hf0:
		begin
			Red = 8'h0;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'hf1:
		begin
			Red = 8'h20;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'hf2:
		begin
			Red = 8'h40;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'hf3:
		begin
			Red = 8'h60;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'hf4:
		begin
			Red = 8'h80;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'hf5:
		begin
			Red = 8'ha0;
			Green = 8'hc0;
			Blue = 8'hc0;
		end
	8'hf6:
		begin
			Red = 8'hff;
			Green = 8'hfb;
			Blue = 8'hf0;
		end
	8'hf7:
		begin
			Red = 8'ha0;
			Green = 8'ha0;
			Blue = 8'ha4;
		end
	8'hf8:
		begin
			Red = 8'h80;
			Green = 8'h80;
			Blue = 8'h80;
		end
	8'hf9:
		begin
			Red = 8'hff;
			Green = 8'h0;
			Blue = 8'h0;
		end
	8'hfa:
		begin
			Red = 8'h0;
			Green = 8'hff;
			Blue = 8'h0;
		end
	8'hfb:
		begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'h0;
		end
	8'hfc:
		begin
			Red = 8'h0;
			Green = 8'h0;
			Blue = 8'hff;
		end
	8'hfd:
		begin
			Red = 8'hff;
			Green = 8'h0;
			Blue = 8'hff;
		end
	8'hfe:
		begin
			Red = 8'h0;
			Green = 8'hff;
			Blue = 8'hff;
		end
	8'hff:
		begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end


							endcase	
								end
							else
								begin
									Red = 8'h00;
									Green = 8'h00;
									Blue = 8'hff;
								end
						end
					else
						begin
							actualPalette = 2'b00;
							Red = 8'hff;
							Green = 8'hff;
							Blue = 8'hff;
						end	
				end
endmodule

