/*---------------------------------------------------------------------------
						Hardware-Software Communication
  ---------------------------------------------------------------------------*/
// Acts as the module that takes in and sends messages to the CPU


module hardware_software_comm (	input	clk,
											input	reset,
											input [1:0]  to_hw_sig,
						//					input [7:0]  to_hw_port0, to_hw_port1, to_hw_port2, to_hw_port3, to_hw_port4, to_hw_port5, to_hw_port6, to_hw_port7, to_hw_port8, to_hw_port9,
										
											output logic [1:0]  	to_sw_sig
	//										output logic [1:0]	
										);
		
		enum logic [6:0] {RESET, WAIT,
								READ_MSG, 
								ACK_MSG} state, next_state;

		
		always @ (posedge clk, posedge reset) begin
		// THIS HANDLES READING/WRITING OF DATA TO HW/SOFTWARE
			if (reset == 1'b1) begin
				state <= RESET;
			end 
		end
		
		
		
		// THIS DETERMINES THE NEXT STATE
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					next_state = WAIT;
				end
				
				// in our wait state, constantly check for our next branch
				WAIT: 
					begin
						if (to_hw_sig == 2'd3)
							next_state = READ_MSG;
					end
				
				// read message state changer
				READ_MSG: 
					begin
						if (to_hw_sig == 2'd1)
							next_state = ACK_MSG;
					end		
				
				//acknowledge message state change
				ACK_MSG: 
					begin
						if (to_hw_sig == 2'd0)
							next_state = WAIT;
					end
			endcase
		end
		
		
		// software signal state sender
		always_comb begin
			to_sw_sig = 2'd0;
			unique case (state)
				// reset case signal
				RESET: 
					begin
						to_sw_sig = 2'd0;
					end
			
				// wait state signal
				WAIT: 
					begin
						to_sw_sig = 2'd0;
					end
				
				// reading message signal
				READ_MSG: 
					begin
						to_sw_sig = 2'd3;
					end
				
				// acknowledge the message we read signal
				ACK_MSG: 
					begin
						to_sw_sig = 2'd0;
					end
			endcase
		end
	
endmodule
