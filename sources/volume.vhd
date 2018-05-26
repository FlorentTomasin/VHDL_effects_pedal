----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2016 16:52:47
-- Design Name: 
-- Module Name: volume - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: resize input data according to the level selected by the user
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

entity volume is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           vol : in STD_LOGIC_VECTOR (3 downto 0);
           data_in : in STD_LOGIC_VECTOR (11 downto 0);
           data_pwm : out STD_LOGIC_VECTOR (11 downto 0));
end volume;

architecture Behavioral of volume is

signal data : STD_LOGIC_VECTOR( 11 downto 0); 

begin

--  ===================================================================================
-- 					synchronious process
--  ===================================================================================

process(clk, raz)
begin

    if (raz='1') then
        data_pwm <= data_in;
    elsif (clk'event and clk='1') then
        data_pwm  <= data;
    end if;

end process;

--  ===================================================================================
-- 					resize input data
--  ===================================================================================
process(vol)
begin

case vol is
    when "0001" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 8)), 12));
    when "0010" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 7)), 12));
    when "0011" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 6)), 12));
    when "0100" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 5)), 12));
    when "0101" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 4)), 12));
    when "0110" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 3)), 12));
    when "0111" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 2)), 12));
    when "1000" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 1)), 12));
    when "1001" => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 0)), 12)); 
    when others => data <= STD_LOGIC_VECTOR(resize(unsigned(data_in(11 downto 4)), 12)); 
end case;
    
end process;

end Behavioral;
