----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2015 11:02:06
-- Design Name: 
-- Module Name: mod8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Mod 8 is used to control ss_segment
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod8 is
    Port ( CEperception : in STD_LOGIC;
           clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           sortie : out STD_LOGIC_VECTOR (2 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end mod8;

architecture Behavioral of mod8 is

signal cpt : integer range 0 to 7;

begin

--  ===================================================================================
-- 						Pass from a SS to another at the 3kHz frequency
--  ===================================================================================
seq_selection : process(clk,raz)
begin
    if (raz='1') then
        cpt <= 0;
    elsif (clk'event and clk='1') then  
        if (CEperception='1') then
           if (cpt=7) then
                 cpt <= 0;
           else
                 cpt <= cpt + 1;
           end if; 
        end if;   
    end if;
end process seq_selection;

-----------------------------------


---------------------------------------------
--  ===================================================================================
-- 							  		output
--  ===================================================================================
comb_selection : process(cpt)
begin
case cpt is
    when 0 =>
        AN <= "11111110";
    when 1 =>
        AN <= "11111101";
    when 2 =>
        AN <= "11111011"; 
    when 3 =>
        AN <= "11110111";
    when 4 =>
    	AN <= "11101111";
    when 5 => 
        AN <= "11011111";
    when 6 => 
        AN <= "10111111";
    when 7 => 
        AN <= "01111111";
    when others =>
        AN <= "11111110";
end case;  
sortie <= std_logic_vector(to_unsigned(integer(cpt),3));
end process comb_selection;

end Behavioral;
