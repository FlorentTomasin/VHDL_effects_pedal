----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2016 14:10:12
-- Design Name: 
-- Module Name: PWM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: PWM 
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

entity PWM is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           idata : in STD_LOGIC_VECTOR (11 downto 0);
           CE : in STD_LOGIC;
           amp_SP: out STD_LOGIC;
           odata : out STD_LOGIC);      
end PWM;

architecture Behavioral of PWM is

signal N,tmp : INTEGER range 0 to 4096 :=0;
signal cpt : INTEGER range 0 to 4096 :=0;

begin

--  ===================================================================================
-- 				counter associate to the number max value of the input (max width of the output)
--  ===================================================================================
   cpt_4096 : process(clk,raz)
   begin
        if (raz = '1') then 
            cpt <= 0;
        elsif ( clk'event and clk = '1') then
            if (cpt = 4096) then
                cpt <= 0;
            else 
                cpt <= cpt + 1;
            end if;
        end if;
   end process;


--  ===================================================================================
-- 			defini une valeur max pour lequel la sortie sera a '1'
--  ===================================================================================   
   reg_decalage : process(clk,raz)
   begin
        if (raz='1') then
            N <= 0 ;
        elsif (clk'event and clk = '1') then
            if (CE = '1') then
                tmp <= to_integer(signed(idata)) + 2048;
                N <= tmp;
            else
                tmp <= tmp;
                N <= N;
            end if;
        end if;
   end process;
 
 
--  ===================================================================================
-- 		met a '1' la sortie temps que le compteur est inferieur a la valeur max, '0' sinon
--  ===================================================================================  
   comp : process (N,cpt)
   begin
        if (cpt < N) then
            odata <= '1';
        else 
            odata <= '0';
        end if;
    end process;
    
    amp_SP <= '1';

end Behavioral;
