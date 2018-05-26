----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.10.2016 15:24:28
-- Design Name: 
-- Module Name: transcoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: transcoder for SS
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

entity transcoder is
    Port (
               nb_volume_effet :  in STD_LOGIC_VECTOR (3 downto 0);
               nb_volume_global :  in STD_LOGIC_VECTOR (3 downto 0);
               WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
               WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
               WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
               WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
               nb_pave_cent : in std_logic_vector (6 downto 0);
               nb_pave_dec : in std_logic_vector (6 downto 0);
               nb_pave_unit : in std_logic_vector (6 downto 0);
               LAUNCH1 : in STD_LOGIC;
               LAUNCH2 : in STD_LOGIC;
               LAUNCH3 : in STD_LOGIC;
               LAUNCH4 : in STD_LOGIC;
               sortie1 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie2 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie3 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie4 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie5 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie6 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie7 : out STD_LOGIC_VECTOR (6 downto 0);
               sortie8 : out STD_LOGIC_VECTOR (6 downto 0)
               );
end transcoder;

architecture Behavioral of transcoder is

signal vol_effet : integer :=0;
signal vol_global : integer :=0;
signal  WAIT_FOR_SELECT : std_logic;

begin
WAIT_FOR_SELECT <=  WAIT_FOR_1 or WAIT_FOR_2 or WAIT_FOR_3 or WAIT_FOR_4;    
vol_effet <= to_integer(unsigned(nb_volume_effet));    
vol_global <= to_integer(unsigned(nb_volume_global));    

--effet 1 
process(LAUNCH1,WAIT_FOR_1)
begin
    if (WAIT_FOR_1 ='1') then
        sortie1 <= "0111111";
    elsif LAUNCH1 = '1' then
        sortie1 <= "1111001";
    else
        sortie1 <= "1000000";
    end if;
end process;

--effet 2 
process(LAUNCH2,WAIT_FOR_2)
begin
    if (WAIT_FOR_2 ='1') then
        sortie2 <= "0111111";
    elsif LAUNCH2 = '1' then
        sortie2 <= "1111001";
    else
        sortie2 <= "1000000";
    end if;
end process;

--effet 3
process(LAUNCH3,WAIT_FOR_3)
begin
    if (WAIT_FOR_3 ='1') then
        sortie3 <= "0111111";
    elsif LAUNCH3 = '1' then
        sortie3 <= "1111001";
    else
        sortie3 <= "1000000";
    end if;
end process;

--effet 4
process(LAUNCH4,WAIT_FOR_4)
begin
    if (WAIT_FOR_4 ='1') then
        sortie4 <= "0111111";
    elsif LAUNCH4 = '1' then
        sortie4 <= "1111001";
    else
        sortie4 <= "1000000";
    end if;
end process;


process(nb_volume_effet, vol_effet, nb_pave_unit,WAIT_FOR_SELECT)
begin
--Volume
    if (WAIT_FOR_SELECT ='1') then
        sortie8 <= nb_pave_unit;
    else
        case vol_effet is
            when 0 =>
                sortie8<="1000000";
            when 1 =>
                sortie8<="1111001";
            when 2 =>
                sortie8<="0100100";
            when 3 =>
                sortie8<="0110000";
            when 4 =>
                sortie8<="0011001";
            when 5 =>
                sortie8<="0010010";
            when 6 =>
                sortie8<="0000010";
            when 7 =>
                sortie8<="1111000";
            when 8 =>
                sortie8<="0000000";
            when 9 =>
                sortie8<="0010000";
            when others => 
                sortie8<="0010010";
        end case;
    end if;
end process;

process(nb_volume_global, vol_global, nb_pave_dec, WAIT_FOR_SELECT)
begin
--Volume
    if (WAIT_FOR_SELECT ='1') then
        sortie7 <= nb_pave_dec;
    else
        case vol_global is
            when 0 =>
                sortie7<="1000000";
            when 1 =>
                sortie7<="1111001";
            when 2 =>
                sortie7<="0100100";
            when 3 =>
                sortie7<="0110000";
            when 4 =>
                sortie7<="0011001";
            when 5 =>
                sortie7<="0010010";
            when 6 =>
                sortie7<="0000010";
            when 7 =>
                sortie7<="1111000";
            when 8 =>
                sortie7<="0000000";
            when 9 =>
                sortie7<="0010000";
            when others => 
                sortie7<="0010010";
        end case;
    end if;
end process;

process(nb_pave_cent)
begin
--centaines
    if (WAIT_FOR_SELECT ='1') then
        sortie6 <= nb_pave_cent;
    else
        sortie6 <= "1111111";
    end if;
end process;

sortie5 <= "1111111";


end Behavioral;
