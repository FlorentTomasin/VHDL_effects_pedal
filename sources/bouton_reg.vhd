----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2016 10:39:29
-- Design Name: 
-- Module Name: detect_impulsion - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Bouton state control  
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

entity detect_impulsion is
    Port ( input : in STD_LOGIC;
           horloge : in STD_LOGIC;
           output : out STD_LOGIC);
end detect_impulsion;

architecture Behavioral of detect_impulsion is
signal memo: std_logic;

begin

-- ====================================================================================
-- Apply XOR operator on memorized and input signal to locate change on the bouton state
-- ====================================================================================
    
    process ( horloge)
        begin
            if ( horloge='1' and horloge'event) then
                output <= ( memo xor input ) and input;
                memo<=input;
            end if;
     end process ;
     
end Behavioral;
