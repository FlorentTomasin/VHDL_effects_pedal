----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2016 15:32:49
-- Design Name: 
-- Module Name: tremolo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:  tremolo effect
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

entity tremolo is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            CS : in std_logic;
            LAUNCH : in STD_LOGIC; 
            f_sinus : in integer;

            idata : in std_logic_vector(11 downto 0);
            
            odata : out std_logic_vector(11 downto 0)
            );
end tremolo;

architecture Behavioral of tremolo is

type memory_type is array (0 to 19) of integer range -8 to 8;

signal sine : memory_type :=(0,2,5,6,7,8,7,6,5,2,0,-2,-5,-6,-7,-8,-7,-6,-5,-2);
signal freq,cpt : integer range 0 to 50000;
signal cpt_sinus : integer range 0 to 19;
signal tmp : integer range -4096 to 4095;

begin

freq <= f_sinus;

--  ===================================================================================
-- 							 generate a CE at the selected modulation frequency
--  ===================================================================================

diviseur_f : process(clk)
begin
   if (clk'event and clk='1') then
       if(rst = '1' ) then
           cpt <= 0;
           cpt_sinus <=0;
       elsif (CS ='1' ) then
           
           if(cpt_sinus=19) then
               cpt_sinus <=0;
           end if;
           
           if (cpt > freq or cpt = freq) then
               cpt <= 0;
               cpt_sinus <= cpt_sinus + 1;
               tmp <=(to_integer(signed(idata))*(sine(cpt_sinus)));
           else
               cpt <= cpt + 20;--ajout de 20 en 20 au lieu de 1 en 1
           end if;
       end if;
   end if;
end process;

--  ===================================================================================
-- 					synchronious output at the sampling frequency
--  ===================================================================================

process(clk)
begin
    if (clk'event and clk='1') then
        if (CS ='1' ) then 
            if( LAUNCH ='1') then
                odata <= std_logic_vector(to_signed(to_integer(signed(idata)+tmp/8)/2,12)); --depth = 0.4
            else
                odata <= "000000000000";
            end if;
         end if;
    end if;
end process;

end Behavioral;
