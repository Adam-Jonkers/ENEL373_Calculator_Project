----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 16.04.2023 16:05:17
-- Design Name: 
-- Module Name: clk_div_freq_tb - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: This is a testbench for a clock divider component with
--              configurable input/output frequencies
-- 
-- Dependencies:
-- clk_div_freq.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity clk_div_freq_tb is
--  Port ( );
end clk_div_freq_tb;



architecture Behavioral of clk_div_freq_tb is

    constant FREQ_IN    : INTEGER   := 100000000;
    constant FREQ_OUT   : INTEGER   := 1000;
    
    constant CLK_PERIOD : TIME      := 10ns;
    signal CLK_IN       : STD_LOGIC := '0';
    signal CLK_OUT      : STD_LOGIC;

    component clk_div_freq
        Generic   ( FREQ_IN     : INTEGER;
                    FREQ_OUT    : INTEGER );
        Port      ( CLK_IN      : in STD_LOGIC;
                    CLK_OUT     : out STD_LOGIC );
    end component;

begin

    UUT: clk_div_freq       -- clock divider
        generic map   ( FREQ_IN     => FREQ_IN,
                        FREQ_OUT    => FREQ_OUT )
        port map      ( CLK_IN      => CLK_IN,
                        CLK_OUT     => CLK_OUT );
    
    CLK_IN <= not CLK_IN after CLK_PERIOD / 2;      -- generates clock based on clock period

end Behavioral;
