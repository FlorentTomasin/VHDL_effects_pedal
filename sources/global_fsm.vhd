----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2016 22:24:26
-- Design Name: 
-- Module Name: global_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Global FSM (control each parallel effect FSM)
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

entity global_fsm is
    Port (  
           rst : in STD_LOGIC;
           clk : in STD_LOGIC; 
           
           SWITCH1 : in STD_LOGIC; -- bouton poussoir pour activer effet 1
           SWITCH2 : in STD_LOGIC; -- ------------ 2
           SWITCH3 : in STD_LOGIC; -- ------------ 3
           SWITCH4 : in STD_LOGIC; -- ------------ 4
               
           WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
       
           PLAY_PAUSE_1 : out STD_LOGIC;
           PLAY_PAUSE_2 : out STD_LOGIC;
           PLAY_PAUSE_3 : out STD_LOGIC;
           PLAY_PAUSE_4 : out STD_LOGIC--;
           );
           
end global_fsm;

architecture Behavioral of global_fsm is

TYPE state_type is (init, operating, wait_effect_1, wait_effect_2, wait_effect_3, wait_effect_4);
SIGNAL Cstate, Nstate : state_type;

begin

-- ====================================================================================
-- 									synchronious FSM
-- ====================================================================================

    sequentiel : process(clk)
    begin
        if (clk ='1' and clk'event) then
            if (rst='1') then
                Cstate <= init;
            else
                Cstate <= Nstate;
            end if;
        end if;
    end process;

 
-- ====================================================================================
-- 							Combinatorial assignement
-- ====================================================================================
    state : process(Cstate, SWITCH1, SWITCH2, SWITCH3, SWITCH4, WAIT_FOR_1, WAIT_FOR_2, WAIT_FOR_3, WAIT_FOR_4)
    begin
        case Cstate is
            when init =>
                if ( SWITCH1 ='1' and WAIT_FOR_1 ='1') then
                    Nstate <= wait_effect_1;
                elsif ( SWITCH2 ='1' and WAIT_FOR_2 ='1') then
                    Nstate <= wait_effect_2;                
                elsif ( SWITCH3 ='1' and WAIT_FOR_3 ='1') then
                    Nstate <= wait_effect_3;                
                elsif ( SWITCH4 ='1' and WAIT_FOR_4 ='1') then
                    Nstate <= wait_effect_4;
                else
                    Nstate <= operating;
                end if;
            when wait_effect_1 =>
                if (WAIT_FOR_1 = '0') then
                    Nstate <= operating;
                else
                    Nstate <= wait_effect_1;
                end if;
            when wait_effect_2 =>
                if (WAIT_FOR_2 = '0') then
                    Nstate <= operating;
                else
                    Nstate <= wait_effect_2;
                end if;
            when wait_effect_3 =>
                if (WAIT_FOR_3 = '0') then
                    Nstate <= operating;
                else
                    Nstate <= wait_effect_3;
                end if;
            when wait_effect_4 =>
                if (WAIT_FOR_4 = '0') then
                    Nstate <= operating;
                else
                    Nstate <= wait_effect_4;
                end if;   
            when others =>
                if ( SWITCH1 ='1' and WAIT_FOR_1 ='1') then
                    Nstate <= wait_effect_1;
                elsif ( SWITCH2 ='1' and WAIT_FOR_2 ='1') then
                    Nstate <= wait_effect_2;                
                elsif ( SWITCH3 ='1' and WAIT_FOR_3 ='1') then
                    Nstate <= wait_effect_3;                
                elsif ( SWITCH4 ='1' and WAIT_FOR_4 ='1') then
                    Nstate <= wait_effect_4;
                else
                    Nstate <= operating;
                end if;                                                                     
        end case;
    end process;
    
-- ====================================================================================
-- 					Output assigned depending on the state of FSM
-- ====================================================================================  
    output : process(Cstate, SWITCH1, SWITCH2, SWITCH3, SWITCH4, WAIT_FOR_1, WAIT_FOR_2, WAIT_FOR_3, WAIT_FOR_4)
    begin
        case Cstate is 
            when init =>
                
                PLAY_PAUSE_1 <= '0';
                PLAY_PAUSE_2 <= '0';
                PLAY_PAUSE_3 <= '0';
                PLAY_PAUSE_4 <= '0';
                       
            when wait_effect_1 =>
            
                PLAY_PAUSE_1 <= '0';
                PLAY_PAUSE_2 <= '1';
                PLAY_PAUSE_3 <= '1';
                PLAY_PAUSE_4 <= '1';
                
            when wait_effect_2 =>
            
                PLAY_PAUSE_1 <= '1';
                PLAY_PAUSE_2 <= '0';
                PLAY_PAUSE_3 <= '1';
                PLAY_PAUSE_4 <= '1';
                
            when wait_effect_3 =>
            
                PLAY_PAUSE_1 <= '1';
                PLAY_PAUSE_2 <= '1';
                PLAY_PAUSE_3 <= '0';
                PLAY_PAUSE_4 <= '1';
               
            when wait_effect_4 =>

                PLAY_PAUSE_1 <= '1';
                PLAY_PAUSE_2 <= '1';
                PLAY_PAUSE_3 <= '1';
                PLAY_PAUSE_4 <= '0';
                
            when others =>
            
                PLAY_PAUSE_1 <= '0';
                PLAY_PAUSE_2 <= '0';
                PLAY_PAUSE_3 <= '0';
                PLAY_PAUSE_4 <= '0';
          
        end case;                      
    end process;

end Behavioral;
