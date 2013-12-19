--------------------------------------
-- LED Blinker: Counter
-- 
-- Binary count from 0 to 2^8-1 using LEDs
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------

entity LB_Counter is
port(
	clk : in std_logic;
	sys_reset : in std_logic;
	led : out std_logic_vector (7 downto 0)
);
end LB_Counter;

----

architecture LB_Counter_arch of LB_Counter is

	constant CLK_COUNT_MAX : integer := 50000000/2 - 1; -- 50MHz
	constant COUNT_MAX : std_logic_vector := x"aa"; -- 2^8
	signal clk_cnt : unsigned (24 downto 0);
	signal cnt : std_logic_vector (7 downto 0);
	
begin
	
	process(clk, sys_reset, cnt)
	begin
		
		-- reset clock if button K2 is pressed (i.e. '0')
		if sys_reset = '0' then
			cnt <= (others => '0');
			
		-- count up
		elsif rising_edge(clk) then
			if cnt = COUNT_MAX then
				cnt <= (others => '0');
			elsif clk_cnt = CLK_COUNT_MAX then
				clk_cnt <= (others => '0');
				cnt <= std_logic_vector( unsigned(cnt) + 1 );
			else
				clk_cnt <= clk_cnt + 1;
			end if;
		end if;
		
	end process;
		
	-- display binary representation on LED
	led <= cnt;
	
end LB_Counter_arch;