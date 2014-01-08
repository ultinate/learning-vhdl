--------------------------------------
-- LED Blinker: Counter module
-- 
-- Binary count from 0 to 2^8-1 using LEDs
-- 
-- author:  Nathanael Wettstein
-- updated: 2013-12-19
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------

entity LB_Counter is
	generic ( width : integer :=  8 );
port(
	clk : in std_logic;
	sys_reset : in std_logic;
	led : out std_logic_vector (width-1 downto 0)
);
end LB_Counter;

----

architecture LB_Counter_arch of LB_Counter is

	constant COUNT_MAX : std_logic_vector := x"aa"; -- 2^8
	signal cnt : std_logic_vector (width-1 downto 0);
	
begin
	
	process(clk, sys_reset, cnt)
	begin
		
		-- reset count to zero
		if sys_reset = '0' then
			cnt <= (others => '0');
			
		-- count up
		elsif rising_edge(clk) then
			if cnt = COUNT_MAX then
				cnt <= (others => '0');
			else
				cnt <= std_logic_vector( unsigned(cnt) + 1 );
			end if;
		end if;
		
	end process;
		
	-- display binary representation on LED
	led <= cnt;
	
end LB_Counter_arch;