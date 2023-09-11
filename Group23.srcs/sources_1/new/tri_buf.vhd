----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Engineer: 
-- 
-- Create Date: 09.03.2023 14:01:08
-- Design Name: 
-- Module Name: tri_buf - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: tristate buffer
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

entity tri_buf is
    Generic   ( bus_width   : integer := 1 );
    Port      ( EN          : in STD_LOGIC;
                DATA_IN     : in STD_LOGIC_VECTOR(bus_width - 1 downto 0);
                DATA_OUT    : out STD_LOGIC_VECTOR(bus_width - 1 downto 0) );
end tri_buf;

architecture Dataflow of tri_buf is

begin

    DATA_OUT <= (others => 'Z') when EN = '0' else DATA_IN;

end Dataflow;
