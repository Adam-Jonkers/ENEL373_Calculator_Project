----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 16:52:07
-- Design Name: 
-- Module Name: display_bcd_formatter_tb - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for formatted BCD output from signed binary input
-- 
-- Dependencies: 
-- display_bcd_formatter.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_bcd_formatter_tb is
--  Port ( );
end display_bcd_formatter_tb;

architecture Behavioral of display_bcd_formatter_tb is

    constant num_size : INTEGER := 24;
    constant num_segs : INTEGER := 8;
    constant seg_size : INTEGER := 4;
    
    signal BIN : STD_LOGIC_VECTOR (num_size - 1 downto 0);
    signal BCD : STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0);

    component display_bcd_formatter
        Generic   ( num_size    : INTEGER;
                    num_segs    : INTEGER;
                    seg_size    : INTEGER );
        Port      ( BIN         : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                    BCD         : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
    end component;

begin

    UUT : display_bcd_formatter
        generic map   ( num_size    => num_size,
                        num_segs    => num_segs,
                        seg_size    => seg_size )
        port map      ( BIN         => BIN,
                        BCD         => BCD );
    
    -- loop to test all values within a 12-bit signed number
    process
    begin
        for i in -2048 to 2047 loop
            BIN <= std_logic_vector(to_signed(i, num_size));
            wait for 1ns;
        end loop;
        wait;
    end process;

end Behavioral;
