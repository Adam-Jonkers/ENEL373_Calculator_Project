----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 07.05.2023 10:17:21
-- Design Name: 
-- Module Name: overflow_check - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: checks whether a 24-bit signed value can be represented
--              as a 12-bit signed value
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

entity overflow_check is
    Generic   ( bin_size    : INTEGER := 24;
                target_size : INTEGER := 12 );
    Port      ( BIN_IN      : in STD_LOGIC_VECTOR(bin_size - 1 downto 0);
                OVERFLOW    : out STD_LOGIC );
end overflow_check;

architecture Behavioral of overflow_check is
    signal BIN : STD_LOGIC_VECTOR(bin_size - 1 downto 0);
begin
    BIN <= BIN_IN;
    
    process (BIN)
    begin
        OVERFLOW <= '0';
        
        -- check whether the (13) most significant bits are all the same
        -- if not, the number is not representable in 12 bits
        for i in bin_size - 2 downto target_size - 1 loop
            if BIN(bin_size - 1) /= BIN(i) then
                OVERFLOW <= '1';
                end if;
        end loop;
        
    end process;

end Behavioral;
