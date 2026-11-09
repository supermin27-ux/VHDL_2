library ieee;
use ieee.std_logic_1164.all;

entity d_flip_flop is
    port (
        d   : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic
    );
end entity d_flip_flop;

architecture rtl of d_flip_flop is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture rtl;
