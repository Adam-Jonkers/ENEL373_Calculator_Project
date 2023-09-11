----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2023 21:16:07
-- Design Name: 
-- Module Name: alu_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

entity alu_tb_2 is
--  Port ( );
end alu_tb_2;

architecture Behavioral of alu_tb_2 is
component ALU
    Generic   ( input_width    : INTEGER := 12;
                output_width   : INTEGER := 24;
                opcode_width    : INTEGER := 3;
                error_width     : INTEGER := 12 );
                
    Port      ( OPCODE          : in STD_LOGIC_VECTOR (opcode_width - 1 downto 0);
                NUM_1           : in STD_LOGIC_VECTOR (input_width - 1 downto 0);
                NUM_2           : in STD_LOGIC_VECTOR (input_width - 1 downto 0);
                RESULT_OUT      : out STD_LOGIC_VECTOR (output_width - 1 downto 0);
                ERROR_NUM       : out STD_LOGIC_VECTOR (error_width - 1 downto 0);
                ERROR_STATE     : out STD_LOGIC );
           
end component;

signal OPCODE : STD_LOGIC_VECTOR (2 downto 0);
signal NUM_1 : STD_LOGIC_VECTOR (11 downto 0);
signal NUM_2 : STD_LOGIC_VECTOR (11 downto 0);
signal RESULT_OUT : STD_LOGIC_VECTOR (23 downto 0);
signal ERROR_OUT: STD_LOGIC_VECTOR(12 - 1 downto 0);
signal ERROR_STATE: STD_LOGIC;

begin
    uut: ALU port map (OPCODE => OPCODE,
                       NUM_1 => NUM_1,
                       NUM_2 => NUM_2,
                       RESULT_OUT => RESULT_OUT,
                       ERROR_NUM => ERROR_OUT,
                       ERROR_STATE => ERROR_STATE);
                       
    process
    begin
        OPCODE <= "000"; -- ADDITION
        
        NUM_1 <= "000000000011";
        NUM_2 <= "100000000011";
        wait for 50ns;
        
        NUM_1 <= "000000000011";
        NUM_2 <= "010000000011";
        wait for 50ns;
        
        OPCODE <= "001"; -- SUBSTRACTION
        
        NUM_1 <= "000000000011";
        NUM_2 <= "100000000011";
        wait for 50ns;
        
        NUM_1 <= "000000000011";
        NUM_2 <= "010000000011";
        wait for 50ns;
        
        OPCODE <= "010"; -- MULTIPLICATION
        
        NUM_1 <= "000000000011";
        NUM_2 <= "100000000011";
        wait for 50ns;
        
        NUM_1 <= "000000000011";
        NUM_2 <= "010000000011";
        wait for 50ns;
        
        OPCODE <= "011"; -- DIVISION
        
        NUM_1 <= "000000000011";
        NUM_2 <= "100000000011";
        wait for 50ns;
        
        NUM_1 <= "000000000011"; -- DIVIDE BY LARGER NUMBER
        NUM_2 <= "010000000011";
        wait for 50ns;
        
        NUM_1 <= "000000000011"; -- DIVIDE BY 0
        NUM_2 <= "000000000000";
        wait for 50ns;
        
        OPCODE <= "100"; -- POWER

        NUM_1 <= "000000000011"; --3^NEG
        NUM_2 <= "100000000011"; 
        wait for 50ns;
        
        NUM_1 <= "000001110111"; --BIG^BIG (OVERFLOW)
        NUM_2 <= "011111111111"; 
        wait for 50ns;
        
        NUM_1 <= "000000000001";
        NUM_2 <= "000000000011"; 
        wait for 50ns;

        NUM_1 <= "011111111111"; --2047^2
        NUM_2 <= "000000000010";
        wait for 50ns;

        NUM_1 <= "111111111111"; -- -1^2
        NUM_2 <= "000000000010";
        wait for 50ns;
 
        NUM_1 <= "111111111111"; -- -1^3
        NUM_2 <= "000000000011";
        wait for 50ns;

        NUM_1 <= "000000000000"; --0^
        NUM_2 <= "000000011000";
        wait for 50ns;

        NUM_1 <= "000000000000"; -- 0^0
        NUM_2 <= "000000000000";
        wait for 50ns;
        
        NUM_1 <= "011111111111"; --2047^0
        NUM_2 <= "000000000000";
        wait;
        
    end process;

end Behavioral;
