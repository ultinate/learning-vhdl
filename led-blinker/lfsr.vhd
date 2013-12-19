-------------------------------------------------------
-- Design Name  : lfsr
-- File Name    : lfsr.vhd
-- Function     : Linear feedback shift register
-- Coder        : Deepak Kumar Tala (Verilog)
-- Translator   : Alexander H Pham (VHDL)
-- 
-- retreived on : 2013-12-17
-- from         : http://www.asic-world.com/code/vhdl_examples/lfsr.vhd
-------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

entity lfsr is
  port (
    enable :in  std_logic;                    -- Enable counting
    clk    :in  std_logic;                    -- Input rlock
    reset  :in  std_logic;                    -- Input reset
    cout   :out std_logic_vector (7 downto 0) -- Output of the counter
  );
end entity;

architecture rtl of lfsr is
    signal count           :std_logic_vector (7 downto 0);
    signal linear_feedback :std_logic;

begin
    linear_feedback <= not(count(7) xor count(3));

    process (clk, reset) begin
        if (reset = '1') then
            count <= (others=>'0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                count <= (count(6) & count(5) & count(4) & count(3) 
                          & count(2) & count(1) & count(0) & 
                          linear_feedback);
            end if;
        end if;
    end process;
    cout <= count;
end architecture;