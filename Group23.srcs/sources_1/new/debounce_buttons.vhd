----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 07.05.2023 23:59:12
-- Design Name: 
-- Module Name: debounce_buttons - Structural
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: applies standardised debouncing to a vector of signals using a shared clock
-- 
-- Dependencies: 
-- clk_div_freq.vhd
-- btn_debounce.vhd
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce_buttons is
    Generic   ( num_inputs          : INTEGER   := 1;
                clk_freq            : INTEGER   := 100000000;
                btn_freq            : INTEGER   := 1000000;
                active_mode         : STD_LOGIC := '1';
                threshold_active    : INTEGER   := 100;
                threshold_inactive  : INTEGER   := 100 );
    Port      ( CLK                 : in STD_LOGIC;
                BTN_IN              : in STD_LOGIC_VECTOR (num_inputs - 1 downto 0);
                BTN_DB              : out STD_LOGIC_VECTOR (num_inputs - 1 downto 0) := (others => not active_mode) );
end debounce_buttons;

architecture Structural of debounce_buttons is

    component clk_div_freq      -- clock divider for input polling
        Generic   ( FREQ_IN     : INTEGER;
                    FREQ_OUT    : INTEGER );
        Port      ( CLK_IN      : in STD_LOGIC;
                    CLK_OUT     : out STD_LOGIC );
    end component;

    component btn_debounce      -- single signal line button debouncer
            Generic   ( active_mode         : STD_LOGIC := '1';
                        threshold_active    : INTEGER   := 100;
                        threshold_inactive  : INTEGER   := 100 );
            Port      ( CLK     : in STD_LOGIC; 
                        BTN_IN  : in STD_LOGIC;
                        BTN_DB  : out STD_LOGIC := not active_mode );
    end component;

    signal BTN_CLK : STD_LOGIC;

begin

    div : clk_div_freq          -- shared clock divider
        generic map   ( FREQ_IN     => clk_freq,
                        FREQ_OUT    => btn_freq )
        port map      ( CLK_IN      => CLK,
                        CLK_OUT     => BTN_CLK );

    -- generate a debouncer component per signal line as required
    gen_db : for btn in 0 to num_inputs - 1 generate
        db : btn_debounce
            generic map   ( active_mode         => active_mode,
                            threshold_active    => threshold_active,
                            threshold_inactive  => threshold_inactive )
            port map      ( CLK                 => BTN_CLK,
                            BTN_IN              => BTN_IN(btn),
                            BTN_DB              => BTN_DB(btn) );
    end generate;

end Structural;