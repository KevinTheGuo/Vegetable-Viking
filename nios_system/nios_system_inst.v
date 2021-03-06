	nios_system u0 (
		.clk_clk             (<connected-to-clk_clk>),             //          clk.clk
		.reset_reset_n       (<connected-to-reset_reset_n>),       //        reset.reset_n
		.sdram_clk_clk       (<connected-to-sdram_clk_clk>),       //    sdram_clk.clk
		.sdram_wire_addr     (<connected-to-sdram_wire_addr>),     //   sdram_wire.addr
		.sdram_wire_ba       (<connected-to-sdram_wire_ba>),       //             .ba
		.sdram_wire_cas_n    (<connected-to-sdram_wire_cas_n>),    //             .cas_n
		.sdram_wire_cke      (<connected-to-sdram_wire_cke>),      //             .cke
		.sdram_wire_cs_n     (<connected-to-sdram_wire_cs_n>),     //             .cs_n
		.sdram_wire_dq       (<connected-to-sdram_wire_dq>),       //             .dq
		.sdram_wire_dqm      (<connected-to-sdram_wire_dqm>),      //             .dqm
		.sdram_wire_ras_n    (<connected-to-sdram_wire_ras_n>),    //             .ras_n
		.sdram_wire_we_n     (<connected-to-sdram_wire_we_n>),     //             .we_n
		.to_hw_port0_export  (<connected-to-to_hw_port0_export>),  //  to_hw_port0.export
		.to_hw_port1_export  (<connected-to-to_hw_port1_export>),  //  to_hw_port1.export
		.to_hw_port10_export (<connected-to-to_hw_port10_export>), // to_hw_port10.export
		.to_hw_port11_export (<connected-to-to_hw_port11_export>), // to_hw_port11.export
		.to_hw_port12_export (<connected-to-to_hw_port12_export>), // to_hw_port12.export
		.to_hw_port13_export (<connected-to-to_hw_port13_export>), // to_hw_port13.export
		.to_hw_port14_export (<connected-to-to_hw_port14_export>), // to_hw_port14.export
		.to_hw_port15_export (<connected-to-to_hw_port15_export>), // to_hw_port15.export
		.to_hw_port2_export  (<connected-to-to_hw_port2_export>),  //  to_hw_port2.export
		.to_hw_port3_export  (<connected-to-to_hw_port3_export>),  //  to_hw_port3.export
		.to_hw_port4_export  (<connected-to-to_hw_port4_export>),  //  to_hw_port4.export
		.to_hw_port5_export  (<connected-to-to_hw_port5_export>),  //  to_hw_port5.export
		.to_hw_port6_export  (<connected-to-to_hw_port6_export>),  //  to_hw_port6.export
		.to_hw_port7_export  (<connected-to-to_hw_port7_export>),  //  to_hw_port7.export
		.to_hw_port8_export  (<connected-to-to_hw_port8_export>),  //  to_hw_port8.export
		.to_hw_port9_export  (<connected-to-to_hw_port9_export>),  //  to_hw_port9.export
		.to_hw_sig_export    (<connected-to-to_hw_sig_export>),    //    to_hw_sig.export
		.to_sw_port0_export  (<connected-to-to_sw_port0_export>),  //  to_sw_port0.export
		.to_sw_port1_export  (<connected-to-to_sw_port1_export>),  //  to_sw_port1.export
		.to_sw_port2_export  (<connected-to-to_sw_port2_export>),  //  to_sw_port2.export
		.to_sw_sig_export    (<connected-to-to_sw_sig_export>),    //    to_sw_sig.export
		.to_sw_port3_export  (<connected-to-to_sw_port3_export>),  //  to_sw_port3.export
		.to_sw_port4_export  (<connected-to-to_sw_port4_export>)   //  to_sw_port4.export
	);

