--------------------------------------
-- LED Blinker
-- 
-- Make LEDs blink using various logic modules
-- 
-- author: Nathanael Wettstein
-- update: 2013-12-19
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------

entity LedBlinker is
	generic ( 
		width : integer :=  8; 
		btn_width : integer := 4
	);
port(
	clk : in std_logic;
	sys_reset : in std_logic;
	btn : in std_logic_vector (btn_width-1 downto 0);
	led : out std_logic_vector (width-1 downto 0)
);
end LedBlinker;

----

architecture LedBlinker_arch of LedBlinker is

	signal led_temp : std_logic_vector (width-1 downto 0);
	signal led_counter : std_logic_vector (width-1 downto 0);
	signal led_shift : std_logic_vector (width-1 downto 0);
	signal led_random : std_logic_vector (width-1 downto 0);
	
	type state_type is (state_count, state_shift, state_random, state_none);
	signal current_state, state_temp : state_type := state_none;

	component LB_Counter
		port (
			clk : in std_logic;
			sys_reset : in std_logic;
			led : out std_logic_vector (width-1 downto 0)
			);
	end component;
	component LB_Shift
		port (
			clk : in std_logic;
			sys_reset : in std_logic;
			led : out std_logic_vector (width-1 downto 0)
			);
	end component;
	component LB_Random
		port (
			clk : in std_logic;
			sys_reset : in std_logic;
			led : out std_logic_vector (width-1 downto 0)
			);
	end component;
		
begin

	-- state machine process
	process(btn)
	begin
		-- switch mode if a button is pressed (active-low)
		if btn(0) = '0' then
			state_temp <= state_count;
		elsif btn(1) = '0' then
			state_temp <= state_shift;
		elsif btn(3) = '0' then
			state_temp <= state_random;
		end if;
	end process;
	
	-- update state
	current_state <= state_temp;

	-- LED logic components 
	U1: LB_Counter port map (clk => clk, sys_reset => sys_reset, led => led_counter);
	U2: LB_Shift port map (clk => clk, sys_reset => sys_reset, led => led_shift);
	U3: LB_Random port map (clk => clk, sys_reset => sys_reset, led => led_random);
	
	-- update process
	process(clk, sys_reset)
	begin
		-- perform update step
		if rising_edge(clk) then
			case current_state is
				when state_count =>
					led_temp <= led_counter;
				when state_shift =>
					led_temp <= led_shift;
				when state_random =>
					led_temp <= led_random;
				when others =>
					led_temp <= (others => '0');
			end case;
		end if;
	end process;

	-- update LED
	led <= led_temp;
	
end LedBlinker_arch;