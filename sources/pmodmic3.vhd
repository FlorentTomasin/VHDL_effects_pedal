----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2016 14:39:57
-- Design Name: 
-- Module Name: pmodmic3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: PmodMIC3 control 
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

entity pmodmic3 is
    Port ( 
           clk : in std_logic;
           rst : in std_logic;
           CS : out STD_LOGIC;
           MISO : in STD_LOGIC;
           SCLK : out STD_LOGIC;
           sdata : out std_logic_vector(11 downto 0)
           );
end pmodmic3;

architecture Behavioral of pmodmic3 is

signal cpt_CS : INTEGER range 0 to 2266 :=0;-- sampling signal (44.1kHz)
signal cpt_SCLK : INTEGER range 0 to 2266 :=0;-- under sampling signal to recieve a 16bits word
signal sig_data : std_logic_vector(11 downto 0) :="000000000000";

begin

--  ===================================================================================
-- 							  				synchronious control of the PmodMIC 3
--  ===================================================================================
process(clk,rst)
begin
    if (clk'event and clk='1') then 
        if(rst ='1') then
            cpt_CS <= 0;
            cpt_SCLK <= 0;
            sig_data <= "000000000000";
            CS <= '1';
            SCLK <= '0';
        elsif (cpt_CS > 5 and cpt_CS <2266) then --sampling control
            CS <= '0';
            cpt_SCLK <= cpt_SCLK + 1;
        else 
            CS <= '1';
            cpt_SCLK <= 0;
        end if;
        if cpt_SCLK = 141 then -- under sampling of 16bits during the sampling control 
            SCLK <= '1';
            sig_data  <= sig_data(10 downto 0) & MISO; --only  12bits contain audio informations
            cpt_SCLK <= 0; 
        else
            SCLK <= '0';
        end if;
        if cpt_CS = 2266 then --when counter is full, sample is ready  
            sdata <= std_logic_vector(unsigned(sig_data)); -- the affect process signed data
        end if;
        cpt_CS <= cpt_CS + 1;
    end if;
end process;


end Behavioral;
