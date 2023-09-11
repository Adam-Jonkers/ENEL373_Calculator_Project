----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 15:57:55
-- Design Name: 
-- Module Name: bcd_format - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Performs blanking and addition of a sign character for BCD display output
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Based on bcd_blanker.vhd
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_format is
    Generic   ( num_segs    : INTEGER := 8;
                seg_size    : INTEGER := 4 );
    Port      ( NEGATIVE    : in STD_LOGIC;
                BCD_RAW     : in STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0);
                BCD_OUT     : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
end bcd_format;

architecture Dataflow of bcd_format is

    -- OR all bits in input vector (from bcd_blanker.vhd)
    function or_reduce (input : STD_LOGIC_VECTOR) return STD_LOGIC is
        variable result : STD_LOGIC;
    begin
        result := '0';
        for i in input'range loop
            result := result or input(i);
        end loop;
        return result;
    end function;
    
    -- alternative BCD values for OFF, MINUS, and PLUS states of a display (interpreted by the BCD to 7-Seg decoder)
    constant OFF    : STD_LOGIC_VECTOR(seg_size - 1 downto 0) := "1111";
    constant MINUS  : STD_LOGIC_VECTOR(seg_size - 1 downto 0) := "1110";
    constant PLUS   : STD_LOGIC_VECTOR(seg_size - 1 downto 0) := OFF;
    
    signal ENABLE   : STD_LOGIC_VECTOR(num_segs downto 0);      -- vector to indicate whether a digit is on or off
    signal SIGN     : STD_LOGIC_VECTOR(seg_size - 1 downto 0);  -- BCD value set to MINUS when the value is negative, PLUS otherwise

begin
    
    BCD_OUT(seg_size - 1 downto 0) <= BCD_RAW(seg_size - 1 downto 0);   -- least significant digit is always displayed
    
    with NEGATIVE select SIGN <= MINUS when '1', OFF when others;       -- select the sign based on the state of the negative flag

    ENABLE(0) <= '1';
    ENABLE(ENABLE'left) <= '0';
    
    -- set ENABLE to 0 for all leading 0s, 1 for all other digits
    format : for i in num_segs - 1 downto 1 generate
        
        ENABLE(i) <= ENABLE(i+1) OR or_reduce(BCD_RAW(i * seg_size + 3 downto i * seg_size));
        
        -- place the sign in front of the leading digit, where ENABLE switches from 0 to 1
        with ENABLE(i downto i - 1) select BCD_OUT(i * seg_size + 3 downto i * seg_size) <=
            BCD_RAW(i * seg_size + 3 downto i * seg_size) when "11",
            SIGN when "01",
            OFF when others;
            
    end generate;

end Dataflow;
