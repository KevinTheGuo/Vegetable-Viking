module frame_displayer
(
			input Clk, 
			input pixel_clk, 
			input reset, 
	//		input [32:0] drawingCode,		// this is for when we get hardware-software comms
			input DrawX, DrawY, 	// our current coordinate
			input [7:0] frame_output,		// output from frame buffer (last clock cycle's data)
			
			output [18:0] frame_rdAddress,	// read address for frame buffer
			output [7:0]  Red, Green, Blue);	// output our RGB values!!!
			
			// create some of our parameters
    parameter [9:0] ScreenX=639;     // Rightmost point on the X axis
    parameter [9:0] ScreenY=479;     // Bottommost point on the Y axis
			

			// we split up our frame display into two parts, a memory fetcher and VGA displayer
			
			// this takes our drawx and drawy and, if they're valid, sends a frame read address
			always_ff @ (posedge Clk)
					begin
						if((DrawX <= ScreenX) && (DrawY <= ScreenY))
							frame_rdAddress <= (DrawX + (DrawY*ScreenX));
					end
			
			// now we can take our frame output and do some palette magic!
			always_ff @ (posedge Clk)
					begin 
						if((DrawX <= ScreenX) && (DrawY <= ScreenY))
							begin
								// palette magic!!!
							end
					end
)

