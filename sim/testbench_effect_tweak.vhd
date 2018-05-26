----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2016 14:09:53
-- Design Name: 
-- Module Name: testbench_effect_tweak - Behavioral
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

entity testbench_effect_tweak is
--  Port ( );
end testbench_effect_tweak;

architecture Behavioral of testbench_effect_tweak is

component effect_tweak is -- permet d'entrer des parametre pour chaques effets
    Port ( 
            clk : in  STD_LOGIC;
            rst : in std_logic;
            JB : inout  STD_LOGIC_VECTOR (7 downto 0); -- PmodKYPD is designed to be connected to JB

            WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
          
            CONFIG_VALID : out STD_LOGIC;
            
            cent : out std_logic_vector (3 downto 0);
            dec : out std_logic_vector (3 downto 0);
            unit : out std_logic_vector (3 downto 0);
            
            DATA_out : out std_logic_vector(9 downto 0)
          ); 
end component;

SIGNAL sig_rst, sig_clk, sig_wait_for_1, sig_wait_for_2, sig_wait_for_3, sig_wait_for_4 : STD_LOGIC :='0';
SIGNAL sig_CONFIG_VALID: STD_LOGIC :='0';
SIGNAL sig_cent, sig_dec, sig_unit: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL sig_DATA_out : STD_LOGIC_VECTOR(9 downto 0);
SIGNAL sig_JB : STD_LOGIC_VECTOR(7 downto 0);

CONSTANT period : time := 10ns;

begin

inst_effect_tweak : effect_tweak port map (sig_clk, sig_rst, sig_JB, sig_wait_for_1, sig_wait_for_2, sig_wait_for_3, sig_wait_for_4, sig_CONFIG_VALID, sig_cent, sig_dec, sig_unit, sig_DATA_out );

clock_PROCESS : PROCESS 
begin
    sig_clk <='0';
    wait for period/2;
    sig_clk <='1';
    wait for period/2;
end PROCESS;

stimulis : PROCESS
begin
    sig_JB <= "01111011";
    wait for 10ns;
    
    sig_rst <= '1';

    wait for 10ns;
    
    sig_rst <= '0';
    sig_wait_for_1 <= '1';
    
    
    
    wait for 10ns;
    
    wait;

end PROCESS;

end Behavioral;
