----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2016 22:24:26
-- Design Name: 
-- Module Name: fsm_effet  - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Effect FSM 
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

entity fsm_effet is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           PLAY_PAUSE : in STD_LOGIC;
           CONFIG_VALID : in STD_LOGIC;
           LAUNCH : out STD_LOGIC;
           WAIT_FOR : out STD_LOGIC
           );
end fsm_effet ;

architecture Behavioral of fsm_effet  is

TYPE state_type is (init, wait_for_config, start);
SIGNAL Cstate, Nstate : state_type;

-- ====================================================================================
-- 									synchronious FSM
-- ====================================================================================
begin
    
    sequentiel : process(clk)
    begin
        if (clk ='1' and clk'event) then
            if (rst='1') then
                Cstate <= init;
            elsif (ENABLE = '1') then
                Cstate <= Nstate;
            else 
                Cstate <= init;
            end if;
        end if;
    end process;
 
 
-- ====================================================================================
-- 							Combinatorial assignement
-- ====================================================================================
   
    state : process(Cstate, PLAY_PAUSE, CONFIG_VALID, ENABLE)
    begin
        case Cstate is
            when init =>
                if ( PLAY_PAUSE = '0' and ENABLE = '1') then
                    Nstate <= wait_for_config;
                else
                    Nstate <= init ;          
                end if;   
            when wait_for_config =>
                if ( CONFIG_VALID = '1' and ENABLE = '1') then
                    Nstate <= start;
                else
                    Nstate <= wait_for_config;
                end if;
            when start =>
                    Nstate <= start;
        end case;
    end process;
    
 
-- ====================================================================================
-- 					Output assigned depending on the state of FSM
-- ====================================================================================   

    output : process(Cstate, PLAY_PAUSE, CONFIG_VALID)
    begin
        case Cstate is 
            when init =>
                LAUNCH <= '0' ;
                WAIT_FOR <= '0';
            when wait_for_config =>
                LAUNCH <= '0';
                WAIT_FOR <= '1';            
            when start =>
                LAUNCH <= '1';
                WAIT_FOR <= '0';        
        end case;
    end process;
    
end Behavioral;
