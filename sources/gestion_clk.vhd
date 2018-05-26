----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2016 14:55:44
-- Design Name: 
-- Module Name: gestion_clk - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gestion_clk is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           CE : out STD_LOGIC);
end gestion_clk;

architecture Behavioral of gestion_clk is

signal cpt : INTEGER range 0 to 2266 :=0;

begin

--  ===================================================================================
-- 	Divide with a counter the clock frequency at the sampling frequency (44.1kHz)
--  ===================================================================================

    process(clk,raz)
    begin
        if (raz='1') then 
           CE <= '0';
        elsif ( clk'event and clk='1') then
            if ( cpt = 2266) then
                cpt <= 0;
                CE <= '1';
            else
                cpt <= cpt + 1;
                CE <= '0';
            end if;
        end if;
    end process;
        
end Behavioral;
