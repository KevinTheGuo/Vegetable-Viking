//-------------------------------------------------------------------------
//      test_memory.vhd                                                  --
//      Stephen Kempf                                                    --
//      Summer 2005                                                      --
//                                                                       --
//      Revised 3-15-2006                                                --
//              3-22-2007                                                --
//              7-26-2013                                                --
//                                                                       --
//      For use with ECE 385 Experment 6                                 --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

// This memory has similar behavior to the SRAM IC on the DE2 board.  This
// file should be used for simulations only.  In simulation, this memory is
// guaranteed to work at least as well as the actual memory (that is, the
// actual memory may require more careful treatment than this test memory).

// To use, you should create a seperate top-level entity for simulation
// that connects this memory module to your computer.  You can create this
// extra entity either in the same project (temporarily setting it to be the
// top module) or in a new one, and create a new vector waveform file for it.

module test_memory ( input 			Clk,
					 input          Reset, 
                     output  logic [7:0]  Out,
                     input  [7:0]  A);
												
   //parameter size = 256; // expand memory as needed (current is 64 words)
	 
   logic [7:0] mem_array [400:0];
	
   logic [7:0] mem_out;
	 
   assign mem_out = mem_array[A[7:0]];  
	
   always_ff @(posedge Clk or posedge Reset)
   begin
		Out = mem_out[7:0];
   end
	  
   always_ff @ (posedge Clk or posedge Reset)
   begin
		if(Reset)   // Insert initial memory contents here
		begin
			mem_array[0] <= 8'h00;
			mem_array[1] <= 8'h00;
			mem_array[2] <= 8'h00;
			mem_array[3] <= 8'h49;
			mem_array[4] <= 8'h49;
			mem_array[5] <= 8'h00;
			mem_array[6] <= 8'h00;
			mem_array[7] <= 8'h00;
			mem_array[8] <= 8'h00;
			mem_array[9] <= 8'h00;
			mem_array[10] <= 8'h00;
			mem_array[11] <= 8'h00;
			mem_array[12] <= 8'h00;
			mem_array[13] <= 8'h00;
			mem_array[14] <= 8'h00;
			mem_array[15] <= 8'h00;
			mem_array[16] <= 8'h00;
			mem_array[17] <= 8'h00;
			mem_array[18] <= 8'h00;
			mem_array[19] <= 8'h00;
			mem_array[20] <= 8'h00;
			mem_array[21] <= 8'h00;
			mem_array[22] <= 8'h00;
			mem_array[23] <= 8'h00;
			mem_array[24] <= 8'h00;
			mem_array[25] <= 8'h00;
			mem_array[26] <= 8'h00;
			mem_array[27] <= 8'h00;
			mem_array[28] <= 8'h00;
			mem_array[29] <= 8'h00;
			mem_array[30] <= 8'h00;
			mem_array[31] <= 8'h00;
			mem_array[32] <= 8'h00;
			mem_array[33] <= 8'h00;
			mem_array[34] <= 8'h00;
			mem_array[35] <= 8'h49;
			mem_array[36] <= 8'h49;
			mem_array[37] <= 8'h49;
			mem_array[38] <= 8'h49;
			mem_array[39] <= 8'h52;
			mem_array[40] <= 8'h52;
			mem_array[41] <= 8'h52;
			mem_array[42] <= 8'h49;
			mem_array[43] <= 8'h00;
			mem_array[44] <= 8'h00;
			mem_array[45] <= 8'h00;
			mem_array[46] <= 8'h00;
			mem_array[47] <= 8'h00;
			mem_array[48] <= 8'h00;
			mem_array[49] <= 8'h00;
			mem_array[50] <= 8'h00;
			mem_array[51] <= 8'h00;
			mem_array[52] <= 8'h00;
			mem_array[53] <= 8'h00;
			mem_array[54] <= 8'h00;
			mem_array[55] <= 8'h00;
			mem_array[56] <= 8'h00;
			mem_array[57] <= 8'h00;
			mem_array[58] <= 8'h00;
			mem_array[59] <= 8'h00;
			mem_array[60] <= 8'h00;
			mem_array[61] <= 8'h00;
			mem_array[62] <= 8'h00;
			mem_array[63] <= 8'h00;
			mem_array[64] <= 8'h00;
			mem_array[65] <= 8'h00;
			mem_array[66] <= 8'h00;
			mem_array[67] <= 8'h00;
			mem_array[68] <= 8'h00;
			mem_array[69] <= 8'h00;
			mem_array[70] <= 8'h00;
			mem_array[71] <= 8'h00;
			mem_array[72] <= 8'h00;
			mem_array[73] <= 8'h00;
			mem_array[74] <= 8'h00;
			mem_array[75] <= 8'h00;
			mem_array[76] <= 8'h00;
			mem_array[77] <= 8'h00;
			mem_array[78] <= 8'h00;
			mem_array[79] <= 8'h00;
			mem_array[80] <= 8'h00;
			mem_array[81] <= 8'h41;
			mem_array[82] <= 8'h41;
			mem_array[83] <= 8'h00;
			mem_array[84] <= 8'h00;
			mem_array[85] <= 8'h00;
			mem_array[86] <= 8'h00;
			mem_array[87] <= 8'h00;
			mem_array[88] <= 8'h0a;
			mem_array[89] <= 8'h0a;
			mem_array[90] <= 8'h49;
			mem_array[91] <= 8'h49;
			mem_array[92] <= 8'h4a;
			mem_array[93] <= 8'h4a;
			mem_array[94] <= 8'h49;
			mem_array[95] <= 8'h40;
			mem_array[96] <= 8'h00;
			mem_array[97] <= 8'h48;
			mem_array[98] <= 8'h49;
			mem_array[99] <= 8'h40;
			mem_array[100] <= 8'h00;
			mem_array[101] <= 8'h40;
			mem_array[102] <= 8'h40;
			mem_array[103] <= 8'h41;
			mem_array[104] <= 8'h00;
			mem_array[105] <= 8'h49;
			mem_array[106] <= 8'h49;
			mem_array[107] <= 8'h49;
			mem_array[108] <= 8'h49;
			mem_array[109] <= 8'h49;
			mem_array[110] <= 8'h49;
			mem_array[111] <= 8'h49;
			mem_array[112] <= 8'h49;
			mem_array[113] <= 8'h49;
			mem_array[114] <= 8'h49;
			mem_array[115] <= 8'h49;
			mem_array[116] <= 8'h49;
			mem_array[117] <= 8'h49;
			mem_array[118] <= 8'h49;
			mem_array[119] <= 8'h52;
			mem_array[120] <= 8'h52;
			mem_array[121] <= 8'h49;
			mem_array[122] <= 8'h49;
			mem_array[123] <= 8'h52;
			mem_array[124] <= 8'h52;
			mem_array[125] <= 8'h49;
			mem_array[126] <= 8'h49;
			mem_array[127] <= 8'h89;
			mem_array[128] <= 8'h89;
			mem_array[129] <= 8'h91;
			mem_array[130] <= 8'h91;
			mem_array[131] <= 8'h91;
			mem_array[133] <= 8'hd9;
			mem_array[134] <= 8'hd9;
			mem_array[135] <= 8'hd9;
			mem_array[136] <= 8'hd9;
			mem_array[137] <= 8'hd9;
			mem_array[138] <= 8'hd9;
			mem_array[139] <= 8'hd9;
			mem_array[140] <= 8'hd9;
			mem_array[141] <= 8'hd9;
			mem_array[142] <= 8'hd9;
			mem_array[143] <= 8'hd9;
			mem_array[144] <= 8'hd9;
			mem_array[145] <= 8'hd9;
			mem_array[146] <= 8'hd9;
			mem_array[147] <= 8'hd9;
			mem_array[148] <= 8'hd9;
			mem_array[149] <= 8'hd9;
			mem_array[150] <= 8'hd9;
			mem_array[151] <= 8'hd9;
			mem_array[152] <= 8'hd9;
			mem_array[153] <= 8'hd9;
			mem_array[154] <= 8'hd9;
			mem_array[155] <= 8'hd9;
			mem_array[156] <= 8'hd9;
			mem_array[157] <= 8'hd9;
			mem_array[158] <= 8'hd9;
			mem_array[159] <= 8'hd9;
			mem_array[160] <= 8'hd9;
			mem_array[161] <= 8'hd9;
			mem_array[162] <= 8'hd9;
			mem_array[163] <= 8'hd9;
			mem_array[164] <= 8'hd9;
			mem_array[165] <= 8'hd9;
			mem_array[166] <= 8'hd9;
			mem_array[167] <= 8'hd9;
			mem_array[168] <= 8'hd9;
			mem_array[169] <= 8'hd9;
			mem_array[170] <= 8'hd9;
			mem_array[171] <= 8'hd9;
			mem_array[172] <= 8'hd9;
			mem_array[173] <= 8'hd9;
			mem_array[174] <= 8'hd9;
			mem_array[175] <= 8'hd9;
			mem_array[176] <= 8'hd9;
			mem_array[177] <= 8'hd9;
			mem_array[178] <= 8'hd9;
			mem_array[179] <= 8'hd9;
			mem_array[180] <= 8'hd9;
			mem_array[181] <= 8'hd9;
			mem_array[182] <= 8'hd9;
			mem_array[183] <= 8'hd9;
			mem_array[184] <= 8'hd9;
			mem_array[185] <= 8'hd9;
			mem_array[186] <= 8'hd9;
			mem_array[187] <= 8'hd9;
			mem_array[188] <= 8'hd9;
			mem_array[189] <= 8'hd9;
			mem_array[190] <= 8'hd9;
			mem_array[191] <= 8'hd9;
			mem_array[192] <= 8'hd9;
			mem_array[193] <= 8'hd9;
			mem_array[194] <= 8'hd9;
			mem_array[195] <= 8'hd9;
			mem_array[196] <= 8'hd9;
			mem_array[197] <= 8'hd9;
			mem_array[198] <= 8'hd9;
			mem_array[199] <= 8'hd9;
			mem_array[200] <= 8'hd9;
			mem_array[201] <= 8'hd9;
			mem_array[202] <= 8'hd9;
			mem_array[203] <= 8'hd9;
			mem_array[204] <= 8'hd9;
			mem_array[205] <= 8'hd9;
			mem_array[206] <= 8'hd9;
			mem_array[207] <= 8'hd9;
			mem_array[208] <= 8'hd9;
			mem_array[209] <= 8'hd9;
			mem_array[210] <= 8'hd9;
			mem_array[211] <= 8'hd9;
			mem_array[212] <= 8'hd9;
			mem_array[213] <= 8'hd9;
			mem_array[214] <= 8'hd9;
			mem_array[215] <= 8'hd9;
			mem_array[216] <= 8'hd9;
			mem_array[217] <= 8'hd9;
			mem_array[218] <= 8'hd9;
			mem_array[219] <= 8'hd9;
			mem_array[220] <= 8'hd9;
			mem_array[221] <= 8'hd9;
			mem_array[222] <= 8'hd9;
			mem_array[223] <= 8'hd9;
			mem_array[224] <= 8'hd9;
			mem_array[225] <= 8'hd9;
			mem_array[226] <= 8'hd9;
			mem_array[227] <= 8'hd9;
			mem_array[228] <= 8'hd9;
			mem_array[229] <= 8'hd9;
			mem_array[230] <= 8'hd9;
			mem_array[231] <= 8'hd9;
			mem_array[232] <= 8'hd9;
			mem_array[233] <= 8'hd9;
			mem_array[234] <= 8'hd9;
			mem_array[235] <= 8'hd9;
			mem_array[236] <= 8'hd9;
			mem_array[237] <= 8'hd9;
			mem_array[238] <= 8'hd9;
			mem_array[239] <= 8'hd9;
			mem_array[240] <= 8'hd9;
			mem_array[241] <= 8'hd9;
			mem_array[242] <= 8'hd9;
			mem_array[243] <= 8'hd9;
			mem_array[244] <= 8'hd9;
			mem_array[245] <= 8'hd9;
			mem_array[246] <= 8'hd9;
			mem_array[247] <= 8'hd9;
			mem_array[248] <= 8'hd9;
			mem_array[249] <= 8'hd9;
			mem_array[250] <= 8'hd9;
			mem_array[251] <= 8'hd9;
			mem_array[252] <= 8'hd9;
			mem_array[253] <= 8'hd9;
			mem_array[254] <= 8'hd9;
			mem_array[255] <= 8'hd9;
			mem_array[256] <= 8'hd9;
			mem_array[257] <= 8'hd9;
			mem_array[258] <= 8'hd9;
			mem_array[259] <= 8'hd9;
			mem_array[260] <= 8'hd9;
			mem_array[261] <= 8'hd9;
			mem_array[262] <= 8'hd9;
			mem_array[263] <= 8'hd9;
			mem_array[264] <= 8'hd9;
			mem_array[265] <= 8'hd9;
			mem_array[266] <= 8'hd9;
			mem_array[267] <= 8'hda;
			mem_array[268] <= 8'hda;
			mem_array[269] <= 8'hda;
			mem_array[270] <= 8'hda;
			mem_array[271] <= 8'hda;
			mem_array[272] <= 8'hda;
			mem_array[273] <= 8'hda;
			mem_array[274] <= 8'hda;
			mem_array[275] <= 8'hda;
			mem_array[276] <= 8'hda;
			mem_array[277] <= 8'hda;
			mem_array[278] <= 8'hda;
			mem_array[279] <= 8'hda;
			mem_array[280] <= 8'hda;
			mem_array[281] <= 8'hda;
			mem_array[282] <= 8'hda;
			mem_array[283] <= 8'hda;
			mem_array[284] <= 8'hda;
			mem_array[285] <= 8'hda;
			mem_array[286] <= 8'hda;
			mem_array[287] <= 8'he2;
			mem_array[288] <= 8'hda;
			mem_array[289] <= 8'he2;
			mem_array[290] <= 8'he2;
			mem_array[291] <= 8'he2;
			mem_array[292] <= 8'he2;
			mem_array[293] <= 8'he2;
			mem_array[294] <= 8'he2;
			mem_array[295] <= 8'he2;
			mem_array[296] <= 8'he2;
			mem_array[297] <= 8'he2;
			mem_array[298] <= 8'he2;
			mem_array[299] <= 8'he2;
			mem_array[300] <= 8'he2;
			mem_array[301] <= 8'he2;
			mem_array[302] <= 8'he2;
			mem_array[303] <= 8'he2;
			mem_array[304] <= 8'he2;
			mem_array[305] <= 8'he2;
			mem_array[306] <= 8'he2;
			mem_array[307] <= 8'he2;
			mem_array[308] <= 8'he2;
			mem_array[309] <= 8'he2;
			mem_array[310] <= 8'he2;
			mem_array[311] <= 8'he2;
			mem_array[312] <= 8'he2;
			mem_array[313] <= 8'he2;
			mem_array[314] <= 8'he2;
			mem_array[315] <= 8'he2;
			mem_array[316] <= 8'he2;
			mem_array[317] <= 8'he2;
			mem_array[318] <= 8'he2;
			mem_array[319] <= 8'he2;
			mem_array[320] <= 8'he2;
			mem_array[321] <= 8'he2;
			mem_array[322] <= 8'he2;
			mem_array[323] <= 8'he2;
			mem_array[324] <= 8'he2;
			mem_array[325] <= 8'he2;
			mem_array[326] <= 8'he2;
			mem_array[327] <= 8'he2;
			mem_array[328] <= 8'he2;
			mem_array[329] <= 8'he2;
			mem_array[330] <= 8'he2;
			mem_array[331] <= 8'he2;
			mem_array[332] <= 8'he2;
			mem_array[333] <= 8'he2;
			mem_array[334] <= 8'he2;
			mem_array[335] <= 8'he2;
			mem_array[336] <= 8'he2;
			mem_array[337] <= 8'he2;
			mem_array[338] <= 8'he2;
			mem_array[339] <= 8'he2;
			mem_array[340] <= 8'he2;
			mem_array[341] <= 8'he2;
			mem_array[342] <= 8'he2;
			mem_array[343] <= 8'he2;
			mem_array[344] <= 8'he2;
			mem_array[345] <= 8'he2;
			mem_array[346] <= 8'he2;
			mem_array[347] <= 8'he2;
			mem_array[348] <= 8'he2;
			mem_array[349] <= 8'he2;
			mem_array[350] <= 8'he2;
			mem_array[351] <= 8'he2;
			mem_array[352] <= 8'he2;
			mem_array[353] <= 8'he2;
			mem_array[354] <= 8'he2;
			mem_array[355] <= 8'he2;
			mem_array[356] <= 8'he2;
			mem_array[357] <= 8'he2;
			mem_array[358] <= 8'he2;
			mem_array[359] <= 8'he2;
			mem_array[360] <= 8'he2;
			mem_array[361] <= 8'he2;
			mem_array[362] <= 8'he2;
			mem_array[363] <= 8'he2;
			mem_array[364] <= 8'he2;
			mem_array[365] <= 8'he2;
			mem_array[366] <= 8'he2;
			mem_array[367] <= 8'he2;
			mem_array[368] <= 8'he2;
			mem_array[369] <= 8'he2;
			mem_array[370] <= 8'he2;
			mem_array[371] <= 8'he2;
			mem_array[372] <= 8'he2;
			mem_array[373] <= 8'he2;
			mem_array[374] <= 8'he2;
			mem_array[375] <= 8'he2;
			mem_array[376] <= 8'he2;
			mem_array[377] <= 8'he2;
			mem_array[378] <= 8'he2;
			mem_array[379] <= 8'he2;
			mem_array[380] <= 8'he2;
			mem_array[381] <= 8'he2;
			mem_array[382] <= 8'he2;
			mem_array[383] <= 8'he2;
			mem_array[384] <= 8'he3;
			mem_array[385] <= 8'he3;
			mem_array[386] <= 8'he3;
			mem_array[387] <= 8'he3;
			mem_array[388] <= 8'he3;
			mem_array[389] <= 8'he3;
			mem_array[390] <= 8'he3;
			mem_array[391] <= 8'he3;
			mem_array[392] <= 8'he3;
			mem_array[393] <= 8'he3;
			mem_array[394] <= 8'he3;
			mem_array[395] <= 8'he3;
			mem_array[396] <= 8'he3;
			mem_array[397] <= 8'he3;
			mem_array[398] <= 8'he3;
			mem_array[399] <= 8'he3;
			mem_array[400] <= 8'he3;

		end
	end

endmodule
	