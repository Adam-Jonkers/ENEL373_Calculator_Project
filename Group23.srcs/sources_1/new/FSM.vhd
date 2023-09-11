----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Adam Jonkers
-- 
-- Create Date: 18.04.2023 16:36:47
-- Design Name: Finite State Machine
-- Module Name: FSM - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Finite State Machine for the calculator 
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

entity FSM is
    Port (  trigger     : in STD_LOGIC;
            carry       : in STD_LOGIC;
            reset       : in STD_LOGIC;
            overflow    : in STD_LOGIC;
            aluErr      : in STD_LOGIC;
            clk         : in STD_LOGIC;
            OPCODE      : in STD_LOGIC_VECTOR (2 downto 0);
            enableReg1  : out STD_LOGIC;
            enableReg2  : out STD_LOGIC;
            enableReg3  : out STD_LOGIC;
            enableAlu   : out STD_LOGIC;
            enableLed   : out STD_LOGIC;
            enableCarry : out STD_LOGIC;
            enableError : out STD_LOGIC;
            enableSwitch: out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is

    type State_type is (LoadNum1, LoadOpcode, LoadNum2, DisplayResult, CarryResult, Error);
    signal State               : State_Type := LoadNum1;   
    signal lastTriggerState    : STD_LOGIC := '0';
    signal lastCarryState      : STD_LOGIC := '0';
    
begin
  
  process (clk, reset)
  begin
  
    if(reset = '1') then
        State <= LoadNum1;
        enableReg1 <= '1';
        enableReg2 <= '0';
        enableReg3 <= '0';
        enableAlu  <= '0';
        enableLed  <= '1';
        enableCarry <= '0';
        enableError <= '0';
        enableSwitch <= '1';
        
    elsif rising_edge(clk) then
        case State is
            when LoadNum1 =>
                if (trigger = '1' and lastTriggerState = '0') then
                    State <= LoadOpcode;
                    enableReg1 <= '0';
                    enableReg2 <= '1';
                    enableReg3 <= '0';
                    enableAlu  <= '0';
                    enableLed  <= '1';
                    enableCarry <= '0';
                    enableError <= '0';
                    enableSwitch <= '1';
                end if;
                    
            when LoadOpcode =>
                if (trigger = '1' and lastTriggerState = '0') then
                   if (unsigned(OPCODE) > 4) then -- Change to error state if invalid OPCODE is receved
                        State <= Error;
                        enableReg1 <= '0';
                        enableReg2 <= '0';
                        enableReg3 <= '0';
                        enableAlu  <= '0';
                        enableLed  <= '0';
                        enableCarry <= '0';
                        enableError <= '1';
                        enableSwitch <= '0';
                    
                    else
                        State <= LoadNum2;
                        enableReg1 <= '0';
                        enableReg2 <= '0';
                        enableReg3 <= '1';
                        enableAlu  <= '0';
                        enableLed  <= '1';
                        enableCarry <= '0';
                        enableError <= '0';
                        enableSwitch <= '1';
                     end if;

                end if;
                
            when LoadNum2 =>
                if (trigger = '1' and lastTriggerState = '0') then
                    if (aluErr = '1') then -- Change to error state if error is receved from the ALU
                        State <= Error; -- next state is error
                        enableReg1 <= '0';
                        enableReg2 <= '0';
                        enableReg3 <= '0';
                        enableAlu  <= '0';
                        enableLed  <= '0';
                        enableCarry <= '0';
                        enableError <= '1';
                        enableSwitch <= '0';
                    else
                        State <= DisplayResult;
                        enableReg1 <= '0';
                        enableReg2 <= '0';
                        enableReg3 <= '0';
                        enableAlu  <= '1';
                        enableLed  <= '0';
                        enableCarry <= '0';
                        enableError <= '0';
                        enableSwitch <= '0';
                        
                    end if;
                end if;
                
            when DisplayResult =>
                if (trigger = '1' and lastTriggerState = '0') then
                    State <= LoadNum1;
                    enableReg1 <= '1';
                    enableReg2 <= '0';
                    enableReg3 <= '0';
                    enableAlu  <= '0';
                    enableLed  <= '1';
                    enableCarry <= '0';
                    enableError <= '0';
                    enableSwitch <= '1';
                    
                elsif (carry = '1' and lastCarryState = '0') then
                    if overflow = '1' then -- Change to error state if the result is larger than 12 bits
                        State <= Error;
                        enableReg1 <= '0';
                        enableReg2 <= '0';
                        enableReg3 <= '0';
                        enableAlu  <= '0';
                        enableLed  <= '0';
                        enableCarry <= '0';
                        enableError <= '1';
                        enableSwitch <= '0';
                        
                    else
                        State <= CarryResult;
                        enableReg1 <= '1';
                        enableReg2 <= '0';
                        enableReg3 <= '0';
                        enableAlu  <= '0';
                        enableLed  <= '1';
                        enableCarry <= '1';
                        enableError <= '0';
                        enableSwitch <= '0';
                    end if;
                end if;
                
            when CarryResult =>
                State <= LoadOpcode;
                enableReg1 <= '0';
                enableReg2 <= '1';
                enableReg3 <= '0';
                enableAlu  <= '0';
                enableLed  <= '1';
                enableCarry <= '0';
                enableError <= '0';
                enableSwitch <= '1';
                
            when Error =>
                if (trigger = '1' and lastTriggerState = '0') then
                    State <= LoadNum1;
                    enableReg1 <= '1';
                    enableReg2 <= '0';
                    enableReg3 <= '0';
                    enableAlu  <= '0';
                    enableLed  <= '1';
                    enableCarry <= '0';
                    enableError <= '0';
                    enableSwitch <= '1';
                end if;
        end case;
        
        -- store states of buttons for detecting changes
        lastTriggerState <= trigger;
        lastcarryState <= carry;
        
    end if;
  end process;

end Behavioral;
