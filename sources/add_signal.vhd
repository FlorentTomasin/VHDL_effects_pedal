----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.12.2016 20:03:47
-- Design Name: 
-- Module Name: add_signal - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Add two signals (effect signal and input signal) and resize it to keep a correct output word size of 12Bits
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

entity add_signal is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            
            idata : in std_logic_vector (11 downto 0);
            effect_data : in std_logic_vector (11 downto 0);
            
            odata : out std_logic_vector (11 downto 0)
            );
end add_signal;

architecture Behavioral of add_signal is

signal tmp : std_logic_vector (12 downto 0) ;

begin


-- ====================================================================================
-- 										  Add signals
-- ====================================================================================

tmp <= STD_LOGIC_VECTOR(to_signed(to_integer(signed(effect_data)) + to_integer(signed(idata)), 13));

-- ====================================================================================
-- 										  synchronious output (resized signal)
-- ====================================================================================
process(clk,rst)
begin
    if (clk'event and clk ='1') then
        if (rst='1') then
            odata <= STD_LOGIC_VECTOR(to_signed(0, 12));
        else
            odata <= STD_LOGIC_VECTOR(resize(unsigned(tmp(12 downto 1)), 12));
        end if;
    end if;
end process;



end Behavioral;
