----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2016 16:32:28
-- Design Name: 
-- Module Name: freq_sinus - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Accordeur simple générateur de sinus à fréquence paramétrés
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

entity freq_sinus is
    Port ( 
            launch              : in  STD_LOGIC;
            clk                 : in  STD_LOGIC;
            raz                 : in  STD_LOGIC;
            CS                  : in std_logic;
            choix_note          : in  STD_LOGIC_VECTOR (9 downto 0);  --1 : Miaigu, 2 : Si, 3 : Sol, 4 : Ré, 5 : La, 6 : Migrave.
            valeur_sinus_sortie : out STD_LOGIC_VECTOR (11 downto 0)
            );

end freq_sinus;

architecture Behavioral of freq_sinus is

type memory_type is ARRAY (0 to 19) of integer range -2048 to 2047;

--  ===================================================================================
-- 							  			Signals and Constants
--  ===================================================================================
signal sine      : memory_type :=(0,618,1176,1618,1902,2000,1902,1618,1176,618,0,-618,-1176,-1618,-1902,-2000,-1902,-1618,-1176,-618); -- sinus value memorised in a RAM 
signal borne_sup : integer := 600;
signal freq,cpt : integer range 0 to 600;
signal cpt_sinus : integer range 0 to 19;

begin


freq <= borne_sup;

--  ===================================================================================
-- 							 generate a CE at the selected note frequency
--  ===================================================================================

diviseur_f : process(clk)
begin
   if (clk'event and clk='1') then
       if(raz = '1' ) then
           cpt <= 0;
           cpt_sinus <=0;
       elsif (CS ='1' ) then
           
           if(cpt_sinus=19) then
               cpt_sinus <=0;
           end if;
           
           if (cpt > freq or cpt = freq) then
               cpt <= 0;
               cpt_sinus <= cpt_sinus + 1;
           else
               cpt <= cpt + 20;--ajout de 20 en 20 au lieu de 1 en 1 pour eviter une division
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
                valeur_sinus_sortie <= std_logic_vector(to_signed(sine(cpt_sinus),12));           
            else
                valeur_sinus_sortie <= "000000000000";
            end if;
         end if;
    end if;
end process;

--  ===================================================================================
-- 					associate the user selected paramater to a note 
--  ===================================================================================
process(choix_note) 
    begin
        case choix_note is
           when "0000000110" => -- 6 : Mi aigu
            borne_sup <= 134; 
           when "0000000101" =>  -- 5 : Si
            borne_sup <= 179;
           when "0000000100" => -- 4 : Sol
            borne_sup <= 225;
           when "0000000011" => -- 3 : Ré
            borne_sup <= 300;
           when "0000000010" => -- 2 : La
            borne_sup <= 401;
           when others => -- 1 : Mi grave
            borne_sup <= 535;
        end case;
    end process;
end Behavioral;
