----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Adam Jonkers
-- 
-- Create Date: 18.04.2023 16:41:01
-- Design Name: Register
-- Module Name: reg - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Generic register for storing data
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    Generic ( bus_width : integer := 12);
    Port (  EN          : in STD_LOGIC;
            CLK         : in std_logic;
            DATA_IN     : in STD_LOGIC_VECTOR (bus_width - 1 downto 0);
            DATA_OUT    : out STD_LOGIC_VECTOR (bus_width - 1 downto 0));
end reg;

architecture Behavioral of reg is

begin
    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (EN = '1') then
                DATA_OUT <= DATA_IN;
            end if;
        end if;
    end process;
end Behavioral;
