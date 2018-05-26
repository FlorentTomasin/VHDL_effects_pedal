----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2016 17:33:50
-- Design Name: 
-- Module Name: add_effect_signal - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Add effect signals and resize it to keep a correct output word size of 12Bits
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

entity add_effect_signal is
 Port ( 
           clk : in std_logic;
           rst : in std_logic;
           
           effect_1 : in std_logic_vector (11 downto 0);
           effect_2 : in std_logic_vector (11 downto 0);
           effect_3 : in std_logic_vector (11 downto 0);
           effect_4 : in std_logic_vector (11 downto 0);
           
           odata : out std_logic_vector (11 downto 0)
           );
end add_effect_signal;

architecture Behavioral of add_effect_signal is

signal tmp : std_logic_vector (13 downto 0) ;

begin

-- ====================================================================================
-- 										  Add signals
-- ====================================================================================

tmp <= STD_LOGIC_VECTOR(to_signed((to_integer(signed(effect_1)) + to_integer(signed(effect_2))+ to_integer(signed(effect_3))+ to_integer(signed(effect_4))), 14));

-- ====================================================================================
-- 										  synchronious output (resized signal)
-- ====================================================================================
process(clk,rst)
begin
    if (clk'event and clk ='1') then
        if (rst='1') then
            odata <= STD_LOGIC_VECTOR(to_signed(0, 12));
        else
            odata <= STD_LOGIC_VECTOR(resize(unsigned(tmp(13 downto 2)), 12));
        end if;
    end if;
end process;


end Behavioral;
