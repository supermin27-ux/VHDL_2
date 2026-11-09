library ieee;
use ieee.std_logic_1164.all;

entity rs_latch is
    port (
        s   : in  std_logic;
        r   : in  std_logic;
        q   : out std_logic;
        q_n : out std_logic
    );
end entity rs_latch;

architecture structural of rs_latch is
    signal q_state   : std_logic;
    signal q_n_state : std_logic;
begin
    -- Both outputs are low while S and R are both high.
    q_state   <= r nor q_n_state;
    q_n_state <= s nor q_state;

    q   <= q_state;
    q_n <= q_n_state;
end architecture structural;
