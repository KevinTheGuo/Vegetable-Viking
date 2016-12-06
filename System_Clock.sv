module system_clock(input clk,
						  input reset,
						  output [19:0] Clk_100
						 );
						
// generate 100 Hz from 50 MHz
logic [19:0] counter;
// reg [19:0] Clk_100 = 0;

always @(posedge clk or posedge reset) 
  begin
    if (reset)
		begin
        counter <= 0;
        Clk_100 <= 0;
		end 
	 else if (Clk_100 > 1000000)
		begin
		  Clk_100 <= 0;
		end
	 else
		begin
        if (counter < 499999) 
			begin
            counter <= counter + 1;
			end 
		  else 
			begin
            counter <= 0;
            Clk_100 <= Clk_100 + 1;
			end
		  end
  end
endmodule