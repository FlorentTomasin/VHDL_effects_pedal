----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2017 23:56:14
-- Design Name: 
-- Module Name: testbench_echo - Behavioral
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

entity testbench_echo is
--  Port ( );
end testbench_echo;

architecture Behavioral of testbench_echo is

  component echo
    PORT (
          CLOCK     : IN  STD_LOGIC;      
          CS : in std_logic;
          LAUNCH : in STD_LOGIC;
          DATA_IN   : IN STD_LOGIC_VECTOR ( 11 DOWNTO 0);
          DATA_OUT  : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
          NB_MAX_ECH : in integer
          );
  end component;

  signal CLOCK: STD_LOGIC;
  signal CS: std_logic;
  signal LAUNCH: STD_LOGIC;
  signal DATA_IN: STD_LOGIC_VECTOR ( 11 DOWNTO 0);
  signal DATA_OUT: STD_LOGIC_VECTOR(11 DOWNTO 0);
  signal NB_MAX_ECH: integer ;

  constant clock_period: time := 10 ns;
  constant cs_period: time := 220 ns;

begin

 uut: echo port map ( CLOCK      => CLOCK,
                      CS         => CS,
                      LAUNCH     => LAUNCH,
                      DATA_IN    => DATA_IN,
                      DATA_OUT   => DATA_OUT,
                      NB_MAX_ECH => NB_MAX_ECH );

  clocking: process
  begin
      CLOCK <= '0';
      wait for clock_period/2;
      CLOCK <= '1';
      wait for clock_period/2;
  end process;

  ce: process
  begin
      CS <= '0';
      wait for cs_period/2-clock_period/2;
      CS <= '1';
      wait for clock_period/2;
  end process;
  
  NB_MAX_ECH <=40;
  
  stimulus: process
    begin
     

     wait for 20ns;
     
     LAUNCH <= '0';
     
     wait for 60ns;
     
     LAUNCH <= '1';
     
      wait;
    end process;
    
    process
    begin
    
     wait for 300ns;
        
        DATA_IN <= "111111111111";
             
        wait for 300ns;
        
        DATA_IN <= "000000000000";
        
    end process;
  
end Behavioral;
