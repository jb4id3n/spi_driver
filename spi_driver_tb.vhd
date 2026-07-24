----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2026 12:05:33 PM
-- Design Name: 
-- Module Name: spi_driver_tb - tb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi_driver_tb is
--  Port ( );
end spi_driver_tb;

architecture tb of spi_driver_tb is
    -- Clock period for simulation
  constant CLK_PERIOD : time := 10 ns;

  -- DUT signals
  signal clk               : std_logic := '0';
  signal reset             : std_logic := '0';
  signal MISO              : std_logic := '0';
  signal switch            : std_logic := '0';

  signal spi_clk           : std_logic;
  signal CS                : std_logic;
  signal MOSI              : std_logic;
  signal state_machine_busy: std_logic;
begin

  --------------------------------------------------------------------
  -- Clock generation
  --------------------------------------------------------------------
  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  --------------------------------------------------------------------
  -- DUT instantiation
  --------------------------------------------------------------------
  uut_top : entity work.top
    generic map (
      CLK_DIV => 2           -- small divider so sim runs quickly
    )
    port map (
      clk                => clk,
      reset              => reset,
      MISO               => MISO,
      switch             => switch,
      spi_clk            => spi_clk,
      CS                 => CS,
      MOSI               => MOSI,
      state_machine_busy => state_machine_busy
    );

  --------------------------------------------------------------------
  -- Stimulus
  --------------------------------------------------------------------
  stim_proc : process
  begin
    -- Initial conditions
    reset  <= '1';
    switch <= '0';
    MISO   <= '0';          -- not used by your SPI writer, so keep low

    -- Hold reset for a few cycles
    wait for 5 * CLK_PERIOD;
    reset <= '0';

    -- Wait a bit after reset
    wait for 5 * CLK_PERIOD;

    -- First SPI transfer: pulse switch for one clock
    switch <= '1';
    wait for CLK_PERIOD*200;
    switch <= '0';

--    -- Wait until the SPI FSM finishes (busy goes low)
--    wait until state_machine_busy = '0';
--    wait for 10 * CLK_PERIOD;

--    -- Second SPI transfer
--    switch <= '1';
--    wait for CLK_PERIOD;
--    switch <= '0';

    -- Let it run for a while to observe waveforms
    wait for 200 * CLK_PERIOD;

--     End simulation
    assert false report "End of SPI testbench simulation" severity failure;
  end process;


end tb;





