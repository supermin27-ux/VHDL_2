library ieee;
use ieee.std_logic_1164.all;

entity d_ff_async_set_clear is
    port (
        d   : in  std_logic;
        clk : in  std_logic;
        set : in  std_logic;
        clr : in  std_logic;
        q   : out std_logic
    );
end entity d_ff_async_set_clear;

architecture rtl of d_ff_async_set_clear is
begin
    process (clk, set, clr)
    begin
        if clr = '1' then
            q <= '0';
        elsif set = '1' then
            q <= '1';
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture rtl;
