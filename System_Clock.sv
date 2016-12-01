module system_clock(input clk,
						  input reset,
						  output [19:0] Clk_10
						 );
						
// generate 10 Hz from 50 MHz
logic [22:0] counter;
// reg [19:0] Clk_10 = 0;

always @(posedge clk or posedge reset) 
  begin
    if (reset)
		begin
        counter <= 0;
        Clk_10 <= 0;
		end 
	 else if (Clk_10 > 1000000)
		begin
		  Clk_10 <= 0;
		end
	 else
		begin
        if (counter < 4999999) 
			begin
            counter <= counter + 1;
			end 
		  else 
			begin
            counter <= 0;
            Clk_10 <= Clk_10 + 1;
			end
		  end
  end
endmodule