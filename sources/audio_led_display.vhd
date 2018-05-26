----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2016 21:21:57
-- Design Name: 
-- Module Name: audio_led_display - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Control of the LED bar by the level of the audio input
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

entity audio_led_display is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            
            idata : in std_logic_vector (11 downto 0 );
            
            LED : out std_logic_vector (15 downto 0)
            );
end audio_led_display;

architecture Behavioral of audio_led_display is

signal CE : std_logic :='0';
signal tmp : integer range 0 to 4095 :=0;
signal CMPperception : integer :=0;

begin

-- ====================================================================================
-- 										  Generat a 3kHz CE to refresh LED state
-- ====================================================================================
seq_frequence3kHz : process(clk,rst)
begin
    if (rst='1') then
		CMPperception <= 0;
	end if;
    if (clk'event and clk='1') then
        if (CMPperception=33334) then
            CMPperception <= 0;
            CE <= '1';
        else 
            CMPperception <= CMPperception + 1;
            CE <= '0';          
        end if;
    end if;
end process seq_frequence3kHz;

tmp <= to_integer(signed(idata)) + 2048;

-- ====================================================================================
-- 										  Frames of the audio input levels
-- ====================================================================================
process(clk,rst)
begin
    if (clk'event and clk='1') then
        if(rst ='1') then
            LED <= "0000000000000000";
        elsif ( CE = '1') then
                if (tmp < 816) then
                    LED <= "0000000000000001";
                elsif (tmp > 816 and tmp < 898) then
                    LED <= "0000000000000011";            
                elsif (tmp > 898 and tmp < 980) then            
                    LED <= "0000000000000111";
                elsif (tmp > 980 and tmp < 1062) then
                    LED <= "0000000000001111";
                elsif (tmp > 1062 and tmp < 1144) then
                    LED <= "0000000000011111";
                elsif (tmp > 1144 and tmp < 1226) then
                    LED <= "0000000000111111";
                elsif (tmp > 1226 and tmp < 1308) then
                    LED <= "0000000001111111";
                elsif (tmp > 1308 and tmp < 1390) then            
                    LED <= "0000000011111111";
                elsif (tmp > 1390 and tmp < 1472) then
                    LED <= "0000000111111111";
                elsif (tmp > 1472 and tmp < 1554) then
                    LED <= "0000001111111111";
                elsif (tmp > 1554 and tmp < 1636) then
                    LED <= "0000011111111111";
                elsif (tmp > 1636 and tmp < 1718) then
                    LED <= "0000111111111111";
                elsif (tmp > 1718 and tmp < 1800) then
                    LED <= "0001111111111111";
                elsif (tmp > 1800 and tmp < 1882) then
                    LED <= "0011111111111111";
                elsif (tmp > 1882 and tmp < 1964) then
                    LED <= "0111111111111111";                
                elsif (tmp > 1964) then
                    LED <= "1111111111111111";
                end if;
         end if;
    end if;

end process;


end Behavioral;
