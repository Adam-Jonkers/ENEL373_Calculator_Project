----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 14.04.2023 13:11:45
-- Design Name: 
-- Module Name: btn_debounce_tb - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: This is a testbench for the button debouncing module
-- 
-- Dependencies:
-- btn_debounce.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
--
-- Additional Comments:
-- Ensure simulation time set to >10000ns
--
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;       -- library for numeric conversions/maths
use IEEE.MATH_REAL.ALL;         -- library for random number generation



entity btn_debounce_tb is
--  Port ( );
end btn_debounce_tb;



architecture Behavioral of btn_debounce_tb is

    constant ACTIVE_MODE        : STD_LOGIC := '0';     -- set button as active low
    constant THRESHOLD_ACTIVE   : INTEGER   := 50;      -- set trigger threshold (based on clock cycles)
    constant THRESHOLD_INACTIVE : INTEGER   := THRESHOLD_ACTIVE;
    
    constant CLK_PERIOD : TIME  := 10ns;                -- set 10MHz clock
    signal CLK      : STD_LOGIC := '0';
    signal BTN_IN   : STD_LOGIC := not ACTIVE_MODE;     -- initialise buttons at steady state 
    signal BTN_OUT  : STD_LOGIC := not ACTIVE_MODE;
    
    -- component under test (dependency)
    component btn_debounce
        Generic   ( active_mode         : STD_LOGIC;
                    threshold_active    : INTEGER;
                    threshold_inactive  : INTEGER );
        Port      ( CLK                 : in STD_LOGIC; 
                    BTN_IN              : in STD_LOGIC;
                    BTN_DB              : out STD_LOGIC );
    end component;

    begin
    
    UUT: btn_debounce       -- debouncing component
        generic map   ( active_mode => ACTIVE_MODE,
                        threshold_active => THRESHOLD_ACTIVE,
                        threshold_inactive => THRESHOLD_INACTIVE )
        port map      ( CLK => CLK,
                        BTN_IN => BTN_IN,
                        BTN_DB => BTN_OUT );
    
    CLK <= not CLK after CLK_PERIOD / 2;    -- generate clock based on clock period
        
    process
        -- setup switch bounce randomisation
        constant rand_range     : real      := 2.0;
        variable seed1, seed2   : positive;
        variable rand           : real;
        
        -- switch state variables
        variable btn_state      : STD_LOGIC := not ACTIVE_MODE;
        variable bounce_state   : STD_LOGIC;
    
        begin
        
            -- Basic tests of debounce response based on active/inactive time
            BTN_IN <= not ACTIVE_MODE;
            wait for 2*THRESHOLD_INACTIVE * CLK_PERIOD;
            BTN_IN <= ACTIVE_MODE;
            wait for 9*THRESHOLD_ACTIVE/10 * CLK_PERIOD;    -- under threshold active
            BTN_IN <= not ACTIVE_MODE;
            wait for THRESHOLD_INACTIVE/10 * CLK_PERIOD;
            BTN_IN <= ACTIVE_MODE;
            wait for 2*THRESHOLD_ACTIVE * CLK_PERIOD;       -- over threshold active
            
            BTN_IN <= ACTIVE_MODE;
            wait for 2*THRESHOLD_ACTIVE * CLK_PERIOD;
            BTN_IN <= not ACTIVE_MODE;
            wait for 9*THRESHOLD_INACTIVE/10 * CLK_PERIOD;  -- under threshold inactive
            BTN_IN <= ACTIVE_MODE;
            wait for THRESHOLD_ACTIVE/10 * CLK_PERIOD;
            BTN_IN <= not ACTIVE_MODE;
            wait for 2*THRESHOLD_INACTIVE * CLK_PERIOD;     -- over threshold inactive
            
            
            
            -- Repetitive testing of debouncing with pseudorandom jitter (bounce)
            for i in 1 to 5 loop
                btn_state := not btn_state;
                for j in 1 to 2*THRESHOLD_ACTIVE/5 loop
                    uniform(seed1, seed2, rand);
                    bounce_state := std_logic(to_unsigned(integer(rand * rand_range), 1)(0));
                    BTN_IN <= btn_state XOR bounce_state;
                    wait for CLK_PERIOD;
                end loop;
                BTN_IN <= btn_state;
                wait for 8*THRESHOLD_ACTIVE/5 * CLK_PERIOD;
            
            end loop;
        end process;

end Behavioral;
