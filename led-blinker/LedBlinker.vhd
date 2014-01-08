--------------------------------------
-- LED Blinker
-- 
-- Make LEDs blink using various logic modules
-- 
-- author:  Nathanael Wettstein
-- updated: 2013-12-19
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

	signal led_counter : std_logic_vector (width-1 downto 0);
	signal led_shift : std_logic_vector (width-1 downto 0);
	signal led_random : std_logic_vector (width-1 downto 0);
	
	constant CLK_COUNT_MAX : integer := 50000000/4 - 1; -- clk at 50MHz, slow_clk at 4 Hz
	signal clk_cnt : unsigned (24 downto 0);
	signal slow_clk : std_logic;
	
	signal btn0_last : std_logic;
	
	type state_type is (state_count, state_shift, state_random);
	signal state : state_type;

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
	process(clk)
	begin
		if rising_edge(clk) then
			if btn(0) = '0' and btn0_last = '1' then
				case state is
					when state_count => 
						state <= state_shift;
					when state_shift =>
						state <= state_random;
					when state_random =>
						state <= state_count;
				end case;
			else
				state <= state;
			end if;
			btn0_last <= btn(0);
		end if;
	end process;

	-- LED logic components 
	U1: LB_Counter port map (clk => slow_clk, sys_reset => sys_reset, led => led_counter);
	U2: LB_Shift port map (clk => slow_clk, sys_reset => sys_reset, led => led_shift);
	U3: LB_Random port map (clk => slow_clk, sys_reset => sys_reset, led => led_random);
	
	-- generate slow clock for visible LED update
	-- TODO: replace by PLL
	process(clk, slow_clk, clk_cnt)
	begin
		if rising_edge(clk) then
			if clk_cnt = CLK_COUNT_MAX then
				clk_cnt <= (others => '0');
				slow_clk <= not slow_clk;
			else
				clk_cnt <= clk_cnt + 1;
			end if;
		end if;
	end process;
	
	-- LED update process
	process(clk)
	begin
		if rising_edge(clk) then
			case state is
				when state_count =>
					led <= led_counter;
				when state_shift =>
					led <= led_shift;
				when state_random =>
					led <= led_random;
				when others =>
					led <= (others => '0');
			end case;
		end if;
	end process;
	
end LedBlinker_arch;