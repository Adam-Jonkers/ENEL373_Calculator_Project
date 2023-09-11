-- Adapted from ENEL373 exemplar code
-- Project: TuesA01_Group_23

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Generic   ( max_count   : integer := 9 );
    Port      ( clk         : in std_logic;
                count       : out std_logic_vector (3 downto 0);
                overflow    : out std_logic );
end counter;


architecture Behavioral of counter is
    signal counter : INTEGER range 0 to max_count := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if counter >= max_count then
                -- Reset counter and assert overflow
                counter <= 0;
                overflow <= '1';
            else
                -- Increment counter and reset overflow
                counter <= counter + 1;
                overflow <= '0';
            end if;
        end if;
    end process;
    
    -- Convert value of counter to std_logic_vector
    count <= std_logic_vector(to_unsigned(counter, count'length));
    
end Behavioral;