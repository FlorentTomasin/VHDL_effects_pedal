----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2016 15:49:36
-- Design Name: 
-- Module Name: fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: project FSM integrate global FSM, effect FSM and volume FSM
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

entity fsm is
    Port (
        rst : in STD_LOGIC;
        clk : in STD_LOGIC; 
        
        posX : in STD_LOGIC_VECTOR(9 downto 0);
        posY : in STD_LOGIC_VECTOR(9 downto 0);
        
        CONFIG_VALID : in STD_LOGIC;
        
        SWITCH1 : in STD_LOGIC; -- bouton poussoir pour activer effet 1
        SWITCH2 : in STD_LOGIC; -- ------------ 2
        SWITCH3 : in STD_LOGIC; -- ------------ 3
        SWITCH4 : in STD_LOGIC;
        
        V_effet_UP : out STD_LOGIC; 
        V_effet_DOWN : out STD_LOGIC;
        V_input_UP : out STD_LOGIC;
        V_input_DOWN : out STD_LOGIC;
        
        WAIT_FOR_1 : out STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
        WAIT_FOR_2 : out STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
        WAIT_FOR_3 : out STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
        WAIT_FOR_4 : out STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
          
        LAUNCH1 : out STD_LOGIC;
        LAUNCH2 : out STD_LOGIC;
        LAUNCH3 : out STD_LOGIC;
        LAUNCH4 : out STD_LOGIC
        );
end fsm;

architecture Behavioral of fsm is

--  ===================================================================================
-- 							  			COMPONENTS
--  ===================================================================================

component global_fsm is
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
           PLAY_PAUSE_4 : out STD_LOGIC
           
           );
           
end component;

--effet 
component fsm_effet is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           PLAY_PAUSE : in STD_LOGIC;
           CONFIG_VALID : in STD_LOGIC;
           LAUNCH : out STD_LOGIC;
           WAIT_FOR : out STD_LOGIC
           );
end component;

component fsm_volume  is
  Port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
         
        pos : in STD_LOGIC_VECTOR(9 downto 0);
        
        V_UP : out STD_LOGIC; 
        V_DOWN : out STD_LOGIC
        );
        
end component;

--signaux
signal sig_clk, sig_rst: STD_LOGIC;
signal sig_PLAY_PAUSE_1, sig_PLAY_PAUSE_2, sig_PLAY_PAUSE_3, sig_PLAY_PAUSE_4 : STD_LOGIC;
signal sig_RETOUR : STD_LOGIC;
signal sig_CONFIG_VALID : STD_LOGIC;
signal sig_WAIT_FOR_1, sig_WAIT_FOR_2, sig_WAIT_FOR_3, sig_WAIT_FOR_4 : STD_LOGIC;


begin

--instanciations

--  ===================================================================================
-- 							  			global FSM
--  ===================================================================================
inst_global_fsm : global_fsm port map(
                                        rst => rst, 
                                        clk => clk, 
                                                                                
                                        SWITCH1 => SWITCH1,
                                        SWITCH2 => SWITCH2,
                                        SWITCH3 => SWITCH3,
                                        SWITCH4 => SWITCH4,
                                        
                                        WAIT_FOR_1 => sig_WAIT_FOR_1,
                                        WAIT_FOR_2 => sig_WAIT_FOR_2,
                                        WAIT_FOR_3 => sig_WAIT_FOR_3,
                                        WAIT_FOR_4 => sig_WAIT_FOR_4, 
                                        
                                        PLAY_PAUSE_1 => sig_PLAY_PAUSE_1, 
                                        PLAY_PAUSE_2 => sig_PLAY_PAUSE_2, 
                                        PLAY_PAUSE_3 => sig_PLAY_PAUSE_3, 
                                        PLAY_PAUSE_4 => sig_PLAY_PAUSE_4
                                        
                                        );
                                        
--  ===================================================================================
-- 							  			effect FSM
--  ===================================================================================                                        
inst_effet_1 : fsm_effet port map(clk, rst, SWITCH1, sig_PLAY_PAUSE_1, CONFIG_VALID, LAUNCH1, sig_WAIT_FOR_1);
inst_effet_2 : fsm_effet port map(clk, rst, SWITCH2, sig_PLAY_PAUSE_2, CONFIG_VALID, LAUNCH2, sig_WAIT_FOR_2);
inst_effet_3 : fsm_effet port map(clk, rst, SWITCH3, sig_PLAY_PAUSE_3, CONFIG_VALID, LAUNCH3, sig_WAIT_FOR_3);
inst_effet_4 : fsm_effet port map(clk, rst, SWITCH4, sig_PLAY_PAUSE_4, CONFIG_VALID, LAUNCH4, sig_WAIT_FOR_4);

--  ===================================================================================
-- 							  			volume FSM
--  ===================================================================================
inst_fsm_volume_effet  : fsm_volume  port map (rst, clk, posX, V_effet_UP, V_effet_DOWN);
inst_fsm_volume_global  : fsm_volume  port map (rst, clk, posY, V_input_UP, V_input_DOWN);

WAIT_FOR_1 <= sig_WAIT_FOR_1;
WAIT_FOR_2 <= sig_WAIT_FOR_2;
WAIT_FOR_3 <= sig_WAIT_FOR_3;
WAIT_FOR_4 <= sig_WAIT_FOR_4;

end Behavioral;
