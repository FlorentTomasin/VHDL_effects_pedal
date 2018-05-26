----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2016 14:22:56
-- Design Name: 
-- Module Name: echo - Behavioral
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE ram_package IS

    CONSTANT RAM_ADDR_BITS : integer :=    18;
    CONSTANT RAM_DATA_BITS : integer :=    12; 
    CONSTANT RAM_DATA_OUT_BITS : integer :=    12; 
	CONSTANT RAM_MAX_ADDR  : integer := 50000;
        
    TYPE ram IS ARRAY(0 to (RAM_MAX_ADDR-1)) of STD_LOGIC_VECTOR ( RAM_DATA_OUT_BITS-1 DOWNTO 0);
 
END ram_package;
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.ram_package.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity echo is
  PORT (
        CLOCK     : IN  STD_LOGIC;      
        CS : in std_logic;
        LAUNCH : in STD_LOGIC;
        DATA_IN   : IN STD_LOGIC_VECTOR ( 11 DOWNTO 0);
        DATA_OUT  : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        NB_MAX_ECH : in integer
        );
end echo;

architecture Behavioral of echo is

    SIGNAL ram_block : ram := (others => (others => '0'));
    SIGNAL cpt_ram : integer range 0 to 49999:=0;
    
begin

-- ====================================================================================
-- 				Addr counter
-- ====================================================================================
process (CLOCK)
begin
    if(CLOCK='1' and CLOCK'EVENT) then
        if (CS ='1') then
            if (cpt_ram=NB_MAX_ECH) then
                cpt_ram <= 0;
            else
                cpt_ram <= cpt_ram + 1 ;
            end if;
        end if;
    end if;
end process;


-- ====================================================================================
-- 			R/W acces of the RAM depending on the state of the effec (LAUNCHED or not) 
-- ====================================================================================

process(CLOCK)

	begin
        if(CLOCK='1' and CLOCK'EVENT) then
            if (CS = '1') then    
                if (LAUNCH = '1') then                
                    DATA_OUT <= ram_block(cpt_ram);--read first 
                    ram_block(cpt_ram) <= DATA_IN(11 downto 0);--write at the same Addr ---> 2 steps on a rising edge of the clock
                else
                    ram_block(cpt_ram) <= "000000000000";
                    DATA_OUT <= "000000000000";
               end if;
            end if;
        end if;
end process;


end Behavioral;
