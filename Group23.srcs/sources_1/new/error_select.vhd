----------------------------------------------------------------------------------
-- Company: UC, ECE
-- Author: William Beauchamp
-- 
-- Create Date: 07.05.2023 22:55:26
-- Design Name: 
-- Module Name: error_select - Dataflow
-- Project Name: TuesA01_Group_23
-- Target Devices: 
-- Tool Versions: 
-- Description: selects error to show on screen based on state (including none)
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


entity error_select is
    Generic   ( error_width     : INTEGER := 12 );
    Port      ( DISP_ERROR      : in STD_LOGIC;
                OVFL_ERROR      : in STD_LOGIC;
                ALU_ERR_NUM     : in STD_LOGIC_VECTOR(error_width - 1 downto 0);
                OVFL_ERR_NUM    : in STD_LOGIC_VECTOR(error_width - 1 downto 0);
                DISP_ERR_NUM    : out STD_LOGIC_VECTOR(error_width - 1 downto 0) );
end error_select;


architecture Dataflow of error_select is 

    constant NO_ERROR : STD_LOGIC_VECTOR(error_width - 1 downto 0) := (others => '0');  -- default state = 0

begin

    DISP_ERR_NUM <= OVFL_ERR_NUM when (DISP_ERROR = '1' and OVFL_ERROR = '1')   -- show overflow error code when in error state with an overflow
                else ALU_ERR_NUM when (DISP_ERROR = '1')                        -- show ALU error when in error state (other errors)
                else NO_ERROR;                                                  -- clear error code with no errors raised

end Dataflow;

