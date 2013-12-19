--------------------------------------
-- LED Blinker: Random module
-- 
-- Display pseudo-random sequence of LED pattern
-- 
-- author:  Nathanael Wettstein
-- updated: 2013-12-19
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.math_real.all;

--------------------------------------

entity LB_Random is
	generic ( width : integer :=  8 );
port(
	clk : in std_logic;
	sys_reset : in std_logic;
	led : out std_logic_vector (width-1 downto 0)
);
end LB_Random;

----

architecture LB_Random_arch of LB_Random is

	constant CLK_COUNT_MAX : integer := 50000000/2 - 1; -- 50MHz
	signal clk_cnt : unsigned (24 downto 0);
	signal random_num : std_logic_vector (width-1 downto 0);
	signal led_temp : std_logic_vector (width-1 downto 0);
	constant enable : std_logic := '1';
	constant reset : std_logic := '0';

	component lfsr is
		port (
			enable : in  std_logic;                    			-- Enable counting
			clk    : in  std_logic;                    			-- Input rlock
			reset  : in  std_logic;                    			-- Input reset
			cout   : out std_logic_vector (width-1 downto 0) 	-- Output of the counter
		);
	end component;
	
begin
	
	U1: lfsr port map (enable => enable, clk => clk, reset => reset, cout => random_num);
	
	process(clk, sys_reset)
	begin
	
		-- reset clock if button K2 is pressed (i.e. '0')
		if sys_reset = '0' then
			led_temp <= (others => '0');
		
		-- prepare random number
		elsif rising_edge(clk) then
			if clk_cnt = CLK_COUNT_MAX then
				clk_cnt <= (others => '0');
				led_temp <= random_num;
			else
				clk_cnt <= clk_cnt + 1;
			end if;
		end if;
	
	end process;
	
	-- display randon number on LED
	led <= led_temp;
	
end LB_Random_arch;