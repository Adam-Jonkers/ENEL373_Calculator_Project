----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 17.04.2023 15:47:35
-- Design Name: 
-- Module Name: bin_abs - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: Converts signed input value to unsigned absolute output and generates a negative flag
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



entity bin_abs is
    Generic   ( num_size    : INTEGER := 24 );
    Port      ( BIN_SIGNED  : in STD_LOGIC_VECTOR (num_size - 1 downto 0);
                BIN_UNSIGN  : out STD_LOGIC_VECTOR (num_size - 1 downto 0);
                NEGATIVE    : out STD_LOGIC );
end bin_abs;

architecture Dataflow of bin_abs is
    
begin

    NEGATIVE <= BIN_SIGNED(BIN_SIGNED'left);        -- determine the sign based on the most significant bit
    BIN_UNSIGN <= STD_LOGIC_VECTOR(abs(signed(BIN_SIGNED)));    -- return the absolute value of the binary value

end Dataflow;
