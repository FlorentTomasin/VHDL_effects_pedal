----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.12.2016 18:55:54
-- Design Name: 
-- Module Name: effect_box - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Box who contain all the effects and formatting process of the audio signal
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

entity effect_box is
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
end effect_box;

architecture Behavioral of effect_box is


-- ====================================================================================
-- 							COMPONENTS
-- ====================================================================================
component gestion_clk is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           CE : out STD_LOGIC);
end component;

component  echo is
  PORT (
        CLOCK     : IN  STD_LOGIC;      
        CS : in std_logic;
        LAUNCH : in STD_LOGIC;
        DATA_IN   : IN STD_LOGIC_VECTOR ( 11 DOWNTO 0);
        DATA_OUT  : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        NB_MAX_ECH : in integer
        );
end component;   

component looper is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            CS : in std_logic;
            LAUNCH : in std_logic;
            RECORDER : in std_logic;
            idata : in std_logic_vector (11downto 0); 
            odata : out std_logic_vector (11downto 0)
            );
end component;

component tremolo is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            CS : in std_logic;
            LAUNCH : in STD_LOGIC; 
            f_sinus : integer;

            idata : in std_logic_vector(11 downto 0);
            
            odata : out std_logic_vector(11 downto 0)
            );
end component;  

component freq_sinus is
    Port ( 
            launch              : in  STD_LOGIC;
            clk                 : in  STD_LOGIC;
            raz                 : in  STD_LOGIC;
            CS                  : in std_logic;
            choix_note          : in  STD_LOGIC_VECTOR (9 downto 0);  --1 : Miaigu, 2 : Si, 3 : Sol, 4 : Ré, 5 : La, 6 : Migrave.
            valeur_sinus_sortie : out STD_LOGIC_VECTOR (11 downto 0)
            );
end component;          

component add_effect_signal is
 Port ( 
           clk : in std_logic;
           rst : in std_logic;
           
           effect_1 : in std_logic_vector (11 downto 0);
           effect_2 : in std_logic_vector (11 downto 0);
           effect_3 : in std_logic_vector (11 downto 0);
           effect_4 : in std_logic_vector (11 downto 0);
           
           odata : out std_logic_vector (11 downto 0)
           );
end component;      

component add_signal is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            
            idata : in std_logic_vector (11 downto 0);
            effect_data : in std_logic_vector (11 downto 0);
            
            odata : out std_logic_vector (11 downto 0)
            );
end component;         

component PWM is
    Port ( 
           clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           idata : in STD_LOGIC_VECTOR (11 downto 0);
           CE : in STD_LOGIC;
           amp_SP: out STD_LOGIC;
           odata : out STD_LOGIC
           );      
end component;

component volume is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           vol : in STD_LOGIC_VECTOR (3 downto 0);
           data_in : in STD_LOGIC_VECTOR (11 downto 0);
           data_pwm : out STD_LOGIC_VECTOR (11 downto 0));
end component;           

signal sig_CE : std_logic;
signal sig_pwm, sig_data_global, sig_data_effect_1, sig_data_effect_2, sig_data_effect_3, sig_data_effect_4, sig_data_effect, sig_data_effect_volume : std_logic_vector(11 downto 0);

signal nb_ech_echo_tweaked : integer range 0 to 50000:=0;

begin

-- ====================================================================================
-- 					Generat a 44.1kHz CE (sampling frequency)
-- ====================================================================================

inst_gestion_clk : gestion_clk port map(clk, rst, sig_CE);


-- ====================================================================================
-- 										 effect
-- ====================================================================================
nb_ech_echo_tweaked <= 441*to_integer(unsigned(DATA_tweak_1));
inst_echo : echo port map(clk, sig_CE, LAUNCH1, idata, sig_data_effect_1,nb_ech_echo_tweaked);
                 
inst_looper : looper port map (clk, rst, sig_CE, LAUNCH2, RECORDER ,idata, sig_data_effect_2);

inst_tremolo : tremolo port map( clk, rst, sig_CE, LAUNCH3, to_integer(unsigned(DATA_tweak_3)), idata, sig_data_effect_3);

inst_freq_sinus : freq_sinus port map (LAUNCH4,clk,rst,sig_CE,DATA_tweak_4, sig_data_effect_4);

-- ====================================================================================
-- 										  Add signals
-- ====================================================================================

inst_add_effect_signal : add_effect_signal port map(clk, rst, sig_data_effect_1, sig_data_effect_2 , sig_data_effect_3, sig_data_effect_4, sig_data_effect);

inst_add_signal : add_signal port map(clk, rst, idata, sig_data_effect_volume, sig_data_global);

-- ====================================================================================
-- 										  sound level controls
-- ====================================================================================

inst_effect_volume :  volume port map(clk, rst, nb_volume_effet, sig_data_effect, sig_data_effect_volume);

inst_volume : volume port map(clk, rst, nb_volume_global, sig_data_global, sig_pwm);

-- ====================================================================================
-- 										  output formatting 
-- ====================================================================================

inst_PWM : PWM port map(clk, rst, sig_pwm, sig_CE, amp_SP, odata);

end Behavioral;
