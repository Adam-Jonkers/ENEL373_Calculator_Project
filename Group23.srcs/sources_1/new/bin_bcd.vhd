----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 11:42:04
-- Design Name: 
-- Module Name: bin_bcd - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Basic binary to BCD conversion using the double dabble algorithm
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Inspired by:
--      https://en.wikipedia.org/wiki/Double_dabble
--      https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d
--      bin_to_bcd.vhd
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity bin_bcd is
    Generic   ( num_size : INTEGER := 24;
                num_segs : INTEGER := 7;
                seg_size : INTEGER := 4 );
    Port      ( BIN : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                BCD : out STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0) );
end bin_bcd;



architecture Behavioral of bin_bcd is
    
    constant bcd_size : INTEGER := num_segs * seg_size;
       
begin
    
    -- conversion triggered by a change to the binary input value
    process(BIN)
    
        variable bcd_reg : unsigned (bcd_size - 1 downto 0);

    begin
        
        -- least significant digit is always displayed
        bcd_reg := (others => '0');

        -- first 3 bits placed in the output vector, since no addition is required in the first 2 steps
        bcd_reg(2 downto 0) := unsigned(BIN(BIN'left downto BIN'left - 2));
    
        for i in num_size - 4 downto 0 loop
        
            -- check each BCD digit for a value greater than 4 (indicating a shift left would result in a two digit number)
            -- only test from the (num_size - i - 1)/3 digit, since larger digits are guaranteed to be 0 
            for j in (num_size - i - 1)/3 - 1 downto 0 loop
                if bcd_reg(j * 4 + 3 downto j * 4) > 4 then
                    bcd_reg(j * 4 + 3 downto j * 4) := bcd_reg(j * 4 + 3 downto j * 4) + 3;
                end if;
            end loop;
            
            -- shift and add, applying Horner's method of polynomial evaluation
            bcd_reg := bcd_reg(bcd_size - 2 downto 0) & BIN(i);
            
        end loop;
        
        BCD <= STD_LOGIC_VECTOR(bcd_reg);
    
    end process;
    
end Behavioral;
