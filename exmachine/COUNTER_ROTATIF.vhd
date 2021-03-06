--   _______    __    ______     ______     _____    ________
--  |   ____|  |  |  |   _  \   |   _  \   / __  \  |___  ___|
--  |  |____   |  |  |  |_|  |  |  |_| /  | |  | |     |  |
--  |   ____|  |  |  |       |  |   _  \  | |  | |     |  |
--  |  |____   |  |  |  |\  \   |  |_| |  | |__| |     |  |
--  |_______|  |__|  |__| \__\  |______/   \_____/     |__|
--
-- Module: COUNTER_ROTATIF
-- But: Traduire les pulses que viennent d'un encoder pour des pulses qui 
-- vont entrer dans un compteur.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COUNTER_ROTATIF is Port ( 
	H    : in  STD_LOGIC;
	SIG  : in  STD_LOGIC_VECTOR (1 downto 0);
	SORT : out STD_LOGIC_VECTOR (1 downto 0);
	RESET: in  STD_LOGIC
);
end COUNTER_ROTATIF;

architecture Behavioral of COUNTER_ROTATIF is
constant taille : Integer := 8;
constant zeros  : STD_LOGIC_VECTOR(taille-1 downto 0) := (others => '0');
constant ones  : STD_LOGIC_VECTOR(taille-1 downto 0) := (others => '1');
SIGNAL BUFFIN: STD_LOGIC_VECTOR (1 downto 0);
SIGNAL BUFFOUT: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL ETAT : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL DIR: STD_LOGIC;
signal lastSig, lastBuffin: STD_LOGIC_VECTOR(1 downto 0);
signal buff0, buff1 : STD_LOGIC_VECTOR(taille-1 downto 0);
begin
	SORT <= BUFFOUT;
--	filtreRebound: process(H)
--	begin
--		if(H'event and H='1')then
--			if(RESET='1')then
--				BUFFIN <= "00";
--			else
--				if(SIG(0)/=lastSig(0))then
--					BUFFIN(1) <= SIG(1);
--				end if;
--				if(SIG(1)/=lastSig(1))then
--					BUFFIN(0) <= SIG(0);
--				end if;
--			end if;
--			lastSig <= SIG;
--		end if;
--	end process;
	
	filtreRebound: process(H)
	begin
		if(H'event and H='1')then
			if(RESET='1')then
				buff0 <= (others=>'0');
				buff1 <= (others=>'0');
			else
				buff0 <= buff0(taille-2 downto 0) & SIG(0);
				buff1 <= buff1(taille-2 downto 0) & SIG(1);
				if(buff0 = zeros)then 
					BUFFIN(0) <='0';
				elsif(buff0 = ones)then
					BUFFIN(0) <='1';
				end if;
				if(buff1 = zeros)then 
					BUFFIN(1) <='0';
				elsif(buff1 = ones)then
					BUFFIN(1) <='1';
				end if;
			end if;
		end if;
	end process;
	
	counter: process(H)
	begin
		if(H'event and H='1')then
			if(RESET='1')then
				lastBuffin <= "00";
				BUFFOUT <= "00";
			else
				if( (lastBuffin(0)='0' and BUFFIN(0)='1' and BUFFIN(1)='0') or
					 (lastBuffin(1)='0' and BUFFIN(1)='1' and BUFFIN(0)='1') or
					 (lastBuffin(0)='1' and BUFFIN(0)='0' and BUFFIN(1)='1') or
					 (lastBuffin(1)='1' and BUFFIN(1)='0' and BUFFIN(0)='0')    )then
					BUFFOUT(0) <= '1';
				else
					BUFFOUT(0) <= '0';
				end if;
				
				if( (lastBuffin(0)='0' and BUFFIN(0)='1' and BUFFIN(1)='1') or
					 (lastBuffin(1)='0' and BUFFIN(1)='1' and BUFFIN(0)='0') or
					 (lastBuffin(0)='1' and BUFFIN(0)='0' and BUFFIN(1)='0') or
					 (lastBuffin(1)='1' and BUFFIN(1)='0' and BUFFIN(0)='1')    )then
					BUFFOUT(1) <= '1';
				else
					BUFFOUT(1) <= '0';
				end if;
				
				lastBuffin <= BUFFIN;
			end if;
		end if;
	end process;
		
--	counter: process(H)
--	begin
--		if(H'event and H='1')then
--			if(RESET='1')then
--				BUFFOUT <= "00";
--				ETAT <= "000";
--			else
--				case ETAT is
--					--   +
--					when "101"=> ETAT <= '1' & BUFFIN;        BUFFOUT <= "00";
--					when "111"=> ETAT <= '1' & BUFFIN;        BUFFOUT <= "00";
--					when "110"=> ETAT <= '1' & BUFFIN;        BUFFOUT <= '0' & (not BUFFIN(1));
--					when "100"=> ETAT <= BUFFIN(0) & BUFFIN;  BUFFOUT <= "00";
--					--   -
--					when "010"=> ETAT <= '0' & BUFFIN;        BUFFOUT <= "00";
--					when "011"=> ETAT <= '0' & BUFFIN;        BUFFOUT <= "00";
--					when "001"=> ETAT <= '0' & BUFFIN;        BUFFOUT <= (not BUFFIN(0)) & '0';
--					when "000"=> ETAT <= BUFFIN(0) & BUFFIN;  BUFFOUT <= "00";
--					
--				end case;
--			end if;
--		end if;
--	end process;
	
--	counter: process(H)
--	begin
--		if(H'event and H='1')then
--			if(RESET='1')then
--				BUFFOUT <= "00";
--			else
--				if(lastBuffin /= BUFFIN)then
--					if(BUFFIN = "00" and BUFFOUT="00")then 
--						BUFFOUT(0) <= DIR;
--						BUFFOUT(1) <= not DIR;
--					else
--						BUFFOUT <= "00";
--					end if;
--					DIR <= BUFFIN(0);
--				else
--					BUFFOUT <= "00";
--				end if;
--			end if;
--			lastBuffin <= BUFFIN;
--		end if;
--	end process;
	
end Behavioral;

