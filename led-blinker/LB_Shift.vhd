--------------------------------------
-- LED Blinker: Shift
-- 
-- Shift one glowing LED from left to right and back
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

	constant CLK_COUNT_MAX : integer := 50000000/2 - 1; -- 50MHz
	signal clk_cnt : unsigned (24 downto 0);
	signal direction : std_logic := '1';
	-- TODO: make this a bit_vector, so we can shift using sll, srl
	signal led_temp : std_logic_vector (width-1 downto 0):= x"01";
	
begin
	
	process(clk, sys_reset, led_temp)
	begin
		
		-- reset clock if button K2 is pressed (i.e. '0')
		if sys_reset = '0' then
			led_temp <= (x"01");
			direction <= '1';
			
		-- shift on-bit left or right
		elsif rising_edge(clk) then
		
			if (led_temp = x"80" and direction = '1') or
					(led_temp = x"01" and direction = '0') then
				direction <= not direction;
			end if;
			
			if clk_cnt = CLK_COUNT_MAX then
				clk_cnt <= (others => '0');
				if direction = '1' then
					led_temp <= led_temp(width-2 downto 0) & led_temp(width-1); -- shift left by one
				else
					led_temp <= led_temp(0) & led_temp(width-1 downto 1); -- shift right by one
				end if;
			else
				clk_cnt <= clk_cnt + 1;
			end if;
			
		end if;
	
	end process;

	-- update LED
	led <= led_temp;
		
end LB_Shift_arch;