----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 07.05.2023 17:42:38
-- Design Name: 
-- Module Name: disp_led - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: maps data bus values and register selection to output LEDs
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

entity disp_led is
    Port      ( ENABLE_REG_1    : in STD_LOGIC;
                ENABLE_REG_2    : in STD_LOGIC;
                ENABLE_REG_3    : in STD_LOGIC;
                ENABLE_ALU      : in STD_LOGIC;
                ENABLE_LED      : in STD_LOGIC;
                BIN             : in STD_LOGIC_VECTOR(11 downto 0);
                LED             : out STD_LOGIC_VECTOR(15 downto 0) );
end disp_led;

architecture Dataflow of disp_led is

begin
    LED(15) <= ENABLE_REG_1;
    LED(14) <= ENABLE_REG_2;
    LED(13) <= ENABLE_REG_3;
    LED(12) <= ENABLE_ALU;

    -- map the 12 least significant bits to 12 LEDs when enabled (shows register contents)
    LED(11 downto 0) <= BIN when ENABLE_LED = '1' else (others => '0');
end Dataflow;
