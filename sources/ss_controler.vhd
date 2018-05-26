----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2016 13:02:59
-- Design Name: 
-- Module Name: ss_controler - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Seven segment control
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

entity ss_controler is
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
end ss_controler;

architecture Behavioral of ss_controler is

--  ===================================================================================
-- 							  			COMPONENTS
--  ===================================================================================
           
component gestion_horloge is
Port ( 
 clk : in STD_LOGIC;
 raz : in STD_LOGIC;
 CEperception : out STD_LOGIC;
 CEdefilement : out STD_LOGIC
 );
end component;

--module de parcourt des 8 sept-segments
component mod8 is
    Port ( CEperception : in STD_LOGIC;
           clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           sortie : out STD_LOGIC_VECTOR (2 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end component;

--module gerant la donnée a afficher sur chaques sept-segments
component mux8 is
    Port ( commande : in STD_LOGIC_VECTOR (2 downto 0);
           e0 : in STD_LOGIC_VECTOR (6 downto 0);
           e1 : in STD_LOGIC_VECTOR (6 downto 0);
           e2 : in STD_LOGIC_VECTOR (6 downto 0);
           e3 : in STD_LOGIC_VECTOR (6 downto 0);
           e4 : in STD_LOGIC_VECTOR (6 downto 0);
           e5 : in STD_LOGIC_VECTOR (6 downto 0);
           e6 : in STD_LOGIC_VECTOR (6 downto 0);
           e7 : in STD_LOGIC_VECTOR (6 downto 0);
           WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           DP : out STD_LOGIC;
           S : out STD_LOGIC_VECTOR (6 downto 0));
           
end component;

component transcoder is
    Port ( 
           nb_volume_effet : STD_LOGIC_VECTOR (3 downto 0);
           nb_volume_global : STD_LOGIC_VECTOR (3 downto 0);
           WAIT_FOR_1 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_2 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_3 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           WAIT_FOR_4 : in STD_LOGIC; -- dupliquer pour chaque effets, exemple si WAIT_FOR_1 actif le reste est bloque
           nb_pave_cent : in std_logic_vector (6 downto 0);
           nb_pave_dec : in std_logic_vector (6 downto 0);
           nb_pave_unit : in std_logic_vector (6 downto 0);
           LAUNCH1 : in STD_LOGIC;
           LAUNCH2 : in STD_LOGIC;
           LAUNCH3 : in STD_LOGIC;
           LAUNCH4 : in STD_LOGIC;
           sortie1 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie2 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie3 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie4 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie5 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie6 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie7 : out STD_LOGIC_VECTOR (6 downto 0);
           sortie8 : out STD_LOGIC_VECTOR (6 downto 0)
           );
end component;

component volume_control is
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
end component;

component DisplayController is
    Port ( 
            --output from the Decoder
            DispVal : in  STD_LOGIC_VECTOR (3 downto 0);
            --controls which digit to display
            segOut : out  STD_LOGIC_VECTOR (6 downto 0)
            ); 
end component;

SIGNAL sig_sortie1, sig_sortie2, sig_sortie3, sig_sortie4, sig_sortie5, sig_sortie6, sig_sortie7, sig_sortie8 : STD_LOGIC_VECTOR (6 downto 0);
SIGNAL sig_sortie_mod8 : STD_LOGIC_VECTOR (2 downto 0);
signal sig_nb_pave_cent, sig_nb_pave_dec, sig_nb_pave_unit : std_logic_vector (6 downto 0);
signal sig_nb_volume_effet, sig_nb_volume_global : STD_LOGIC_VECTOR (3 downto 0);
signal sig_CEperception, sig_CEdefilement : std_logic;

begin
nb_volume_effet <= sig_nb_volume_effet;
nb_volume_global <= sig_nb_volume_global;
--instanciation
inst_gestion_horloge : gestion_horloge port map(clk, rst, sig_CEperception, sig_CEdefilement);

inst_mod8 : mod8 port map(
                            sig_CEperception,
                            clk,
                            rst,
                            sig_sortie_mod8,
                            AN
                            );
inst_mux8 : mux8 port map(
                            sig_sortie_mod8,
                            sig_sortie1, 
                            sig_sortie2, 
                            sig_sortie3, 
                            sig_sortie4, 
                            sig_sortie5, 
                            sig_sortie6, 
                            sig_sortie7, 
                            sig_sortie8,
                            WAIT_FOR_1,
                            WAIT_FOR_2,
                            WAIT_FOR_3,
                            WAIT_FOR_4,
                            DP,
                            S
                            );
                            
inst_transcoder : transcoder port map(
                                        sig_nb_volume_effet, 
                                        sig_nb_volume_global,
                                        WAIT_FOR_1,
                                        WAIT_FOR_2,
                                        WAIT_FOR_3,
                                        WAIT_FOR_4,
                                        sig_nb_pave_cent, 
                                        sig_nb_pave_dec, 
                                        sig_nb_pave_unit,
                                        LAUNCH1,
                                        LAUNCH2,
                                        LAUNCH3,
                                        LAUNCH4,
                                        sig_sortie1, 
                                        sig_sortie2, 
                                        sig_sortie3, 
                                        sig_sortie4, 
                                        sig_sortie5, 
                                        sig_sortie6, 
                                        sig_sortie7, 
                                        sig_sortie8
                                        );

inst_volume_control : volume_control port map(
                                                 clk, 
                                                 rst,
                                                 sig_CEdefilement,
                                                 V_effet_UP,
                                                 V_effet_DOWN,
                                                 V_input_UP,
                                                 V_input_DOWN,
                                                 sig_nb_volume_effet,
                                                 sig_nb_volume_global
                                                );

inst_cent : DisplayController port map(cent, sig_nb_pave_cent);
inst_dec : DisplayController port map(dec, sig_nb_pave_dec);
inst_unit : DisplayController port map(unit, sig_nb_pave_unit);
end Behavioral;

