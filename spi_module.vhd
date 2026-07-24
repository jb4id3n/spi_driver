----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/22/2026 10:24:38 AM
-- Design Name: 
-- Module Name: spi_module - fsm
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

entity spi_module is
  generic(
    CLK_DIV : integer := 0
  );
  Port ( 
    clk, reset, MISO, start_xfer : in std_logic;
    cmd         : in std_logic_vector(3 downto 0);
    addr        : in std_logic_vector(3 downto 0);
    data        : in std_logic_vector(15 downto 0);
    
    spi_clk, CS, MOSI, state_machine_busy : out std_logic
  );
end spi_module;

architecture fsm of spi_module is
    type machine is (IDLE, BUSY);
    signal state : machine := IDLE;
    signal start_xfer_reg : std_logic_vector(1 downto 0);
    signal clk_count      : integer := 0;
    signal msg            : std_logic_vector(23 downto 0);
    signal bit_index      : integer := 22;
    signal idx_cnt        : integer := 0;
    signal cycle_cnt      : integer := 0;
    signal spi_clk_int    : std_logic := '0';
--    signal spi_clk_reg    : std_logic_vector(1 downto 0);
begin

    spi_clk <= spi_clk_int;
--    msg <= cmd & addr & data; -- concatenate into msg

    process(clk)
    begin
        
        if (reset = '1') then
            state              <= IDLE;
            clk_count          <= 0;
            idx_cnt            <= 0;
            bit_index          <= 22;
            start_xfer_reg     <= (others => '0');
            msg                <= (others => '0');
            CS                 <= '1';  -- deselect DAC
            MOSI               <= '0';
            spi_clk_int        <= '0';
            state_machine_busy <= '0';
--            spi_clk_reg        <= "00";
        elsif (rising_edge(clk)) then
--            state_machine_busy <= '0';
--            CS                 <= '1';
--            MOSI               <= '0';
--        else
            start_xfer_reg(0) <= start_xfer;
            start_xfer_reg(1) <= start_xfer_reg(0);
            
--            spi_clk_reg(0) <= spi_clk_int;
--            spi_clk_reg(1) <= spi_clk_reg(0);
            
            case state is
                when IDLE =>
                    state_machine_busy <= '0';
                    CS                 <= '1';
                    MOSI               <= '0';
                    spi_clk_int        <= '0';
                    cycle_cnt          <= 0;
                    
                    if (start_xfer_reg = "01") then
                        state               <= BUSY;
                        state_machine_busy  <= '1'; -- set busy flag
                        CS                  <= '0'; -- pull chip select low to initiate transfer
                        msg                 <= cmd & addr & data;
                        bit_index           <= 22;
                        idx_cnt             <= 0;
                        cycle_cnt           <= 0;
                        MOSI <= msg(23);
                    end if;
                
                when BUSY =>
                
                    if (cycle_cnt = 1) then
                        cycle_cnt <= 0;
                        spi_clk_int <= not spi_clk_int;
                
                        if (spi_clk_int = '1') then
                            MOSI <= msg(bit_index);
                            
                            if (idx_cnt = 23) then
                                state_machine_busy <= '0';
                                state <= IDLE;
                            else
                                idx_cnt <= idx_cnt + 1;
                            end if;
                            
                            if (bit_index > 0) then
--                                bit_index <= 23;
--                                state_machine_busy <= '0';
--                                state <= IDLE;
                                bit_index <= bit_index - 1;
                            end if;
          
                        end if;

                    else
                        cycle_cnt <= cycle_cnt + 1;
                    end if;
                    
            end case;
                
        end if;
    end process;

end fsm;
