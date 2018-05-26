----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2016 15:16:08
-- Design Name: 
-- Module Name: volume_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: instantiation of Effect volume FSM and Global volume FSM
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

entity volume_control is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            CEdefilement : in std_logic;
           
            V_effet_UP : in STD_LOGIC; 
            V_effet_DOWN : in STD_LOGIC;
            V_input_UP : in STD_LOGIC;
            V_input_DOWN : in STD_LOGIC;
            
            nb_volume_effet :  out STD_LOGIC_VECTOR (3 downto 0);
            nb_volume_global :  out STD_LOGIC_VECTOR (3 downto 0)
            
        );
end volume_control;

architecture Behavioral of volume_control is

component cpt_1_9 is
    Port ( decr : in STD_LOGIC;
           incr : in STD_LOGIC;
           horloge : in STD_LOGIC;
           CEdefilement : in std_logic;
           raz : in STD_LOGIC;
           sortie : out STD_LOGIC_VECTOR (3 downto 0));
end component;

begin

inst_volume_effet : cpt_1_9 port map( 
                                                                
                                       V_effet_DOWN,
                                       V_effet_UP,
                                       clk,
                                       CEdefilement,
                                       rst,
                                       nb_volume_effet
                                       );

inst_volume_global : cpt_1_9 port map( 
                                                                
                                       V_input_DOWN,
                                       V_input_UP,
                                       clk,
                                       CEdefilement,
                                       rst,
                                       nb_volume_global
                                       );
end Behavioral;
