/*---------------------------------------------------------------------------
						Arduino-FPGA Communication
  ---------------------------------------------------------------------------*/
// Acts as the module that takes in arduino input and sends it to the FPGA and CPU

module arduino_fpga_comm (	input	clk,
									input	reset,
									input [35:0] GPIO,
									output [10:0] xCoordinate,
									output [10:0] yCoordinate
								  );
								  
		// hehe, we're just gonna skip the reset functionality
		
		always @ (posedge GPIO[10]) 	// POSEDGE(1) MEANS Y HAS JUST FINISHED
			begin		
				yCoordinate = GPIO[9:0];
			end
	
		always @ (negedge GPIO[10]) 	// NEGEDGE(0) MEANS X HAS JUST FINISHED
			begin		
				xCoordinate = GPIO[9:0];
			end

endmodule