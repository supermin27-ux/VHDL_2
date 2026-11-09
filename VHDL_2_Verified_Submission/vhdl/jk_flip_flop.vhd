library ieee;
use ieee.std_logic_1164.all;

entity jk_flip_flop is
    port (
        j   : in  std_logic;
        k   : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic
    );
end entity jk_flip_flop;

architecture rtl of jk_flip_flop is
    signal q_state : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            -- J,K = 00: hold, 01: reset, 10: set, 11: toggle.
            -- The last term lets Set resolve an unknown starting state.
            q_state <= (j and not q_state)
                    or (not k and q_state)
                    or (j and not k);
        end if;
    end process;

    q <= q_state;
end architecture rtl;
