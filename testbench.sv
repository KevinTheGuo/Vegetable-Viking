module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
  // VGA Interface 
logic  [3:0]  KEY; //bit 0 is set up as Reset
logic [7:0]  VGA_R,					//VGA Red
 VGA_G,					//VGA Green
 VGA_B;				//VGA Blue
logic        VGA_CLK,				//VGA Clock
 VGA_SYNC_N,			//VGA Sync signal
 VGA_BLANK_N,			//VGA Blank signal
 VGA_VS,					//VGA virtical sync signal	
 VGA_HS;
logic [6:0]  HEX0, HEX1;
logic CLOCK_50;


/*input pixel_CLOCK_50;

//		input [32:0] drawingCode,		// this is for when we get hardware-software comms
input [9:0] DrawX, DrawY; 	// our current coordinate
input [7:0] frame_output;		// output from frame buffer (last clock cycle's data)
output [18:0] frame_rdAddress;	// read address for frame buffer
output [7:0]  Red, Green, Blue;*/

// To store expected results
//logic [3:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;

logic Reset;
assign KEY[0] = ~Reset;
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
VeggieVik dut(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin: CLOCK_INITIALIZATION
    CLOCK_50 = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
	#1 Reset = 1;		// Toggle Rest
	#1 Reset = 0;



end
endmodule
