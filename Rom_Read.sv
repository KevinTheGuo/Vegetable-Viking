module Rom_Read(input clk,
					 input reset,
					 input beginDrawing, // signal to begin the drawing process
					 input [11:0] startROMAddr, // start address in ROM
					 input [9:0] /*change this bit width later*/ startX, // start point X in RAM
					 input [9:0] startY, // start point Y in RAM
					 input [9:0] width, // width of sprite
					 input [9:0] height, // height of sprite 
					 output doneDrawing // signal to output when we finish drawing
					 );
						
					 logic [11:0] counter; 
					 logic [11:0] endCount; // the number of drawing operations that need to take place
					 assign endCount = width * height; // it will take one 8-bit read per pixel, this means it will 
					 enum logic [2:0] {idle, draw} state, next_state;
					 
					 always_ff @ (posedge clk or reset)
						begin
							if(reset)
								state <= idle;
								counter <= 12'd0;
							else
								state <= next_state;
						end
					
					
					// next state logic
					always_comb
						begin
							next_state = state;
							doneDrawing = 1'b0; 
							unique case(state)
								idle:
									if(beginDrawing)
										next_state <= draw;
								draw:
									if(counter == endCount)
										next_state <= idle;
						end
								
							
endmodule