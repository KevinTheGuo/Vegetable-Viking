module Frame_Buffer
(
		input Clk,
		input [7:0] data_In,
		input [18:0] write_address, read_address,
		input we,

		output logic [7:0] data_Out
);

logic [7:0] mem [307200:0]; 		// make our frame buffer!!!


initial
begin
	 $readmemh("pixel_OCM.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule