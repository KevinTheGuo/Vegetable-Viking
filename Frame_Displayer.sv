module frame_displayer
(
			input Clk, 
			input pixel_clk, 
			input reset, 
	//		input [32:0] drawingCode,		// this is for when we get hardware-software comms
			input [9:0] DrawX, DrawY, 	// our current coordinate
			input [7:0] frame_output,		// output from frame buffer (last clock cycle's data)
			
			output [18:0] frame_rdAddress,	// read address for frame buffer
			output [7:0]  Red, Green, Blue);	// output our RGB values!!!
			
			// create some of our parameters
    parameter [9:0] ScreenX = 10'd640;     // width of x axis
    parameter [9:0] ScreenY = 10'd480;     // width of y axis
			

			// we split up our frame display into two parts, a memory fetcher and VGA displayer
			
			// this takes our drawx and drawy and, if they're valid, sends a frame read address
			always_ff @ (posedge pixel_clk)
					begin
						if((DrawX < ScreenX) && (DrawY < ScreenY))
							frame_rdAddress = (DrawX + (DrawY*ScreenX));
						else
							frame_rdAddress = 19'h00000;
					end
			
			// now we can take our frame output and do some palette magic!
			always_comb
				begin 
					if((DrawX < ScreenX) && (DrawY < ScreenY))
						begin	
							unique case(frame_output)
							8'h00:
								begin
									Red = 8'h0;
									Green = 8'h0;
									Blue = 8'h0;
								end
							8'h01:
								begin
									Red = 8'h80;
									Green = 8'h0;
									Blue = 8'h0;
								end
							8'h02:
								begin
									Red = 8'h0;
									Green = 8'h80;
									Blue = 8'h0;
								end
							8'h03:
								begin
									Red = 8'h80;
									Green = 8'h80;
									Blue = 8'h0;
								end
							8'h04:
								begin
									Red = 8'h0;
									Green = 8'h0;
									Blue = 8'h80;
								end
							8'h05:
								begin
									Red = 8'h80;
									Green = 8'h0;
									Blue = 8'h80;
								end
							8'h06:
								begin
									Red = 8'h0;
									Green = 8'h80;
									Blue = 8'h80;
								end
							8'h07:
								begin
									Red = 8'hc0;
									Green = 8'hc0;
									Blue = 8'hc0;
								end
							8'h08:
								begin
									Red = 8'hc0;
									Green = 8'hdc;
									Blue = 8'hc0;
								end
							8'h09:
								begin
									Red = 8'ha6;
									Green = 8'hca;
									Blue = 8'hf0;
								end
							8'h0a:
								begin
									Red = 8'h40;
									Green = 8'h20;
									Blue = 8'h0;
								end
							8'h0b:
								begin
									Red = 8'h60;
									Green = 8'h20;
									Blue = 8'h0;
								end
							8'h0c:
								begin
									Red = 8'h80;
									Green = 8'h20;
									Blue = 8'h0;
								end
							8'h0d:
								begin
									Red = 8'ha0;
									Green = 8'h20;
									Blue = 8'h0;
								end
							8'h0e:
								begin
									Red = 8'hc0;
									Green = 8'h20;
									Blue = 8'h0;
								end
							8'h0f:
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
							default:
								begin
									Red = 8'h00;
									Green = 8'hff;
									Blue = 8'hff;
								end	
						endcase	
					end
					else
						begin
							Red = 8'h00;
							Green = 8'hff;
							Blue = 8'hff;
						end	
				end
endmodule

