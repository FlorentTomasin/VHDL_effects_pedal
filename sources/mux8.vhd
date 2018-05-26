----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.09.2016 18:19:45
-- Design Name: 
-- Module Name: mux8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Mux 8 send data associati to the command (from MOD8)
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

entity mux8 is
    Port ( commande : in STD_LOGIC_VECTOR (2 downto 0);
           e0 : in STD_LOGIC_VECTOR (6 downto 0);
           e1 : in STD_LOGIC_VECTOR (6 downto 0);
           e2 : in STD_LOGIC_VECTOR (6 downto 0);
           e3 : in STD_LOGIC_VECTOR (6 downto 0);
           e4 : in STD_LOGIC_VECTOR (6 downto 0);
           e5 : in STD_LOGIC_VECTOR (6 downto 0);
           e6 : in STD_LOGIC_VECTOR (6 downto 0);
           e7 : in STD_LOGIC_VECTOR (6 downto 0);
           WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           DP : out STD_LOGIC;
           S : out STD_LOGIC_VECTOR (6 downto 0));
end mux8;

architecture Behavioral of mux8 is

signal cpt : integer range 0 to 7;
signal  WAIT_FOR_SELECT : std_logic;

begin

--  ===================================================================================
-- 							  				Associate a data to a SS
--  ===================================================================================
comb_selection : process(commande,cpt)
begin

WAIT_FOR_SELECT <=  WAIT_FOR_1 or WAIT_FOR_2 or WAIT_FOR_3 or WAIT_FOR_4;    

cpt <= to_integer(unsigned(commande));

case cpt is  
    when 7 =>
         S<=e0;
         DP<='1'; 
    when 6 =>
         S<=e1;
         DP<='1';
    when 5 =>
         S<=e2;
         DP<='1';
    when 4 =>
         S<=e3;
         DP<='1'; 
    when 3 =>
         S<=e4;
         DP<='1';
    when 2 =>
         S<=e5;
         if(WAIT_FOR_SELECT='1') then
            DP <= '0';
         else
            DP<='1';       
         end if;
    when 1 =>
         S<=e6;  
         DP<='0';       
    when others =>
         S<=e7;  
         DP<='0';       
end case;
end process;

end Behavioral;
