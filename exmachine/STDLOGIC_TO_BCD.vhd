--   _______    __    ______     ______     _____    ________
--  |   ____|  |  |  |   _  \   |   _  \   / __  \  |___  ___|
--  |  |____   |  |  |  |_|  |  |  |_| /  | |  | |     |  |
--  |   ____|  |  |  |       |  |   _  \  | |  | |     |  |
--  |  |____   |  |  |  |\  \   |  |_| |  | |__| |     |  |
--  |_______|  |__|  |__| \__\  |______/   \_____/     |__|
--
-- Module: STDLOGIC_TO_BCD
-- But: Transformer un numbre par la entrée serial en un numbre en BCD (decimal)
--
--http://www.eetkorea.com/ARTICLES/2000JUN/2000JUN27_PL_CT_AN6.PDF

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity STDLOGIC_TO_BCD is Port ( 
	H      : in  STD_LOGIC;
  RESET  : in  STD_LOGIC;
	BIN_IN : in  STD_LOGIC;
	BCD    : OUT STD_LOGIC_VECTOR(3 downto 0);
	BIN_OUT: OUT STD_LOGIC
);
end STDLOGIC_TO_BCD;

architecture Behavioral of STDLOGIC_TO_BCD is
SIGNAL lastBCD : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL nextBCD : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL buffOUT : STD_LOGIC;
begin
	BIN_OUT <= buffOUT;
	BCD <= lastBCD;
	nextBCD(0) <= BIN_IN;
	nextBCD(1) <= (not lastBCD(0))            when buffOUT='1' else lastBCD(0) ;
	nextBCD(2) <= (lastBCD(0)xnor lastBCD(1)) when buffOUT='1' else lastBCD(1) ;
	nextBCD(3) <= (lastBCD(0)and  lastBCD(3)) when buffOUT='1' else lastBCD(2) ;
	buffOUT <=  lastBCD(3) or (lastBCD(2) and (lastBCD(1)or lastBCD (0)));-->=5
	process(H)
	begin
		if(H'event and H='1')then 
			if(RESET = '1')then
				lastBCD <= "0000";
			else
				lastBCD <= nextBCD;
			end if;
		end if;
	end process;
	  
end Behavioral;

