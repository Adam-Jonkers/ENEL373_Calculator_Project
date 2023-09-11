----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 09.03.2023 12:34:53
-- Design Name: 
-- Module Name: decoder - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Decodes a binary encoded value to its respective one-hot output,
--              used to select between the display anodes
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
use IEEE.NUMERIC_STD.ALL;

entity decoder is
    Generic   ( input_count     : INTEGER := 4;
                output_count    : INTEGER := 8 );
    Port      ( VAL             : in STD_LOGIC_VECTOR(input_count - 1 downto 0);
                SEL             : out STD_LOGIC_VECTOR(output_count - 1 downto 0) );
end decoder;

architecture Behavioral of decoder is

begin
    process (VAL)
    begin
        SEL <= (others => '0');                 -- sets all pins LOW
        SEL(to_integer(unsigned(VAL))) <= '1';  -- sets pin specified by VAL HIGH 
    end process;

end Behavioral;
