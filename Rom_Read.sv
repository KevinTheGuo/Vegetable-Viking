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
					 
					assign Mem_CE = 1'b0; // Always keep it on
					assign Mem_UB = 1'b0;
					assign Mem_LB = 1'b1; // Depending on how we store data, we'll use one of these two bytes. Probably.
					assign Mem_WE = 1'b1; // we are never writing into ROM
					 
					 always_ff @ (posedge clk or reset)
						begin
							if(reset)
								begin
								state <= idle;
								counter <= 12'd0;
								end
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
							endcase
						end
					
					// what to do in each state
					always_comb
						begin
							
						end
								
endmodule


module tristate #(N = 16) (
	input wire Clk, OE,
	input [N-1:0] In,
	output logic [N-1:0] Out,
	inout wire [N-1:0] Data
);

logic [N-1:0] a, b;

assign Data = OE ? a : {N{1'bZ}};
assign Out = b;

always_ff @(posedge Clk)
begin
	b <= Data;
	a <= In;
end

endmodule