----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 08.05.2023 10:05:29
-- Design Name: 
-- Module Name: tristate_expand - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: tristate buffer acting between buses of different widths
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

entity tristate_expand is
    Generic   ( input_width     : INTEGER   := 12;
                output_width    : INTEGER   := 24;
                twos_comp       : STD_LOGIC := '0' );   -- control mode for expansion method
    Port      ( ENABLE          : in STD_LOGIC;
                DATA_IN         : in STD_LOGIC_VECTOR(input_width - 1 downto 0);
                DATA_OUT        : out STD_LOGIC_VECTOR(output_width - 1 downto 0) );
end tristate_expand;

architecture Dataflow of tristate_expand is

    signal DATA_EXPAND : STD_LOGIC_VECTOR(output_width - 1 downto 0);   -- expanded vector of data

begin

    -- expand the vector using its most significant value (maintains the same twos complement value)
    -- or using '0's (maintains the same unsigned value)
    with twos_comp select DATA_EXPAND <=
        (output_width - 1 downto input_width => DATA_IN(DATA_IN'left)) & DATA_IN when '1',  -- concatenate with MSB
        (output_width - 1 downto input_width => '0') & DATA_IN when others;                 -- concatenate with '0's

    -- standard tristate buffer behaviour on expanded vector
    with ENABLE select DATA_OUT <=
        DATA_EXPAND when '1',
        (others => 'Z') when others;

end Dataflow;
