----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2016 15:43:04
-- Design Name: 
-- Module Name: inst_global_project - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Global instantiation of the project
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

entity inst_global_project is  
    Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            
            --Microphone
            MISO_MIC : in STD_LOGIC;
            CS_MIC    : out STD_LOGIC;
            SCLK_MIC  : out STD_LOGIC;
            
            --JACK
            amp_SP: out STD_LOGIC;
            odata : out STD_LOGIC;
            
            --JOYSTICK
            MISO : in  STD_LOGIC;							-- Master In Slave Out, JA3
            SS   : out  STD_LOGIC;								-- Slave Select, Pin 1, Port JA
            MOSI : out  STD_LOGIC;                            -- Master Out Slave In, Pin 2, Port JA
            SCLK : out  STD_LOGIC;                            -- Serial Clock, Pin 4, Port JA

            --pave numeroique
            JB : inout  STD_LOGIC_VECTOR (7 downto 0); -- PmodKYPD is designed to be connected to JB
            
            --bouton back
            --BOUTON_BACK : in std_logic;
            right : in std_logic;   
            left : in std_logic;
            
            --SWITCH EFFECT ENABLE
            SWITCH1 : in STD_LOGIC; -- bouton poussoir pour activer effet 1
            SWITCH2 : in STD_LOGIC; -- ------------ 2
            SWITCH3 : in STD_LOGIC; -- ------------ 3
            SWITCH4 : in STD_LOGIC;
            
            --looper record
            RECORDER : in std_logic;

            --SEVEN SEGMENT
            DP : out std_logic; 
            AN : out STD_LOGIC_VECTOR (7 downto 0);    
            S : out STD_LOGIC_VECTOR (6 downto 0);
            
            --LED audio display
            LED : out std_logic_vector (15 downto 0)

           
           );
end inst_global_project;

architecture Behavioral of inst_global_project is
          
component fsm is
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
end component;

component  pmodmic3 is
    Port ( 
           clk : in std_logic;
           rst : in std_logic;
           CS : out STD_LOGIC;
           MISO : in STD_LOGIC;
           SCLK : out STD_LOGIC;
           sdata : out std_logic_vector(11 downto 0)
           );
end component; 

component PmodJSTK_CONTROL is
  Port ( 
           clk  : in  STD_LOGIC;							
           RST  : in  STD_LOGIC;								
           MISO : in  STD_LOGIC;							-- Master In Slave Out, JA3
           SS   : out  STD_LOGIC;								-- Slave Select, Pin 1, Port JA
           MOSI : out  STD_LOGIC;							-- Master Out Slave In, Pin 2, Port JA
           SCLK : out  STD_LOGIC;    						-- Serial Clock, Pin 4, Port JA
           posX : out STD_LOGIC_VECTOR(9 downto 0);
           posY : out STD_LOGIC_VECTOR(9 downto 0)
        );
end component;

component detect_impulsion is
    Port ( input : in STD_LOGIC;
           horloge : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

component ss_controler is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            
            LAUNCH1 : in STD_LOGIC;
            LAUNCH2 : in STD_LOGIC;
            LAUNCH3 : in STD_LOGIC;
            LAUNCH4 : in STD_LOGIC;
            
            V_effet_UP : in STD_LOGIC; 
            V_effet_DOWN : in STD_LOGIC;
            V_input_UP : in STD_LOGIC;
            V_input_DOWN : in STD_LOGIC;
            
            WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
          
            cent : in std_logic_vector (3 downto 0);
            dec : in std_logic_vector (3 downto 0);
            unit : in std_logic_vector (3 downto 0);
            
            nb_volume_effet :  out STD_LOGIC_VECTOR (3 downto 0);
            nb_volume_global :  out STD_LOGIC_VECTOR (3 downto 0);
            
            DP : out std_logic; 
            AN : out STD_LOGIC_VECTOR (7 downto 0);    
            S : out STD_LOGIC_VECTOR (6 downto 0)
          );
end component;

component audio_led_display is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            
            idata : in std_logic_vector (11 downto 0 );
            
            LED : out std_logic_vector (15 downto 0)
            );
end component;           

component effect_tweak is -- permet d'entrer des parametres pour chaques effets
    Port ( 
            clk : in  STD_LOGIC;
            rst : in std_logic;
            JB : inout  STD_LOGIC_VECTOR (7 downto 0); -- PmodKYPD is designed to be connected to JB

            right : in std_logic;   
            left : in std_logic;
            
            WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
            WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
          
            CONFIG_VALID : out STD_LOGIC;
            
            cent : out std_logic_vector (3 downto 0);
            dec : out std_logic_vector (3 downto 0);
            unit : out std_logic_vector (3 downto 0);
                        
            DATA_out_1 : out std_logic_vector(9 downto 0);
            DATA_out_2 : out std_logic_vector(9 downto 0);
            DATA_out_3 : out std_logic_vector(9 downto 0);
            DATA_out_4 : out std_logic_vector(9 downto 0)
          ); 
end component;

component effect_box is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
                                   
            RECORDER : in std_logic;
 
            LAUNCH1 : in std_logic;
            LAUNCH2 : in std_logic;
            LAUNCH3 : in std_logic;
            LAUNCH4 : in std_logic;
            
            idata : in std_logic_vector (11 downto 0);
            
            nb_volume_effet :  in STD_LOGIC_VECTOR (3 downto 0);
            nb_volume_global :  in STD_LOGIC_VECTOR (3 downto 0);
                          
             DATA_tweak_1 : in std_logic_vector(9 downto 0);
             DATA_tweak_2 : in std_logic_vector(9 downto 0);
             DATA_tweak_3 : in std_logic_vector(9 downto 0);
             DATA_tweak_4 : in std_logic_vector(9 downto 0);
                      
            amp_sp : out std_logic;
            odata : out std_logic
            
            );
end component;

signal sig_V_effet_UP, sig_V_effet_DOWN, sig_V_input_UP, sig_V_input_DOWN : std_logic;
signal sig_LAUNCH1, sig_LAUNCH2, sig_LAUNCH, sig_LAUNCH4 : std_logic;
signal sig_posX, sig_posY : STD_LOGIC_VECTOR(9 downto 0);
signal sig_WAIT_FOR_1, sig_WAIT_FOR_2, sig_WAIT_FOR_3, sig_WAIT_FOR_4 : STD_LOGIC;
signal sig_CONFIG_VALID : STD_LOGIC;
signal DATA_out_1,DATA_out_2,DATA_out_3,DATA_out_4 : std_logic_vector(9 downto 0);
signal sig_cent, sig_dec, sig_unit : std_logic_vector (3 downto 0);

--Microphone
signal sig_CS_mic, sig_SCLK_mic : std_logic;
signal sig_data_mic : std_logic_vector(11 downto 0);

--bouton left right
signal sig_right,sig_left : std_logic;

signal sig_nb_volume_effet, sig_nb_volume_global : STD_LOGIC_VECTOR (3 downto 0);

begin


--  ===================================================================================
-- 							  				project FSM
--  ===================================================================================

inst_fsm : fsm port map(
                        rst,
                        clk,
                        
                        sig_posX, 
                        sig_posY,
                        sig_CONFIG_VALID,
                        
                        SWITCH1,
                        SWITCH2,
                        SWITCH3,
                        SWITCH4,
                        
                        sig_V_effet_UP, 
                        sig_V_effet_DOWN, 
                        sig_V_input_UP, 
                        sig_V_input_DOWN,
                        
                        sig_WAIT_FOR_1, 
                        sig_WAIT_FOR_2, 
                        sig_WAIT_FOR_3, 
                        sig_WAIT_FOR_4,
                        
                        sig_LAUNCH1, 
                        sig_LAUNCH2, 
                        sig_LAUNCH, 
                        sig_LAUNCH4
                        );

--  ===================================================================================
-- 							  			PmodMIC3 control
--  ===================================================================================

inst_pmodmic3 : pmodmic3 port map(clk, rst, sig_CS_mic, MISO_mic, sig_SCLK_mic, sig_data_mic);
CS_MIC <= sig_CS_mic;
SCLK_MIC <= sig_sclk_mic;

--  ===================================================================================
-- 			Effect box contain all the effect processing
--  ===================================================================================

inst_effect_box : effect_box port map(
                                    clk, 
                                    rst,
                                    RECORDER,
                                    sig_LAUNCH1, 
                                    sig_LAUNCH2, 
                                    sig_LAUNCH, 
                                    sig_LAUNCH4, 
                                    sig_data_mic,                                     
                                    sig_nb_volume_effet, 
                                    sig_nb_volume_global,
                                    DATA_out_1,
                                    DATA_out_2,
                                    DATA_out_3,
                                    DATA_out_4,
                                    amp_SP,
                                    odata
                                    );                                  
                        
--  ===================================================================================
-- 							  				PmodJSTK control
--  ===================================================================================                        
inst_PmodJSTK_CONTROL : PmodJSTK_CONTROL port map(clk, rst, MISO, SS, MOSI, SCLK, sig_posX, sig_posY);

--  ===================================================================================
-- 							  				Sevent segment control
--  ===================================================================================

inst_ss_controler : ss_controler port map(
                        clk,
                        rst,
                        
                        sig_LAUNCH1, 
                        sig_LAUNCH2, 
                        sig_LAUNCH, 
                        sig_LAUNCH4,
                        
                        sig_V_effet_UP, 
                        sig_V_effet_DOWN, 
                        sig_V_input_UP, 
                        sig_V_input_DOWN,    
                        
                        sig_WAIT_FOR_1,
                        sig_WAIT_FOR_2,
                        sig_WAIT_FOR_3,
                        sig_WAIT_FOR_4,
                        
                        sig_cent, 
                        sig_dec, 
                        sig_unit,
                        
                        sig_nb_volume_effet,
                        sig_nb_volume_global,
                        
                        DP,
                        AN,
                        S                  
                        );

--  ===================================================================================
-- 							  				LED control
--  ===================================================================================

inst_audio_led_display : audio_led_display port map (clk, rst, sig_data_mic, LED);

--  ===================================================================================
-- 							  			Bouton pulse (selection) detect
--  ===================================================================================

inst_B_left : detect_impulsion port map (left,clk, sig_left);
inst_B_right : detect_impulsion port map (right,clk, sig_right);

--  ===================================================================================
-- 						Effect tweak offer the possibility to tweak each effect
--  ===================================================================================

inst_effect_tweak : effect_tweak port map(
                                            clk,
                                            rst, 
                                            JB,
                                            sig_right,
                                            sig_left,
                                            sig_WAIT_FOR_1,
                                            sig_WAIT_FOR_2,
                                            sig_WAIT_FOR_3,
                                            sig_WAIT_FOR_4,
                                            sig_CONFIG_VALID,
                                            sig_cent, 
                                            sig_dec, 
                                            sig_unit,
                                            DATA_out_1,
                                            DATA_out_2,
                                            DATA_out_3,
                                            DATA_out_4
                                            );
                                            
end Behavioral;
