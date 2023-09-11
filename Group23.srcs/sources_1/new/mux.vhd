----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 17:42:09
-- Design Name: 
-- Module Name: mux - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: simple multiplexer
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

entity mux is
    Generic   ( sel_size    : INTEGER := 4;
                data_size   : INTEGER := 4;
                input_count : INTEGER := 8 );
    Port      ( INPUT       : in STD_LOGIC_VECTOR(data_size * input_count - 1 downto 0);
                SEL         : in STD_LOGIC_VECTOR(sel_size - 1 downto 0);
                OUTPUT      : out STD_LOGIC_VECTOR(data_size - 1 downto 0) );
end mux;

architecture Dataflow of mux is
    
    signal select_val : INTEGER;

begin
    
    select_val <= to_integer(unsigned(SEL));        -- integer conversion of the input index to be selected
    OUTPUT <= INPUT((select_val + 1) * data_size - 1 downto select_val * data_size);    -- select the specified data_size number of bits

end Dataflow;
