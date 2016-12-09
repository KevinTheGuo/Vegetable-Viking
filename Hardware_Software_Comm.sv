/*---------------------------------------------------------------------------
						Hardware-Software Communication
  ---------------------------------------------------------------------------*/
// Acts as the module that takes in and sends messages to the CPU


module hardware_software_comm (	input	clk,
											input	reset,
											input[31:0] to_hw_port0, to_hw_port1, to_hw_port2, to_hw_port3, to_hw_port4, to_hw_port5, to_hw_port6, to_hw_port7, to_hw_port8, to_hw_port9, to_hw_port10, to_hw_port11, to_hw_port12, to_hw_port13, to_hw_port14, to_hw_port15,
											input [1:0]  to_hw_sig,
											output [1:0] to_sw_sig,
											output [9:0] xCoord1, xCoord2, xCoord3, xCoord4, xCoord5, xCoord6, xCoord7, xCoord8, xCoord9, xCoord10, xCoord11, xCoord12, xCoord13, xCoord14, xCoord15, yCoord1, yCoord2, yCoord3, yCoord4, yCoord5, yCoord6, yCoord7, yCoord8, yCoord9, yCoord10, yCoord11, yCoord12, yCoord13, yCoord14, yCoord15,
											output [2:0] state1, state2, state3, state4, state5, state6, state7, state8, state9, state10, state11, state12, state13, state14, state15 //, type1, type2, type3, type4, type5, type6, type7, type8, type9, type10, type11, type12, type13, type14, type15
										);
		
		// THIS HANDLES READING/WRITING OF DATA TO HW/SOFTWARE		
	always_latch
	begin
		begin
			if (to_hw_sig == 2'd1) 
				begin
					xCoord1[9:0] = to_hw_port1[9:0];
					xCoord2[9:0] = to_hw_port2[9:0];
					xCoord3[9:0] = to_hw_port3[9:0];
					xCoord4[9:0] = to_hw_port4[9:0];
					xCoord5[9:0] = to_hw_port5[9:0];
					xCoord6[9:0] = to_hw_port6[9:0];
					xCoord7[9:0] = to_hw_port7[9:0];
					xCoord8[9:0] = to_hw_port8[9:0];
					xCoord9[9:0] = to_hw_port9[9:0];
					xCoord10[9:0] = to_hw_port10[9:0];
					xCoord11[9:0] = to_hw_port11[9:0];
					xCoord12[9:0] = to_hw_port12[9:0];
					xCoord13[9:0] = to_hw_port13[9:0];
					xCoord14[9:0] = to_hw_port14[9:0];
					xCoord15[9:0] = to_hw_port15[9:0];
					to_sw_sig = 2'd1;
				end 
			else if (to_hw_sig == 2'd2) 
				begin
					yCoord1[9:0] = 9'd480 - to_hw_port1[9:0];
					yCoord2[9:0] = 9'd480 - to_hw_port2[9:0];
					yCoord3[9:0] = 9'd480 - to_hw_port3[9:0];
					yCoord4[9:0] = 9'd480 - to_hw_port4[9:0];
					yCoord5[9:0] = 9'd480 - to_hw_port5[9:0];
					yCoord6[9:0] = 9'd480 - to_hw_port6[9:0];
					yCoord7[9:0] = 9'd480 - to_hw_port7[9:0];
					yCoord8[9:0] = 9'd480 - to_hw_port8[9:0];
					yCoord9[9:0] = 9'd480 - to_hw_port9[9:0];
					yCoord10[9:0] = 9'd480 - to_hw_port10[9:0];
					yCoord11[9:0] = 9'd480 - to_hw_port11[9:0];
					yCoord12[9:0] = 9'd480 - to_hw_port12[9:0];
					yCoord13[9:0] = 9'd480 - to_hw_port13[9:0];
					yCoord14[9:0] = 9'd480 - to_hw_port14[9:0];
					yCoord15[9:0] = 9'd480 - to_hw_port15[9:0];
					to_sw_sig = 2'd2;
				end
			else if (to_hw_sig == 2'd3) 
				begin
					state1[2:0] = to_hw_port1[2:0];
					state2[2:0] = to_hw_port2[2:0];
					state3[2:0] = to_hw_port3[2:0];
					state4[2:0] = to_hw_port4[2:0];
					state5[2:0] = to_hw_port5[2:0];
					state6[2:0] = to_hw_port6[2:0];
					state7[2:0] = to_hw_port7[2:0];
					state8[2:0] = to_hw_port8[2:0];
					state9[2:0] = to_hw_port9[2:0];
					state10[2:0] = to_hw_port10[2:0];
					state11[2:0] = to_hw_port11[2:0];
					state12[2:0] = to_hw_port12[2:0];
					state13[2:0] = to_hw_port13[2:0];
					state14[2:0] = to_hw_port14[2:0];
					state15[2:0] = to_hw_port15[2:0];
/*					type1[2:0] = to_hw_port1[5:3];
					type2[2:0] = to_hw_port2[5:3];
					type3[2:0] = to_hw_port3[5:3];
					type4[2:0] = to_hw_port4[5:3];
					type5[2:0] = to_hw_port5[5:3];
					type6[2:0] = to_hw_port6[5:3];
					type7[2:0] = to_hw_port7[5:3];
					type8[2:0] = to_hw_port8[5:3];
					type9[2:0] = to_hw_port9[5:3];
					type10[2:0] = to_hw_port10[5:3];
					type11[2:0] = to_hw_port11[5:3];
					type12[2:0] = to_hw_port12[5:3];
					type13[2:0] = to_hw_port13[5:3];
					type14[2:0] = to_hw_port14[5:3];
					type15[2:0] = to_hw_port15[5:3];
*/					// and send done signal!
					to_sw_sig = 2'd3;
				end
			else if (to_hw_sig == 2'd0) 
				begin
					to_sw_sig = 2'd0;		// respond
				end
			end		
		end
		
	
		
	/*	enum logic [3:0] {RESET, WAIT,
								READ_MSG, 
								ACK_MSG} state, next_state;

		
		always @ (posedge clk, posedge reset) begin
		// THIS HANDLES READING/WRITING OF DATA TO HW/SOFTWARE
			if (reset == 1'b1) 
				begin
					state <= RESET;
				end 
			else 
				begin
					state <= next_state;
				end
		end
		
		// THIS DETERMINES THE NEXT STATE
		
		always_comb 
		begin
			next_state = state;
			unique case (state)
				RESET: 
					begin
						next_state = WAIT;
					end
				// in our wait state, constantly check for our next branch
				WAIT: 
					begin
						if (to_hw_sig == 2'd2)
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
		always_comb 
		begin
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
						to_sw_sig = 2'd2;
					end
				// acknowledge the message we read signal
				ACK_MSG: 
					begin
						to_sw_sig = 2'd0;
					end
			endcase
		end
	*/
endmodule
