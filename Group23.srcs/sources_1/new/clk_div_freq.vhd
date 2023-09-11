----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 16.04.2023 15:47:35
-- Design Name: 
-- Module Name: clk_div_freq - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: A basic clock divider that determines the required threshold value
--              based on specified input and output frequencies 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- based on Steves_clock_divider.vhd
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity clk_div_freq is
    Generic   ( freq_in     : INTEGER;
                freq_out    : INTEGER );
    Port      ( CLK_IN      : in STD_LOGIC;
                CLK_OUT     : out STD_LOGIC );
end clk_div_freq;



architecture Behavioral of clk_div_freq is

    constant ctr_threshold  : INTEGER   := freq_in / freq_out / 2 - 1;
    signal CTR              : INTEGER range ctr_threshold downto 0 := 0;
    signal CLK_TEMP         : STD_LOGIC := '0';
    
    begin
    
    -- iterates a counter, changes the output value once a threshold value is reached
    div: process(CLK_IN) 
    begin
        if rising_edge(CLK_IN) then
            
            if CTR >= ctr_threshold then
                CTR <= 0;
                CLK_TEMP <= not CLK_TEMP;   -- switch output state when the threshold is crossed
            else
                CTR <= CTR + 1;             -- iterate counter
            end if;
        
        end if;
    end process div;
     
    CLK_OUT <= CLK_TEMP;        -- assign temporary signal to output only port

end Behavioral;
