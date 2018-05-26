----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2016 21:14:47
-- Design Name: 
-- Module Name: fsm_volume  - Behavioral
-- Project Name: 
-- Target Devices: fsm_volume 
-- Tool Versions: 
-- Description: Volumme FSM
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

entity fsm_volume is
  Port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
         
        pos : in STD_LOGIC_VECTOR(9 downto 0);
        
        V_UP : out STD_LOGIC; 
        V_DOWN : out STD_LOGIC
        );
end fsm_volume ;

architecture Behavioral of fsm_volume  is

begin

--  ===================================================================================
-- 			Synchroniously assigne a state following the input of the PmodJSTK
--  ===================================================================================

sequentielX : process(clk)
begin

    if (clk='1' and clk'event) then
        if (rst='1') then
            V_UP <= '0';
            V_DOWN <= '0';
        else
            if ( TO_INTEGER(unsigned(pos)) > 700) then
                V_UP <= '1';
                V_DOWN <= '0';
            elsif ( TO_INTEGER(unsigned(pos)) < 300) then
                V_UP <= '0';
                V_DOWN <= '1';
            else 
                V_UP <= '0';
                V_DOWN <= '0';
            end if;
        end if;
    end if;
end process;


end Behavioral;
