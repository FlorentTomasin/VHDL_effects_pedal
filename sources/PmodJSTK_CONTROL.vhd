----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2016 21:04:58
-- Design Name: 
-- Module Name: PmodJSTK_CONTROL - Behavioral
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

entity PmodJSTK_CONTROL is
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
end PmodJSTK_CONTROL;

architecture Behavioral of PmodJSTK_CONTROL is


--  ===================================================================================
-- 							  			Signals and Constants
--  ===================================================================================

			-- Holds data to be sent to PmodJSTK
			signal sndData : STD_LOGIC_VECTOR(7 downto 0) := X"00";

			-- Signal to send/receive data to/from PmodJSTK
			signal sndRec : STD_LOGIC;

			-- Signal indicating that SPI interface is busy
			signal BUSY : STD_LOGIC := '0';

			-- Data read from PmodJSTK
			signal jstkData : STD_LOGIC_VECTOR(39 downto 0) := (others => '0');

			-- Signal carrying output data that user selected
			signal posData : STD_LOGIC_VECTOR(9 downto 0);

			signal but1 : STD_LOGIC;
			signal but2 : STD_LOGIC;
			
begin

			-------------------------------------------------
			--  	  			PmodJSTK Interface
			------------------------------------------------
			PmodJSTK_Int : ENTITY work.PmodJSTK port map(
					CLK      => CLK,
					RST      => RST,
					sndRec   => sndRec,
					DIN      => "10000000", -- LES 2 BITS DE POIDS FAIBLE COMMANDENT LES LEDS SUR LE PMOD,
					MISO     => MISO,
					SS       => SS,
					SCLK     => SCLK,
					MOSI     => MOSI,
                    x_val    => posX,
                    y_val    => posY,
                    button_1 => but1,
                    button_2 => but2
			);
			
			genSndRec : ENTITY work.ClkDiv_5Hz port map(
                    CLK=>CLK,
                    RST=>RST,
                    CLKOUT=>sndRec
            );


end Behavioral;
