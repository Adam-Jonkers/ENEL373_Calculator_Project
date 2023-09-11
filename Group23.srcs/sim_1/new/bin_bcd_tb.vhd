----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 12:17:32
-- Design Name: 
-- Module Name: bin_bcd_tb - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for basic binary to BCD conversion
-- 
-- Dependencies: 
-- bin_bcd.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_bcd_tb is
--  Port ( );
end bin_bcd_tb;



architecture Behavioral of bin_bcd_tb is
    
    constant num_size : INTEGER := 24;
    constant num_segs : INTEGER := 8;
    constant seg_size : INTEGER := 4;

    signal BIN : STD_LOGIC_VECTOR (num_size - 1 downto 0);
    signal BCD : STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0);
    
    component bin_bcd
        Generic   ( num_size    : INTEGER;
                    num_segs    : INTEGER;
                    seg_size    : INTEGER );
        Port      ( BIN         : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                    BCD         : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
    end component;

begin
    
    UUT : bin_bcd   -- binary to bcd converter
    generic map   ( num_size    => num_size,
                    num_segs    => num_segs,
                    seg_size    => seg_size )
    port map      ( BIN         => BIN,
                    BCD         => BCD );
    
    -- test specific values
    BIN <= std_logic_vector(to_unsigned(16777215, num_size));
    
end Behavioral;
