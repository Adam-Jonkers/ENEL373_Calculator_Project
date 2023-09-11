----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Chris Huynh
-- 
-- Create Date: 18.04.2023 16:46:09
-- Design Name: alu
-- Module Name: alu0 - Behavioral
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: alu for the calculator including addition, substraction, multiplication, division and power
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
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Generic   ( input_width     : INTEGER := 12;
                output_width    : INTEGER := 24;
                opcode_width    : INTEGER := 3;
                error_width     : INTEGER := 12 );
                
    Port      ( OPCODE          : in STD_LOGIC_VECTOR (opcode_width - 1 downto 0);
                NUM_1           : in STD_LOGIC_VECTOR (input_width - 1 downto 0);
                NUM_2           : in STD_LOGIC_VECTOR (input_width - 1 downto 0);
                RESULT_OUT      : out STD_LOGIC_VECTOR (output_width - 1 downto 0);
                ERROR_NUM       : out STD_LOGIC_VECTOR (error_width - 1 downto 0);
                ERROR_STATE     : out STD_LOGIC );
end alu;

architecture Behavioral of alu is

begin
    process (OPCODE, NUM_1, NUM_2)
        variable result         : SIGNED (output_width - 1 downto 0);
        variable prev_result    : SIGNED (output_width - 1 downto 0);
        variable err_num        : UNSIGNED (error_width - 1 downto 0);
        variable err_state      : STD_LOGIC;    
    
    begin
        err_num := to_unsigned(0, error_width);
        err_state := '0';

        
        case to_integer(unsigned(OPCODE)) is 
            when 0 =>       -- addition a+b
                result := resize(signed(NUM_1), output_width) + resize(signed(NUM_2), output_width);
                
            when 1 =>       -- substraction a-b
                result := resize(signed(NUM_1), output_width) - resize(signed(NUM_2), output_width);
                
            when 2 =>       -- multiplication a*b
                result := signed(NUM_1) * signed(NUM_2);
            
            when 3 =>       -- divide a/b
                if signed(NUM_2) = 0 then               -- detect dividion by b=0
                    err_state := '1';

                    err_num := to_unsigned(2, error_width);
                    result :=  to_signed(0, output_width);
                else
                    result := resize(signed(NUM_1), output_width) / resize(signed(NUM_2), output_width);
                end if;
                
            when 4 =>       -- exponent function a^b

                if signed(NUM_2) < 0 then               -- error if negative exponent given (avoid repeated division)
                    err_state := '1';
                    err_num := to_unsigned(3, error_width);
                    result :=  to_signed(0, output_width);

                elsif signed(NUM_2) = 0 then            -- result for b = 0
                    result := to_signed(1, output_width);

                -- values of a that will not overflow
                elsif signed(NUM_1) = 0 then            -- result for a = 0, b /= 0
                    result := to_signed(0, output_width);
                
                elsif signed(NUM_1) = 1 then            -- result if a = 1, avoid multiplication
                    result := to_signed(1, output_width);
                
                elsif signed(NUM_1) = -1 then           -- result if a = -1, depending on odd/even exponent
                    if NUM_2(NUM_2'right) = '1' then
                        result := to_signed(-1, output_width);
                    else
                        result := to_signed(1, output_width);
                    end if;
                
                -- calculate function value for other cases
                elsif signed(NUM_2) > 23 then           -- avoids calculation if overflow guaranteed (output limited to -2^23 to 2^23 - 1)
                    err_state := '1';
                    err_num := to_unsigned(4, error_width);
                    result :=  to_signed(0, output_width);
                    
                else                                    -- calculate other cases
                    result := to_signed(1, output_width);   -- starts multiplication at 1, i.e. a^0
                    for exponent in 1 to 23 loop
                        prev_result := result;

                        if exponent <= signed(NUM_2) then       -- conduct multiplication if exponent value not reached
                            result :=  to_signed(to_integer(result) * to_integer(signed(NUM_1)), output_width);
                            
                            if to_integer(prev_result) /= (to_integer(result) / to_integer(signed(NUM_1))) then     -- check for overflow of result
                                err_state := '1';
                                err_num := to_unsigned(4, error_width);
                                result :=  to_signed(0, output_width);
                             end if;
                        end if;
                        

                    end loop;

                end if;
            
            when others =>  -- detect invalid opcodes
                err_state := '1';
                err_num := to_unsigned(1, error_width);
                result :=  to_signed(0, output_width);
                
        end case;
        
        RESULT_OUT <= STD_LOGIC_VECTOR(result);
        ERROR_NUM <= STD_LOGIC_VECTOR(err_num);
        ERROR_STATE <= err_state;

    end process;

end Behavioral;
