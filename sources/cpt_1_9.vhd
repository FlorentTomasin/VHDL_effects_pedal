----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2016 10:41:45
-- Design Name: 
-- Module Name: cpt_1_9 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Compteur modulo 9 
-- 
-- Dependencies: 1 to 9 counter
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

entity cpt_1_9 is
    Port ( decr : in STD_LOGIC;
           incr : in STD_LOGIC;
           horloge : in STD_LOGIC;
           CEdefilement : in std_logic;
           raz : in STD_LOGIC;
           sortie : out STD_LOGIC_VECTOR (3 downto 0));
end cpt_1_9;

architecture Behavioral of cpt_1_9 is

signal cpt : integer range 1 to 9:=5;

begin

-- ====================================================================================
-- 		increment the level of the sound following a 5Hz clock
-- ====================================================================================
seq_activation : process(horloge,raz)
begin
    if (raz='1') then
        cpt <= 5;
    elsif (horloge'event and horloge='1') then  
        if (CEdefilement ='1') then
            if (incr='1') then  --priorite a la montee du son
               if (cpt=9) then
                     cpt <= 9;
               else
                     cpt <= cpt + 1;
               end if;
            elsif (decr='1') then
                if (cpt=1) then
                      cpt <= 1;
                else
                      cpt <= cpt - 1;
                end if;
            end if;   
        end if;
    end if;
end process seq_activation;

-- ====================================================================================
-- 				sound level value (output)
-- ====================================================================================
comb_activation : process(cpt)
begin
case cpt is
    when 1 =>
        sortie <= std_logic_vector(to_unsigned(1,4));
    when 2 =>
        sortie <= std_logic_vector(to_unsigned(2,4));
    when 3 =>
        sortie <= std_logic_vector(to_unsigned(3,4));
    when 4 =>
        sortie <= std_logic_vector(to_unsigned(4,4));
    when 5 =>            
        sortie <= std_logic_vector(to_unsigned(5,4));
    when 6 =>
        sortie <= std_logic_vector(to_unsigned(6,4));
    when 7 =>
        sortie <= std_logic_vector(to_unsigned(7,4));
    when 8 =>
        sortie <= std_logic_vector(to_unsigned(8,4));
    when 9 =>
        sortie <= std_logic_vector(to_unsigned(9,4));
    when others =>
        sortie <= std_logic_vector(to_unsigned(5,4));
                                  
end case;      
end process comb_activation;

end Behavioral;
