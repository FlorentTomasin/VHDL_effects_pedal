----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2016 23:04:01
-- Design Name: 
-- Module Name: effect_tweak - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Effects parameter controlled by PmodKYPD
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

entity effect_tweak is -- permet d'entrer des parametre pour chaques effets
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
          
end effect_tweak;

architecture Behavioral of effect_tweak is

component Decoder is
	Port (
			 clk : in  STD_LOGIC;
			 rst : in std_logic;
             Row : in  STD_LOGIC_VECTOR (3 downto 0);
			 Col : out  STD_LOGIC_VECTOR (3 downto 0);
             DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0)
          );
end component;

type state is (init,s_cent, s_dec, s_unit,launch);
signal cstate, nstate : state :=s_cent;
signal c_Decode, n_Decode: STD_LOGIC_VECTOR (3 downto 0);
signal sig_cent, sig_dec, sig_unit : std_logic_vector (3 downto 0) := "0000";
signal data,data_1,data_2,data_3,data_4 : integer range 0 to 999:=0;
signal cpt : integer range 0 to 20000000 :=0;
signal CE : std_logic;

begin

-- ====================================================================================
-- 									Decode the PmodKYPD input
-- ====================================================================================
inst_decoder : Decoder port map (clk=>clk, rst => rst, Row =>JB(7 downto 4), Col=>JB(3 downto 0), DecodeOut=> n_Decode);


-- ====================================================================================
-- 									synchronious State machine change
-- ====================================================================================
process(clk)
begin
    if (clk'event and clk ='1') then
        if (rst ='1') then
        
            cstate <= init;
            c_Decode <= "0000";  
            
        else
        
            c_Decode <= n_Decode;
            
            cstate <= nstate;
            data <= to_integer(unsigned(sig_cent))*100 + to_integer(unsigned(sig_dec))*10 + to_integer(unsigned(sig_unit));
            cent <= sig_cent;
            dec <= sig_dec;
            unit <= sig_unit;
            
        end if;    
    end if;
end process;

-- ====================================================================================
-- Assign to an effect it parameter synchroniously (allow the possibilty to tweak each effect independently)
-- ====================================================================================
process(clk, rst,WAIT_FOR_1,WAIT_FOR_2,WAIT_FOR_3,WAIT_FOR_4)
begin

    if(clk'event and clk ='1') then
        --------------------------------------------
            if(rst='1') then
                data_1 <= 0;
                data_2 <= 0;
                data_3 <= 0;
                data_4 <= 0;
            end if; 
        --------------------------------------------    
            if( WAIT_FOR_1 = '1')then
                data_1 <= data;
            else
                data_1 <= data_1;
            end if;
        --------------------------------------------    
            if( WAIT_FOR_2 = '1')then
                data_2 <= data;
            else
                data_2 <= data_2;
            end if;
        --------------------------------------------
            if( WAIT_FOR_3 = '1')then
                data_3 <= data;
            else
                data_3 <= data_3;   
            end if;
        --------------------------------------------            
            if( WAIT_FOR_4 = '1')then
                data_4 <= data;
            else
                data_4 <= data_4;
            end if;
    end if; 
      
end process;


-- ====================================================================================
-- Realised actions following th state machine
-- ====================================================================================
process(clk,cstate, nstate, c_Decode, right, left)
begin

    --if (clk'event and clk='1') then
        case cstate is
            when init => 
                sig_cent <= "0000";
                sig_dec <= "0000";
                sig_unit <= "0000";
                CONFIG_VALID <= '0';
                
                if (WAIT_FOR_1 ='1'  or WAIT_FOR_3 = '1' or WAIT_FOR_4 = '1') then -- condition if the effect need a parameter
                    nstate <= s_cent;
                elsif (WAIT_FOR_2 = '1') then -- condition if the effect dont need a parameter (jump user selection of the parameter values )
                    nstate <= launch;
                else    
                    nstate <= init;
                end if;
                
            when s_cent =>   -- Hundreds selection
             
                CONFIG_VALID <= '0';
                sig_cent <= c_Decode;
                
                if (right ='1') then -- pass to the tens
                    sig_cent <= sig_cent;
                    nstate <= s_dec;
                else 
                    nstate <= s_cent;
                end if;
                
            when s_dec => --tens selection
            
                CONFIG_VALID <= '0';   
                sig_dec <= c_Decode;  
                 
                if (right ='1') then -- pass to the unit
                    sig_dec <= sig_dec;
                    nstate <= s_unit;
                elsif (left ='1') then -- go back to the Hundreds
                    nstate <= s_cent;
                else
                    nstate <= s_dec;
                end if;    
                  
            when s_unit =>  --unit selection
              
                CONFIG_VALID <= '0';
                sig_unit <= c_Decode;
                
                if (right ='1') then -- pass to the lauching state
                    sig_unit <= sig_unit;
                    nstate <= launch;
                elsif (left ='1') then --go back to the tens
                    nstate <= s_dec;
                else
                    nstate <= s_unit;
                end if;  
                
            when launch => -- LAUNCH the effect
            
                CONFIG_VALID <= '1';
                
                nstate <= init;
                
        end case; 
    --end if;   
     
end process;

-- ====================================================================================
-- synchroniously output
-- ====================================================================================

process(clk, cstate)
begin 
    if(clk'event and clk ='1') then
            DATA_out_1 <= std_logic_vector(TO_UNSIGNED(data_1,10));
            DATA_out_2 <= std_logic_vector(TO_UNSIGNED(data_2,10));
            DATA_out_3 <= std_logic_vector(TO_UNSIGNED(data_3,10));
            DATA_out_4 <= std_logic_vector(TO_UNSIGNED(data_4,10));
    end if;
end process;


end Behavioral;
