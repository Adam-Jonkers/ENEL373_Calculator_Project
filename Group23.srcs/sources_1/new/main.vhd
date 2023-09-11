----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Adam Jonkers
-- 
-- Create Date: 04/21/2023 07:32:05 AM
-- Design Name: Main file
-- Module Name: Input - Structural
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: main file to control the calculator
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port         ( SW                         : in STD_LOGIC_VECTOR (11 downto 0);
                   BTNC                       : in STD_LOGIC;
                   BTNU                       : in STD_LOGIC;
                   BTNR                       : in STD_LOGIC;
                   LED                        : out STD_LOGIC_VECTOR (15 downto 0);
                   AN                         : out STD_LOGIC_VECTOR (7 downto 0);
                   CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC;
                   CLK100MHZ                  : in STD_LOGIC);
end main;

architecture Structural of main is

    component FSM -- Finite State Machine
            Port  ( trigger     : in STD_LOGIC;
                    carry       : in STD_LOGIC;
                    reset       : in STD_LOGIC;
                    overflow    : in STD_LOGIC;
                    aluErr      : in STD_LOGIC;
                    clk         : in STD_LOGIC;
                    OPCODE      : in STD_LOGIC_VECTOR(2 downto 0);
                    enableReg1  : out STD_LOGIC;
                    enableReg2  : out STD_LOGIC;
                    enableReg3  : out STD_LOGIC;
                    enableAlu   : out STD_LOGIC;
                    enableLed   : out STD_LOGIC;
                    enableCarry : out STD_LOGIC;
                    enableError : out STD_LOGIC;
                    enableSwitch: out STD_LOGIC);
    end component;
    
    component debounce_buttons -- button debouncer
        Generic   ( num_inputs          : INTEGER   := 1;
                    clk_freq            : INTEGER   := 100000000;
                    btn_freq            : INTEGER   := 1000000;
                    active_mode         : STD_LOGIC := '1';
                    threshold_active    : INTEGER   := 100;
                    threshold_inactive  : INTEGER   := 100 );
                    
        Port      ( CLK                 : in STD_LOGIC;
                    BTN_IN              : in STD_LOGIC_VECTOR (num_inputs - 1 downto 0);
                    BTN_DB              : out STD_LOGIC_VECTOR (num_inputs - 1 downto 0) := (others => not active_mode) );
    end component;

    component reg -- Registers for the inputs
        Generic   ( bus_width   : integer := 12);
        
        Port      ( EN          : in STD_LOGIC;
                    CLK         : in STD_LOGIC;
                    DATA_IN     : in STD_LOGIC_VECTOR (bus_width - 1 downto 0);
                    DATA_OUT    : out STD_LOGIC_VECTOR (bus_width - 1 downto 0));
    end component;

    component tristate_expand -- expanded tristae buffer
        Generic   ( input_width     : INTEGER   := 12;
                    output_width    : INTEGER   := 24;
                    twos_comp       : STD_LOGIC := '0');
                    
        Port      ( ENABLE          : in STD_LOGIC;
                    DATA_IN         : in STD_LOGIC_VECTOR(input_width - 1 downto 0);
                    DATA_OUT        : out STD_LOGIC_VECTOR(output_width - 1 downto 0) );
    end component;
    
    component tri_buf -- tristate buffer
        Generic   ( bus_width : integer := 12);
        Port      (  EN       : in STD_LOGIC;
                    DATA_IN   : in STD_LOGIC_VECTOR (bus_width - 1 downto 0);
                    DATA_OUT  : out STD_LOGIC_VECTOR (bus_width - 1 downto 0));
    end component;
    
    component disp_led -- LED display
        Port      ( ENABLE_REG_1    : in STD_LOGIC;
                    ENABLE_REG_2    : in STD_LOGIC;
                    ENABLE_REG_3    : in STD_LOGIC;
                    ENABLE_ALU      : in STD_LOGIC;
                    ENABLE_LED      : in STD_LOGIC;
                    BIN             : in STD_LOGIC_VECTOR(11 downto 0);
                    LED             : out STD_LOGIC_VECTOR (15 downto 0) );
    end component;
  
    component display -- 7-segment display
        Generic   ( clk_freq    : INTEGER := 100000000;
                    disp_freq   : INTEGER := 25;
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
    end component;
  
    component alu -- ALU 
        Generic   ( input_width     : INTEGER := 12;
                    output_width    : INTEGER := 24;
                    opcode_width    : INTEGER := 3; 
                    error_width     : INTEGER := 12 );
                    
        Port      ( OPCODE          : in STD_LOGIC_VECTOR (opcode_width - 1 downto 0);
                    NUM_1           : in STD_LOGIC_VECTOR (input_width - 1 downto 0);
                    NUM_2           : in STD_LOGIC_VECTOR (input_width - 1 downto 0);
                    RESULT_OUT      : out STD_LOGIC_VECTOR (output_width - 1 downto 0);
                    ERROR_NUM       : out STD_LOGIC_VECTOR(error_width - 1 downto 0);
                    ERROR_STATE     : out STD_LOGIC);
    end component;
    
    component overflow_check -- overflow check for carry
        Generic   ( bin_size    : INTEGER := 24;
                    target_size : INTEGER := 12);
                    
        Port      ( BIN_IN      : in STD_LOGIC_VECTOR (bin_size - 1 downto 0);
                    OVERFLOW    : out STD_LOGIC);
   end component;
   
   component error_select is -- Error selection for 7-segment output
        Generic   ( error_width     : INTEGER := 12 );
        
        Port      ( DISP_ERROR      : in STD_LOGIC;
                    OVFL_ERROR      : in STD_LOGIC;
                    ALU_ERR_NUM     : in STD_LOGIC_VECTOR(error_width - 1 downto 0);
                    OVFL_ERR_NUM    : in STD_LOGIC_VECTOR(error_width - 1 downto 0);
                    DISP_ERR_NUM    : out STD_LOGIC_VECTOR(error_width - 1 downto 0) );
    end component;

    -- Global Constants
    constant clk_freq       : INTEGER := 100000000;     -- system clock frequency
    constant disp_freq      : INTEGER := 500;           -- refresh rate frequency for display (currently unused)
    constant bin_in_size    : INTEGER := 12;
    constant bin_bus_size   : INTEGER := 24;
    constant opcode_size    : INTEGER := 3;
    constant num_segs       : INTEGER := 8;
    constant seg_size       : INTEGER := 4;
    constant bcd_size       : INTEGER := num_segs * seg_size;

    -- Binary bus connections
    signal INPUT_BUS    : STD_LOGIC_VECTOR (bin_in_size - 1 downto 0);
    signal BIN_BUS      : STD_LOGIC_VECTOR (bin_bus_size - 1 downto 0);
    signal ALU_OUT      : STD_LOGIC_VECTOR (bin_bus_size - 1 downto 0);
    signal REG1_OUT     : STD_LOGIC_VECTOR (bin_in_size - 1 downto 0);
    signal REG2_OUT     : STD_LOGIC_VECTOR (opcode_size - 1 downto 0);
    signal REG3_OUT     : STD_LOGIC_VECTOR (bin_in_size - 1 downto 0);
    
    
    -- State Machine control signals
    signal enableReg1   : STD_LOGIC;
    signal enableReg2   : STD_LOGIC;
    signal enableReg3   : STD_LOGIC;
    signal enableAlu    : STD_LOGIC;
    signal enableLed    : STD_LOGIC;
    signal enableCarry  : STD_LOGIC;
    signal enableError  : STD_LOGIC;
    signal enableSwitch : STD_LOGIC;
    signal aluErr       : STD_LOGIC;
    signal overflow     : STD_LOGIC;
    
    -- Button debouncing setup
    constant btn_freq           : INTEGER     := 1000000;     -- reduced button frequency to reduce counter size
    constant btn_active_mode    : STD_LOGIC   := '1';         -- button pressed signal value
    constant btn_thres_active   : INTEGER     := 100;         -- button settling time when pressed
    constant btn_thres_inactive : INTEGER     := 100;         -- button settling time when released
    signal BTNU_DB              : STD_LOGIC;   -- debounced button up
    signal BTNC_DB              : STD_LOGIC;   -- debounced button centre
    signal BTNR_DB              : STD_LOGIC;   -- debounced button right
    
    -- Error code control (displays only when in error state)
    constant err_size           : INTEGER := bin_in_size;
    constant ERR_NUM_OVERFLOW   : STD_LOGIC_VECTOR(err_size - 1 downto 0) := std_logic_vector(to_unsigned(5, err_size));
    signal ERR_NUM_ALU          : STD_LOGIC_VECTOR(err_size - 1 downto 0) := (others => '0');
    signal ERR_NUM_DISP         : STD_LOGIC_VECTOR(err_size - 1 downto 0) := (others => '0');
  
begin

    reg1 : reg -- register for the first input number
        generic map   ( bus_width           => bin_in_size)
        
        port map      ( EN                  => enableReg1,
                        CLK                 => CLK100MHZ,
                        DATA_IN             => INPUT_BUS,
                        DATA_OUT            => REG1_OUT);

    reg2 : reg -- register for the input opcode
        generic map   ( bus_width           => opcode_size)
        
        port map      ( EN                  => enableReg2,
                        CLK                 => CLK100MHZ,
                        DATA_IN             => INPUT_BUS(opcode_size - 1 downto 0),
                        DATA_OUT            => REG2_OUT);

    reg3 : reg -- register for the second input number
        generic map   ( bus_width           => bin_in_size)
        
        port map      ( EN                  => enableReg3,
                        CLK                 => CLK100MHZ,
                        DATA_IN             => INPUT_BUS,
                        DATA_OUT            => REG3_OUT);
                        
    tri1 : tristate_expand
        generic map   ( input_width         => bin_in_size,
                        output_width        => bin_bus_size,
                        twos_comp           => '1')
                        
        port map      ( ENABLE              => enableReg1,
                        DATA_IN             => REG1_OUT,
                        DATA_OUT            => BIN_BUS );
                        
    tri2 : tristate_expand
        generic map   ( input_width         => opcode_size,
                        output_width        => bin_bus_size,
                        twos_comp           => '0')
                        
        port map      ( ENABLE              => enableReg2,
                        DATA_IN             => REG2_OUT,
                        DATA_OUT            => BIN_BUS );
                        
    tri3 : tristate_expand
        generic map   ( input_width         => bin_in_size,
                        output_width        => bin_bus_size,
                        twos_comp           => '1')
                        
        port map      ( ENABLE              => enableReg3,
                        DATA_IN             => REG3_OUT,
                        DATA_OUT            => BIN_BUS );
                        
    btdb : debounce_buttons
        generic map   ( num_inputs          => 3,
                        clk_freq            => clk_freq,
                        btn_freq            => btn_freq,
                        active_mode         => btn_active_mode,
                        threshold_active    => btn_thres_active,
                        threshold_inactive  => btn_thres_inactive)
                        
        port map      ( CLK                 => CLK100MHZ,
                        BTN_IN(2)           => BTNU,
                        BTN_IN(1)           => BTNC,
                        BTN_IN(0)           => BTNR,
                        BTN_DB(2)           => BTNU_DB,
                        BTN_DB(1)           => BTNC_DB,
                        BTN_DB(0)           => BTNR_DB );
                        
    ovf : overflow_check
        generic map   ( bin_size => bin_bus_size,
                        target_size => bin_in_size)
                        
        port map      ( BIN_IN => ALU_OUT,
                        OVERFLOW => overflow);
               
    FSM1: FSM
        port map      ( trigger         => BTNC_DB,
                        carry           => BTNR_DB,
                        reset           => BTNU_DB,
                        overflow        => overflow,
                        aluErr          => aluErr,
                        clk             => CLK100MHZ,
                        OPCODE          => REG2_OUT,
                        enableReg1      => enableReg1,
                        enableReg2      => enableReg2,
                        enableReg3      => enableReg3,
                        enableAlu       => enableAlu,
                        enableLed       => enableLed,
                        enableCarry     => enableCarry,
                        enableError     => enableError,
                        enableSwitch    => enableSwitch);
        
    alu0: alu
        generic map   ( input_width     => bin_in_size,
                        output_width    => bin_bus_size,
                        opcode_width    => opcode_size,
                        error_width     => err_size )
                        
        port map      ( OPCODE          => REG2_OUT,
                        NUM_1           => REG1_OUT,
                        NUM_2           => REG3_OUT,
                        RESULT_OUT      => ALU_OUT,
                        ERROR_NUM       => ERR_NUM_ALU,
                        ERROR_STATE     => aluErr); 
   
    trialu : tri_buf
        generic map   ( bus_width       => bin_bus_size)
        
        port map      ( EN              => enableAlu,
                        DATA_IN         => ALU_OUT,
                        DATA_OUT        => BIN_BUS);    

    dled : disp_led
        port map      ( ENABLE_REG_1    => enableReg1,
                        ENABLE_REG_2    => enableReg2,
                        ENABLE_REG_3    => enableReg3,
                        ENABLE_ALU      => enableAlu,
                        ENABLE_LED      => enableLed,
                        BIN             => BIN_BUS(11 downto 0),
                        LED             => LED );
    
    dseg : display
        generic map   ( clk_freq        => clk_freq,
                        disp_freq       => disp_freq,
                        err_size        => err_size,
                        bin_size        => bin_bus_size,
                        num_segs        => num_segs,
                        seg_size        => seg_size )
                        
        port map      ( CLK100MHZ       => CLK100MHZ,
                        ENABLE          => '1',
                        ERR_NUM         => ERR_NUM_DISP,
                        BIN_DAT         => BIN_BUS,
                        AN              => AN,
                        CA              => CA,
                        CB              => CB,
                        CC              => CC,
                        CD              => CD,
                        CE              => CE,
                        CF              => CF,
                        CG              => CG );
    
    derr : error_select
        generic map   ( error_width     => err_size)
        
        port map      ( DISP_ERROR      => enableError,
                        OVFL_ERROR      => OVERFLOW,
                        ALU_ERR_NUM     => ERR_NUM_ALU,
                        OVFL_ERR_NUM    => ERR_NUM_OVERFLOW,
                        DISP_ERR_NUM    => ERR_NUM_DISP );

    insw : tri_buf
        generic map   ( bus_width       => bin_in_size)
        
        port map      ( EN              => enableSwitch,
                        DATA_IN         => SW,
                        DATA_OUT        => INPUT_BUS);

    inalu : tri_buf
        generic map   ( bus_width       => bin_in_size)
        
        port map      ( EN              => enableCarry,
                        DATA_IN         => ALU_OUT(11 downto 0),
                        DATA_OUT        => INPUT_BUS);

end Structural;
