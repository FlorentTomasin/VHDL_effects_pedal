----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2016 16:32:14
-- Design Name: 
-- Module Name: testbench_pmodmic3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_pmodmic3 is
--  Port ( );
end testbench_pmodmic3;

architecture Behavioral of testbench_pmodmic3 is

component  pmodmic3 is
    Port ( 
           clk : in std_logic;
           rst : in std_logic;
           CS : out STD_LOGIC;
           MISO : in STD_LOGIC;
           --SCLK : out STD_LOGIC;
           sdata : out std_logic_vector(11 downto 0)
           );
end component;

signal sig_clk, sig_rst, sig_cs, sig_MISO: std_logic;
signal sig_sdata : std_logic_vector(11 downto 0) ;

CONSTANT period : time := 10ns;

begin
inst_pmodmic3 : pmodmic3 port map (sig_clk, sig_rst, sig_cs, sig_MISO, sig_sdata);

clock_PROCESS : PROCESS 
begin
    sig_clk <='0';
    wait for period/2;
    sig_clk <='1';
    wait for period/2;
end PROCESS;

process
begin
    
--    wait for 30 ns;
   
--    sig_rst <= '1';
   
--    wait for 30 ns;
   
--    sig_rst <= '0';
   
    wait for 30 ns;
       
    sig_MISO <= '1';
    
end process;

end Behavioral;
