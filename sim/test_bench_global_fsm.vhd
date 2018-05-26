----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2016 14:48:49
-- Design Name: 
-- Module Name: test_bench_global_fsm - Behavioral
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

entity test_bench_global_fsm is
--  Port ( );
end test_bench_global_fsm;

architecture Behavioral of test_bench_global_fsm is

SIGNAL sig_rst, sig_clk, sig_BOUTON_BACK, sig_JOYSTICK_X, sig_JOYSTICK_Y : STD_LOGIC :='0';
SIGNAL sig_SWITCH1, sig_SWITCH2, sig_SWITCH3, sig_SWITCH4, sig_WAIT_FOR_1, sig_WAIT_FOR_2, sig_WAIT_FOR_3, sig_WAIT_FOR_4 : STD_LOGIC :='0';

-- outputs
SIGNAL sig_PLAY_PAUSE_1, sig_PLAY_PAUSE_2, sig_PLAY_PAUSE_3, sig_PLAY_PAUSE_4, sig_RETOUR, sig_V_effet_UP, sig_V_effet_DOWN, sig_V_input_UP, sig_V_input_DOWN : STD_LOGIC :='0';
--constante
CONSTANT period : time := 10ns;

-- components
COMPONENT global_fsm is
    Port (  
           rst : in STD_LOGIC;
           clk : in STD_LOGIC; 
           
           BOUTON_BACK : in STD_LOGIC; 
           JOYSTICK_X : in STD_LOGIC;
           JOYSTICK_Y : in STD_LOGIC;
           
           SWITCH1 : in STD_LOGIC;
           SWITCH2 : in STD_LOGIC; 
           SWITCH3 : in STD_LOGIC;
           SWITCH4 : in STD_LOGIC; 
               
           WAIT_FOR_1 : in STD_LOGIC; 
           WAIT_FOR_2 : in STD_LOGIC; 
           WAIT_FOR_3 : in STD_LOGIC; 
           WAIT_FOR_4 : in STD_LOGIC; 
       
           PLAY_PAUSE_1 : out STD_LOGIC;
           PLAY_PAUSE_2 : out STD_LOGIC;
           PLAY_PAUSE_3 : out STD_LOGIC;
           PLAY_PAUSE_4 : out STD_LOGIC;
           RETOUR : out STD_LOGIC;
           
           V_effet_UP : out STD_LOGIC; 
           V_effet_DOWN : out STD_LOGIC;
           V_input_UP : out STD_LOGIC; 
           V_input_DOWN : out STD_LOGIC);
           
END COMPONENT;

begin
-- clock-process
clock_PROCESS : PROCESS 
begin
    sig_clk <='0';
    wait for period/2;
    sig_clk <='1';
    wait for period/2;
end PROCESS;
    
    
-- instantiations
inst_global_fsm : global_fsm port map(
--                                        sig_rst => rst, 
--                                        sig_clk => clk, 
--                                        sig_BOUTON_BACK => BOUTON_BACK, 
--                                        sig_JOYSTICK_X => JOYSTICK_X, 
--                                        sig_JOYSTICK_Y => jOYSTICK_Y,
--                                        sig_SWITCH1 => SWITCH1, 
--                                        sig_SWITCH2 => SWITCH2, 
--                                        sig_SWITCH3 => SWITCH3, 
--                                        sig_SWITCH4 => SWITCH4, 
--                                        sig_WAIT_FOR_1 => WAIT_FOR_1, 
--                                        sig_WAIT_FOR_2 => WAIT_FOR_2, 
--                                        sig_WAIT_FOR_3 => WAIT_FOR_3, 
--                                        sig_WAIT_FOR_4 => WAIT_FOR_4,
--                                        sig_PLAY_PAUSE_1 => PLAY_PAUSE_1, 
--                                        sig_PLAY_PAUSE_2 => PLAY_PAUSE_2, 
--                                        sig_PLAY_PAUSE_3 => PLAY_PAUSE_3, 
--                                        sig_PLAY_PAUSE_4 => PLAY_PAUSE_4, 
--                                        sig_RETOUR => RETOUR, 
--                                        sig_V_effet_UP => V_effet_UP, 
--                                        sig_V_effet_DOWN => V_effet_DOWN, 
--                                        sig_V_input_UP => V_input_UP, 
--                                        sig_V_input_DOWN => V_input_DOWN
                                      sig_rst, 
                                      sig_clk , 
                                      sig_BOUTON_BACK, 
                                      sig_JOYSTICK_X, 
                                      sig_JOYSTICK_Y,
                                      sig_SWITCH1 , 
                                      sig_SWITCH2, 
                                      sig_SWITCH3, 
                                      sig_SWITCH4, 
                                      sig_WAIT_FOR_1, 
                                      sig_WAIT_FOR_2 , 
                                      sig_WAIT_FOR_3 , 
                                      sig_WAIT_FOR_4 ,
                                      sig_PLAY_PAUSE_1, 
                                      sig_PLAY_PAUSE_2, 
                                      sig_PLAY_PAUSE_3 , 
                                      sig_PLAY_PAUSE_4 , 
                                      sig_RETOUR , 
                                      sig_V_effet_UP, 
                                      sig_V_effet_DOWN, 
                                      sig_V_input_UP, 
                                      sig_V_input_DOWN
                                        );
-- stimulis_process
stimulis : PROCESS
begin
    
    wait for 10ns;
    
    sig_JOYSTICK_X <= '1';
    sig_JOYSTICK_Y <= '1';
    
    sig_SWITCH1 <= '1';

    wait for 10ns;
    
    sig_JOYSTICK_X <= '0';
    sig_JOYSTICK_Y <= '0';
    
    sig_SWITCH1 <= '1';
    
    wait;

end PROCESS;

end Behavioral;
