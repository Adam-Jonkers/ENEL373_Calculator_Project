----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp 
-- 
-- Create Date: 17.04.2023 16:35:44
-- Design Name: 
-- Module Name: display_bcd_formatter - Structural
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Produces a formatted BCD output from a signed binary input.
-- 
-- Dependencies: 
-- bin_abs.vhd
-- bin_bcd.vhd
-- bcd_format.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_bcd_formatter is
    Generic   ( num_size : INTEGER := 24;
                num_segs : INTEGER := 8;
                seg_size : INTEGER := 4 );
    Port      ( BIN : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                BCD : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
end display_bcd_formatter;

architecture Structural of display_bcd_formatter is

    constant bcd_size   : INTEGER := num_segs * seg_size;
    
    signal NEGATIVE     : STD_LOGIC;
    signal BIN_UNSIGN   : STD_LOGIC_VECTOR (num_size - 1 downto 0);
    signal BCD_RAW      : STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) := (others => '0');
    
    component bin_abs
        Generic   ( num_size    : INTEGER );
        Port      ( BIN_SIGNED  : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                    BIN_UNSIGN  : out STD_LOGIC_VECTOR (num_size - 1 downto 0);
                    NEGATIVE    : out STD_LOGIC );
    end component;
    
    component bin_bcd
        Generic   ( num_size    : INTEGER;
                    num_segs    : INTEGER;
                    seg_size    : INTEGER );
        Port      ( BIN         : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                    BCD         : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
    end component;
    
    component bcd_format
        Generic   ( num_segs    : INTEGER;
                    seg_size    : INTEGER );
        Port      ( NEGATIVE    : in STD_LOGIC;
                    BCD_RAW     : in STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0);
                    BCD_OUT     : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
    end component;

begin
    
    to_absolute :  bin_abs      -- converts a 24-bit signed to 24-bit unsigned with a negative flag
        generic map   ( num_size    => num_size )
        port map      ( BIN_SIGNED  => BIN,
                        BIN_UNSIGN  => BIN_UNSIGN,
                        NEGATIVE    => NEGATIVE );
    
    to_bcd : bin_bcd            -- binary to bcd conversion, with leading zeros
        generic map   ( num_size    => num_size,
                        num_segs    => num_segs - 1,
                        seg_size    => seg_size )
        port map      ( BIN         => BIN_UNSIGN,
                        BCD         => BCD_RAW((num_segs - 1) * seg_size - 1 downto 0) );
        
    format_bcd : bcd_format     -- blanks leading zeros, places negative sign in front of leading digit when required
        generic map   ( num_segs    => num_segs,
                        seg_size    => seg_size )
        port map      ( NEGATIVE    => NEGATIVE,
                        BCD_RAW     => BCD_RAW,
                        BCD_OUT     => BCD );

end Structural;
