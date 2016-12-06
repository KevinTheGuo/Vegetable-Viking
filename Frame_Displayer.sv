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
			input [7:0] frame_output,		// output from frame buffer (last clock cycle's data)
			input [19:0] sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, sprite9, sprite10, sprite11, sprite12, sprite13, sprite14,
			input [9:0] cursorX,
			input [9:0] cursorY,
			input streakIndicator,
			output logic [18:0] frame_rdAddress,	// read address for frame buffer
			output logic [7:0]  Red, Green, Blue);	// output our RGB values!!!
			
			// create some of our parameters
			 parameter [9:0] ScreenX = 640;     // width of x axis
			 parameter [9:0] ScreenY = 480;     // width of y axis
			
			parameter [19:0] spriteOffset	= 307200;
			parameter [10:0] spriteWidth = 64;
			 
			// Declare and initialize the heights and offsets that will be used in the drawing process
			
			// Broccoli
			parameter [7:0] sprite1Height = 65;
			parameter [1:0] sprite1Offset = 0;
			
			// Eggplant
			parameter [7:0] sprite2Height = 81;
			parameter [14:0] sprite2Offset = 4160; // 65 * 64
			
			// Potatoes
			parameter [7:0] sprite3Height = 85;
			parameter [14:0] sprite3Offset = 9344; // 146 * 64
			
			// Carrot
			parameter [7:0] sprite4Height = 39;
			parameter [14:0] sprite4Offset = 14784; // 231 * 64
			
			// Cabbage
			parameter [7:0] sprite5Height = 66;
			parameter [14:0] sprite5Offset = 17280; // 270 * 64
			
			// Radish
			parameter [7:0] sprite6Height = 64;
			parameter [14:0] sprite6Offset = 21504; // 336 * 64
			
			// Tomato
			parameter [7:0] sprite7Height = 42;
			parameter [14:0] sprite7Offset = 25600; // 400 * 64
			
			// Onion
			parameter [7:0] sprite8Height = 69;
			parameter [14:0] sprite8Offset = 28288; // 442 * 64
			
			parameter [2:0] positionMultiplier = 5;
			
			
			// spriteX[19:17] ===> sprite state (if it's 0, it doesn't exist yet)
			// spriteX[13:7]  ===> xPos
			// spriteX[6:0]   ===> yPos
			
			logic [1:0] palette; // 0 for background palette, 1 for vegetable sprite palette
			
			always_ff @ (posedge pixel_clk)
					begin
						if(Display)
							begin
							if((sprite1[19:17] != 3'b0) // Sprite 1
								&& (DrawX >= (sprite1[6: 0] * positionMultiplier)) 
								&& (DrawX < ((sprite1[6: 0] * positionMultiplier) + spriteWidth)) 
								&& (DrawY >= (sprite1[13:7] * positionMultiplier))
								&& (DrawY < ((sprite1[13:7] * positionMultiplier) + sprite1Height)))
								begin
									frame_rdAddress = spriteOffset + sprite1Offset 
									+ (DrawX - (sprite1[6: 0] * positionMultiplier)) + ((DrawY - (sprite1[13:7] * positionMultiplier)) * spriteWidth);
									palette = 2'b01;
								end
							else if((sprite2[19:17] != 3'b0) // Sprite 2
								&& (DrawX >= (sprite2[6: 0] * positionMultiplier)) 
								&& (DrawX < ((sprite2[6: 0] * positionMultiplier) + spriteWidth)) 
								&& (DrawY >= (sprite2[13:7] * positionMultiplier))
								&& (DrawY < ((sprite2[13:7] * positionMultiplier) + sprite2Height)))
								begin
									frame_rdAddress = spriteOffset + sprite2Offset 
									+ (DrawX - (sprite2[6:0] * positionMultiplier)) + ((DrawY - (sprite2[13:7] * positionMultiplier)) * spriteWidth);
									palette = 2'b01;
								end
							else if((sprite3[19:17] != 3'b0) // Sprite 3
								&& (DrawX >= (sprite3[6: 0] * positionMultiplier)) 
								&& (DrawX < ((sprite3[6: 0] * positionMultiplier) + spriteWidth)) 
								&& (DrawY >= (sprite3[13:7] * positionMultiplier))
								&& (DrawY < ((sprite3[13:7] * positionMultiplier) + sprite3Height)))
								begin
									frame_rdAddress = spriteOffset + sprite3Offset 
									+ (DrawX - (sprite3[6: 0] * positionMultiplier)) + ((DrawY - (sprite3[13:7] * positionMultiplier)) * spriteWidth);
									palette = 2'b01;
								end
							else if((sprite4[19:17] != 3'b0) // Sprite 4
								&& (DrawX >= (sprite4[6: 0] * positionMultiplier)) 
								&& (DrawX < ((sprite4[6: 0] * positionMultiplier) + spriteWidth)) 
								&& (DrawY >= (sprite4[13:7] * positionMultiplier))
								&& (DrawY < ((sprite4[13:7] * positionMultiplier) + sprite4Height)))
								begin
									frame_rdAddress = spriteOffset + sprite4Offset 
									+ (DrawX - (sprite4[6: 0] * positionMultiplier)) + ((DrawY - (sprite4[13:7] * positionMultiplier)) * spriteWidth);
									palette = 2'b01;
								end
							else if((sprite5[19:17] != 3'b0) // Sprite 5
								&& (DrawX >= (sprite5[6: 0] * positionMultiplier)) 
								&& (DrawX < ((sprite5[6: 0] * positionMultiplier) + spriteWidth)) 
								&& (DrawY >= (sprite5[13:7] * positionMultiplier))
								&& (DrawY < ((sprite5[13:7] * positionMultiplier) + sprite5Height)))
								begin
									frame_rdAddress = spriteOffset + sprite5Offset 
									+ (DrawX - (sprite5[6: 0] * positionMultiplier)) + ((DrawY - (sprite5[13:7] * positionMultiplier)) * spriteWidth);
									palette = 2'b01;
								end
							else if((sprite6[19:17] != 3'b0) // Sprite 6
								&& (DrawX >= (sprite6[6: 0] * positionMultiplier)) 
								&& (DrawX < ((sprite6[6: 0] * positionMultiplier) + spriteWidth)) 
								&& (DrawY >= (sprite6[13:7] * positionMultiplier))
								&& (DrawY < ((sprite6[13:7] * positionMultiplier) + sprite6Height)))
								begin
									frame_rdAddress = spriteOffset + sprite6Offset 
									+ (DrawX - (sprite6[6: 0] * positionMultiplier)) + ((DrawY - (sprite6[13:7] * positionMultiplier)) * spriteWidth);
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
							end
					end
			
			// now we can take our frame output and do some palette magic!
			always_comb
				begin 
					if(Display)
						begin	
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
							else if(palette == 2'b01)
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
							else if(palette == 2'b00)
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
							else
								begin
									Red = 8'h00;
									Green = 8'h00;
									Blue = 8'hff;
								end
						end
					else
						begin
							Red = 8'hff;
							Green = 8'hff;
							Blue = 8'hff;
						end	
				end
endmodule

