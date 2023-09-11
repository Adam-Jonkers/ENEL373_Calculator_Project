----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 14.04.2023 12:23:02
-- Design Name: 
-- Module Name: btn_debounce - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: A digital button debouncing module, triggering a change in state
--              only when the button has settled for some time. 
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
--
-- Additional Comments:
--
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;       -- library for state counter operation



entity btn_debounce is
    Generic   ( active_mode         : STD_LOGIC := '1';     -- default active high state
                threshold_active    : INTEGER   := 100;
                threshold_inactive  : INTEGER   := 100 );
    Port      ( CLK                 : in STD_LOGIC; 
                BTN_IN              : in STD_LOGIC;
                BTN_DB              : out STD_LOGIC := not active_mode );
end btn_debounce;



architecture Behavioral of btn_debounce is
    
    -- returns the maximum value of two input integers
    -- included for compatibility with VHDL default version, this is a standard function in VHDL-2008
    function maximum( a : INTEGER; b : INTEGER) return INTEGER is
        variable max : INTEGER;
    begin
        if (a >= b) then
            max := a;
        else
            max := b;
        end if;
        return max;
    end function maximum;

    signal PREV_STATE   : STD_LOGIC := BTN_IN;
    signal STATE_CTR    : INTEGER range 0 to maximum(threshold_active, threshold_inactive) := 0; -- range specified to prevent a 32bit value being generated
 
 
    
    begin
        -- iterates counter based on time in active/inactive states
        -- resets to 0 on a state transition
        ctr: process(CLK)
        begin
            -- check button state on rising edge and update counter as necesscary
            if rising_edge(CLK) then
                if BTN_IN /= PREV_STATE then
                    STATE_CTR <= 0;
                elsif BTN_IN = PREV_STATE then
                    STATE_CTR <= STATE_CTR + 1;
                end if;
                PREV_STATE <= BTN_IN;
             end if;
        end process ctr;
        
        -- alters debounced output based on time in state (threshold values) and current state
        output: process(CLK)
        begin
            -- separate processing of active and inactive states allows for differing thresholds if desired
            if rising_edge(CLK) then
                if PREV_STATE = active_mode and STATE_CTR >= threshold_active then
                    BTN_DB <= active_mode;
                elsif PREV_STATE /= active_mode and STATE_CTR >= threshold_inactive then
                    BTN_DB <= not active_mode;
                end if;
            end if;
        end process output;
    
end Behavioral;
