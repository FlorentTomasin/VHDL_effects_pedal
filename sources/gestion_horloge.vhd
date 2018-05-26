----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2015 22:43:56
-- Design Name: 
-- Module Name: gestion_horloge - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Clock control
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gestion_horloge is
    Port ( clk : in STD_LOGIC;
    	   raz : in STD_LOGIC;
           CEperception : out STD_LOGIC;
           CEdefilement : out STD_LOGIC
           );
end gestion_horloge;

architecture Behavioral of gestion_horloge is

signal CMPperception : integer :=0;
signal CMPdefilement : integer :=0;

begin


--  ===================================================================================
-- 	Divide with a counter the clock frequency at 3kHz
--  ===================================================================================

seq_frequence3kHz : process(clk,raz)
begin
    if (clk'event and clk='1') then
        if (raz='1') then
            CMPperception <= 0;
        elsif (CMPperception=33334) then
            CMPperception <= 0;
            CEperception <= '1';
        else 
            CMPperception <= CMPperception + 1;
            CEperception <= '0';
        end if;
    end if;
end process seq_frequence3kHz;

--  ===================================================================================
-- 	Divide with a counter the clock frequency at 3Hz
--  ===================================================================================

seq_frequence3Hz : process(clk,raz)
begin
    if (clk'event and clk='1') then
        if (raz='1') then
            CMPdefilement <= 0;
        elsif (CMPdefilement=33333333) then
            CMPdefilement <= 0;
            CEdefilement <= '1';
        else
            CMPdefilement <= CMPdefilement + 1;        
            CEdefilement <= '0';
        end if;
    end if;
end process seq_frequence3Hz;

end Behavioral;
