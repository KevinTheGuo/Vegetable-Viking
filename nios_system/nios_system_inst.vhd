	component nios_system is
		port (
			clk_clk             : in    std_logic                     := 'X';             -- clk
			reset_reset_n       : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk       : out   std_logic;                                        -- clk
			sdram_wire_addr     : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba       : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n    : out   std_logic;                                        -- cas_n
			sdram_wire_cke      : out   std_logic;                                        -- cke
			sdram_wire_cs_n     : out   std_logic;                                        -- cs_n
			sdram_wire_dq       : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm      : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n    : out   std_logic;                                        -- ras_n
			sdram_wire_we_n     : out   std_logic;                                        -- we_n
			to_hw_port0_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port1_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port10_export : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port11_export : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port12_export : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port2_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port3_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port4_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port5_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port6_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port7_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port8_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port9_export  : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_sig_export    : out   std_logic_vector(1 downto 0);                     -- export
			to_sw_sig_export    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			to_hw_port14_export : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port13_export : out   std_logic_vector(31 downto 0);                    -- export
			to_hw_port15_export : out   std_logic_vector(31 downto 0);                    -- export
			to_sw_port0_export  : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			to_sw_port1_export  : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			to_sw_port2_export  : in    std_logic_vector(7 downto 0)  := (others => 'X')  -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --        reset.reset_n
			sdram_clk_clk       => CONNECTED_TO_sdram_clk_clk,       --    sdram_clk.clk
			sdram_wire_addr     => CONNECTED_TO_sdram_wire_addr,     --   sdram_wire.addr
			sdram_wire_ba       => CONNECTED_TO_sdram_wire_ba,       --             .ba
			sdram_wire_cas_n    => CONNECTED_TO_sdram_wire_cas_n,    --             .cas_n
			sdram_wire_cke      => CONNECTED_TO_sdram_wire_cke,      --             .cke
			sdram_wire_cs_n     => CONNECTED_TO_sdram_wire_cs_n,     --             .cs_n
			sdram_wire_dq       => CONNECTED_TO_sdram_wire_dq,       --             .dq
			sdram_wire_dqm      => CONNECTED_TO_sdram_wire_dqm,      --             .dqm
			sdram_wire_ras_n    => CONNECTED_TO_sdram_wire_ras_n,    --             .ras_n
			sdram_wire_we_n     => CONNECTED_TO_sdram_wire_we_n,     --             .we_n
			to_hw_port0_export  => CONNECTED_TO_to_hw_port0_export,  --  to_hw_port0.export
			to_hw_port1_export  => CONNECTED_TO_to_hw_port1_export,  --  to_hw_port1.export
			to_hw_port10_export => CONNECTED_TO_to_hw_port10_export, -- to_hw_port10.export
			to_hw_port11_export => CONNECTED_TO_to_hw_port11_export, -- to_hw_port11.export
			to_hw_port12_export => CONNECTED_TO_to_hw_port12_export, -- to_hw_port12.export
			to_hw_port2_export  => CONNECTED_TO_to_hw_port2_export,  --  to_hw_port2.export
			to_hw_port3_export  => CONNECTED_TO_to_hw_port3_export,  --  to_hw_port3.export
			to_hw_port4_export  => CONNECTED_TO_to_hw_port4_export,  --  to_hw_port4.export
			to_hw_port5_export  => CONNECTED_TO_to_hw_port5_export,  --  to_hw_port5.export
			to_hw_port6_export  => CONNECTED_TO_to_hw_port6_export,  --  to_hw_port6.export
			to_hw_port7_export  => CONNECTED_TO_to_hw_port7_export,  --  to_hw_port7.export
			to_hw_port8_export  => CONNECTED_TO_to_hw_port8_export,  --  to_hw_port8.export
			to_hw_port9_export  => CONNECTED_TO_to_hw_port9_export,  --  to_hw_port9.export
			to_hw_sig_export    => CONNECTED_TO_to_hw_sig_export,    --    to_hw_sig.export
			to_sw_sig_export    => CONNECTED_TO_to_sw_sig_export,    --    to_sw_sig.export
			to_hw_port14_export => CONNECTED_TO_to_hw_port14_export, -- to_hw_port14.export
			to_hw_port13_export => CONNECTED_TO_to_hw_port13_export, -- to_hw_port13.export
			to_hw_port15_export => CONNECTED_TO_to_hw_port15_export, -- to_hw_port15.export
			to_sw_port0_export  => CONNECTED_TO_to_sw_port0_export,  --  to_sw_port0.export
			to_sw_port1_export  => CONNECTED_TO_to_sw_port1_export,  --  to_sw_port1.export
			to_sw_port2_export  => CONNECTED_TO_to_sw_port2_export   --  to_sw_port2.export
		);

