----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2016 19:24:00
-- Design Name: 
-- Module Name: looper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Looper effect (play a recorded audio in loop)
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity looper is
    Port ( 
            clk : in std_logic;
            rst : in std_logic;
            CS : in std_logic;
            LAUNCH : in std_logic;
            RECORDER : in std_logic;
            idata : in std_logic_vector (11downto 0); 
            odata : out std_logic_vector (11downto 0)
            );
end looper;

architecture Behavioral of looper is

   CONSTANT RAM_DATA_OUT_BITS : integer :=    12; 
   CONSTANT RAM_MAX_ADDR  : integer := 50000;
   TYPE ram IS ARRAY(0 to (RAM_MAX_ADDR-1)) of STD_LOGIC_VECTOR ( RAM_DATA_OUT_BITS-1 DOWNTO 0);


    SIGNAL ram_block : ram := (others => (others => '0'));
    SIGNAL cpt_R : integer range 0 to 49999:=0;
    SIGNAL cpt_W : integer range 0 to 49999:=0;
    SIGNAL NB_MAX_ECH : integer range 0 to 49999:=49999;
    
    
    
begin

--  ===================================================================================
-- 							  				Addr counter
--  ===================================================================================
process (clk)
    begin
    if(clk='1' and clk'EVENT) then
        if (rst = '1' ) then
            cpt_R <= 0;
            cpt_W <= 0;
            NB_MAX_ECH <= 49999;
        elsif (CS ='1') then
            if(LAUNCH ='1') then
                if ( RECORDER = '1') then
                    if(cpt_R > 0 ) then
                        cpt_R <= 0;
                        cpt_W <= 0;
                    end if;
                    if (cpt_W=49999) then
                            cpt_W <= 0;
                    else
                        cpt_W <= cpt_W + 1 ;
                    end if;
                else
                    NB_MAX_ECH <= cpt_W;
                    --cpt_W <= 0;
                    if (cpt_R=NB_MAX_ECH) then
                            cpt_R <= 0;
                    else
                        cpt_R <= cpt_R + 1 ;
                    end if;
                end if;
            else
                cpt_R <= 0;
                cpt_W <= 0;
                NB_MAX_ECH <= 49999;
            end if;
        end if;
    end if;
end process;


--  ===================================================================================
-- 							  			R/W RAM managment
--  ===================================================================================
process(clk)

	begin
        if(clk='1' and clk'EVENT) then
            if (CS = '1') then    
                if (LAUNCH = '1') then 
                    if ( RECORDER = '1') then
                        ram_block(cpt_W) <= idata(11 downto 0);
                    else
                        odata <= ram_block(cpt_R);
                    end if;   
                else
                    odata <= "000000000000";
               end if;
            end if;
        end if;
end process;


end Behavioral;
