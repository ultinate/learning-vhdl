-------------------------------------------------------
-- adapted from : http://www.asic-world.com/examples/vhdl/lfsr.html
-- Coder        : Deepak Kumar Tala (Verilog)
-- Translator   : Alexander H Pham (VHDL)
-- retreived on : 2013-12-17
-- 
-- modified by  : Nathanael Wettstein
-- updated on   : 2014-01-08
-------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

entity lfsr is
    generic (
        width :integer := 8
    );
  port (
    enable :in  std_logic;                    -- Enable counting
    clk    :in  std_logic;                    -- Input clock
    reset  :in  std_logic;                    -- Input reset
    cout   :out std_logic_vector (7 downto 0) -- Output of the counter
  );
end entity;

architecture rtl of lfsr is
    signal count           :std_logic_vector (width-1 downto 0);

begin

    process (clk, reset, count, enable)
        variable temp_a :std_logic_vector (width-1 downto 0);
        variable temp_b :std_logic :='1';
    begin
        temp_a := count and "01100011";
        temp_b :='1';
        for i in 0 to width-1 loop
            temp_b := temp_a(i) xnor temp_b;
        end loop;

        if (rising_edge(clk)) then
            if (reset = '1') then
                count <= (others=>'0');
            elsif (enable = '1') then
                count <= (temp_b & count(width-1 downto 1));
            end if;
        end if;
    end process;
    cout <= count;
	 
end architecture;