----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/22/2026 10:35:01 AM
-- Design Name: 
-- Module Name: top - fsm
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

entity top is
  generic(
    CLK_DIV : integer := 0
  );
  Port ( 
    clk, MISO, switch : in std_logic;
    spi_clk, CS, MOSI : out std_logic
        
  );
end top;

architecture fsm of top is
    signal start_xfer   : std_logic := '0';
    signal is_busy      : std_logic;
    signal switch_reg   : std_logic_vector(1 downto 0);
    signal reset        : std_logic := '0';
    
    signal cmd_in  : std_logic_vector(3 downto 0) := "0010";
    signal addr_in : std_logic_vector(3 downto 0) := "0000";
    signal data_1V : std_logic_vector(15 downto 0):= x"3E80";
    signal data_2V : std_logic_vector(15 downto 0):= x"7D00";
    signal data_in : std_logic_vector(15 downto 0);

begin

    SPI_INST : entity work.spi_module
        generic map(
            CLK_DIV => CLK_DIV
        )
        port map(
            clk                 => clk,
            reset               => reset,
            MISO                => MISO,
            start_xfer          => start_xfer,
            cmd                 => cmd_in,
            addr                => addr_in,
            data                => data_in,
            CS                  => CS,
            MOSI                => MOSI,
            state_machine_busy  => is_busy,
            spi_clk             => spi_clk
        );

--    state_machine_busy <= is_busy;
    
    process(clk)
    begin
--        if (reset = '1') then
--            start_xfer <= '0';
        if rising_edge(clk) then
        
            switch_reg(0) <= switch;
            switch_reg(1) <= switch_reg(0);
            
            if is_busy = '1' then
                start_xfer <= '0';
            else
                
                case switch_reg is   
                    when "10" =>
                        data_in <= data_1V;
                        start_xfer <= '1';
                    when "01" =>
                        data_in <= data_2V;
                        start_xfer <= '1';
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
end fsm;
