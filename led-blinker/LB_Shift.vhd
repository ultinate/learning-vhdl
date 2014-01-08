--------------------------------------
-- LED Blinker: Shift module
-- 
-- Shift one glowing LED from left to right and back
-- 
-- author:  Nathanael Wettstein
-- updated: 2013-12-19
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------

entity LB_Shift is
	generic ( width : integer :=  8 );
port(
	clk : in std_logic;
	sys_reset : in std_logic;
	led : out std_logic_vector (width-1 downto 0)
);
end LB_Shift;

----

architecture LB_Shift_arch of LB_Shift is

	signal direction : std_logic := '1';
	signal led_temp : std_logic_vector (width-1 downto 0):= x"01";
	
begin
	
	process(clk, sys_reset, led_temp)
		variable direction_temp : std_logic := '0';
	begin
		
		-- reset counter and direction
		if sys_reset = '0' then
			led_temp <= x"01";
			direction <= '1';
			
		-- shift our bit left or right
		elsif rising_edge(clk) then
		
			if (led_temp = x"80" and direction = '1') or
					(led_temp = x"01" and direction = '0') then
				direction_temp := not direction;
				direction <= direction_temp;
			end if;
			
			if direction_temp = '1' then
				led_temp <= led_temp(width-2 downto 0) & led_temp(width-1); -- shift left by one
			else
				led_temp <= led_temp(0) & led_temp(width-1 downto 1); -- shift right by one
			end if;
			
		end if;
	
	end process;

	-- update LED
	led <= led_temp;
		
end LB_Shift_arch;