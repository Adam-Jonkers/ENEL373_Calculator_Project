----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 17:15:35
-- Design Name: 
-- Module Name: display - Structural
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: main 7-segment display control module, takes error number and
--              binary value inputs and returns control signals for AN and CA-G ports
-- 
-- Dependencies: 
-- clk_div_freq.vhd
-- counter_with_overflow.vhd
-- decoder.vhd
-- display_bcd_formatter.vhd
-- mux.vhd
-- BCD_to_7SEG.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
    Generic   ( clk_freq    : INTEGER := 100000000;
                disp_freq   : INTEGER := 500;
                err_size    : INTEGER := 12;
                bin_size    : INTEGER := 24;
                num_segs    : INTEGER := 8;
                seg_size    : INTEGER := 4 );
    Port      ( CLK100MHZ   : in STD_LOGIC;
                ENABLE      : in STD_LOGIC;
                ERR_NUM     : in STD_LOGIC_VECTOR(err_size - 1 downto 0);
                BIN_DAT     : in STD_LOGIC_VECTOR (bin_size - 1 downto 0);
                AN          : out STD_LOGIC_VECTOR (num_segs - 1 downto 0);
                CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC );
end display;

architecture Structural of display is
    
    -- OR all bits in input vector (from bcd_blanker.vhd)
    function or_reduce (input : std_logic_vector) return std_logic is
        variable result : std_logic;
    begin
        result := '0';
        for i in input'range loop
            result := result or input(i);
        end loop;
        return result;
    end function;
    
    component clk_div_freq
        Generic   ( FREQ_IN     : INTEGER;
                    FREQ_OUT    : INTEGER );
        Port      ( CLK_IN      : in STD_LOGIC;
                    CLK_OUT     : out STD_LOGIC );
    end component;
    
    component counter
        Generic   ( max_count   : integer := 9 );
        Port      ( clk         : in std_logic;
                    count       : out std_logic_vector (3 downto 0);
                    overflow    : out std_logic );
    end component;
    
    component decoder
        Generic   ( input_count     : INTEGER := 4;
                    output_count    : INTEGER := 8 );
        Port      ( VAL             : in STD_LOGIC_VECTOR (input_count - 1 downto 0);
                    SEL             : out STD_LOGIC_VECTOR (output_count - 1 downto 0) );
    end component;
    
    component display_bcd_formatter
        Generic   ( num_size    : INTEGER;
                    num_segs    : INTEGER;
                    seg_size    : INTEGER );
        Port      ( BIN         : in STD_LOGIC_VECTOR;
                    BCD         : out STD_LOGIC_VECTOR );
    end component;
    
    component mux
        Generic   ( sel_size    : INTEGER := 4;
                    data_size   : INTEGER := 4;
                    input_count : INTEGER := 8 );
        Port      ( INPUT       : in STD_LOGIC_VECTOR (data_size * input_count - 1 downto 0);
                    SEL         : in STD_LOGIC_VECTOR (sel_size - 1 downto 0);
                    OUTPUT      : out STD_LOGIC_VECTOR (data_size - 1 downto 0) );
    end component;
    
    component BCD_to_7SEG
        Port      ( bcd_in: in std_logic_vector (3 downto 0);
                    leds_out: out	std_logic_vector (1 to 7) );
    end component;
    
    constant bcd_size       : INTEGER := num_segs * seg_size;
    constant disp_sel_size  : INTEGER := 4;
    constant ERR_CODE       : STD_LOGIC_VECTOR (bcd_size - 17 downto 0) := (bcd_size - 17 downto 12 => '1') & X"dcc";
    
    signal BIN      : STD_LOGIC_VECTOR (bin_size - 1 downto 0);
    
    signal DISP_CLK : STD_LOGIC;
    signal DISP_CTR : STD_LOGIC_VECTOR (disp_sel_size - 1 downto 0);
    signal DISP_SEL : STD_LOGIC_VECTOR (num_segs - 1 downto 0);
    
    signal BCD_FMT  : STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0);
    signal BCD_DAT  : STD_LOGIC_VECTOR (num_segs * seg_size - 1 downto 0);
    signal BCD_SEL  : STD_LOGIC_VECTOR (seg_size - 1 downto 0);
    
    signal ERR      : STD_LOGIC := '0';
    
begin

    clk_div_disp : clk_div_freq     -- clock divider for display refresh
        generic map   ( FREQ_IN     => clk_freq,
                        FREQ_OUT    => disp_freq * num_segs )
        port map      ( CLK_IN      => CLK100MHZ,
                        CLK_OUT     => DISP_CLK );
        
    disp_ctrl : counter             -- display selection (binary)
        generic map   ( max_count   => num_segs - 1 )
        port map      ( clk         => DISP_CLK,
                        count       => DISP_CTR );
    
    an_ctrl : decoder               -- one-hot selection from binary for anode control
        generic map   ( input_count     => disp_sel_size,
                        output_count    => num_segs )
        port map      ( VAL             => DISP_CTR,
                        SEl             => DISP_SEL );
    
    bcd : display_bcd_formatter     -- binary to (formatted) BCD conversion
        generic map   ( num_size    => bin_size,
                        num_segs    => num_segs,
                        seg_size    => seg_size )
        port map      ( BIN         => BIN,
                        BCD         => BCD_FMT );
    
    mux_32to4 : mux                 -- selection of BCD digit based on display selection
        generic map   ( sel_size    => disp_sel_size,
                        data_size   => seg_size,
                        input_count => num_segs )
        port map      ( INPUT       => BCD_DAT,
                        SEL         => DISP_CTR,
                        OUTPUT      => BCD_SEL );
    
    bcd_7seg : BCD_to_7SEG          -- controls display segments, 0-9 and special characters
        port map      ( bcd_in => BCD_SEL,
                        leds_out(1) => CA,
                        leds_out(2) => CB,
                        leds_out(3) => CC,
                        leds_out(4) => CD,
                        leds_out(5) => CE,
                        leds_out(6) => CF,
                        leds_out(7) => CG );
    
    ERR <= or_reduce(ERR_NUM);      -- generates a flag when the error number is non-zero

    with ERR select BIN <=          -- puts error number through BCD conversion when non-zero
        (bin_size - 1 downto err_size => '0') & ERR_NUM when '1',
        BIN_DAT when others;

    with ERR select BCD_DAT <=      -- puts error statement 'Err' into BCD vector when error num is non-zero
        ERR_CODE & BCD_FMT(15 downto 0) when '1',
        BCD_FMT when others;
    
    with ENABLE select AN <=        -- inverts anode control (active low) and allows display to be deactivated
        not DISP_SEL when '1',
        (others => '1') when '0';

end Structural;
