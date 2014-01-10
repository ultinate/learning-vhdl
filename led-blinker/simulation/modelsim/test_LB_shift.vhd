--------------------------------------
-- Testbench for LB_Shift
-- 
-- author:  Nathanael Wettstein
-- updated: 2014-01-09
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------

entity test_LB_Shift is
	generic ( width : integer :=  8 );
end test_LB_Shift;

--------------------------------------

architecture testbench1 of test_LB_Shift is

	constant anti_glitch_delay : time := 1 ps;
	constant half_period : time := 100 ps;
	
	signal clk : std_logic := '0';
	signal sys_reset : std_logic := '1';
	signal led : std_logic_vector (width-1 downto 0);
	
begin

	dut : entity work.LB_Shift
	port map (
		clk => clk,
		sys_reset => sys_reset,
		led => led 
	);
	
	clk <= not clk after half_period;

	stimulus : process
		
		procedure jump_n_clocks (constant jump_n : integer) is
			variable i : integer := 0;
		begin
			while i < jump_n loop
				wait until rising_edge(clk);
				i := i+1;
			end loop;
			wait for anti_glitch_delay;
		end jump_n_clocks;
		
	begin
		
		-- assert initial state without reset
		jump_n_clocks(1);
		assert ( led = "00000010" ) report "init_01" severity error;
		jump_n_clocks(1);
		-- assert initial state with reset
		sys_reset <= '0';
		jump_n_clocks(1);
		assert ( led = x"01" ) report "init_02" severity error;
		jump_n_clocks(1);
		assert ( led = x"01" ) report "init_03" severity error;
		sys_reset <= '1';
		
		-- Run for a while, assert a few examples
		jump_n_clocks(1);
		assert ( led = "00000010" ) report "loop_01" severity error;
		jump_n_clocks(1);
		assert ( led = "00000100" ) report "loop_02" severity error;
		jump_n_clocks(5);
		assert ( led = "10000000" ) report "loop_03" severity error;
		jump_n_clocks(1);
		assert ( led = "01000000" ) report "loop_04" severity error;
		jump_n_clocks(6);
		assert ( led = "00000001" ) report "loop_04" severity error;
		jump_n_clocks(1);
		assert ( led = "00000010" ) report "loop_04" severity error;
		jump_n_clocks(5);
		sys_reset <= '0';
		jump_n_clocks(1);
		assert ( led = "00000001" ) report "loop_05" severity error;
		jump_n_clocks(1);
		assert ( led = "00000001" ) report "loop_05" severity error;
		
		assert false report "----- END OF SIMULATION (this is not a failure) -----" severity failure;
		
	end process stimulus;
end architecture testbench1;