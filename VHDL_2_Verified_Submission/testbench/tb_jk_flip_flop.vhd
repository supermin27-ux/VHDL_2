library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity tb_jk_flip_flop is
end entity tb_jk_flip_flop;

architecture test of tb_jk_flip_flop is
    signal j : std_logic;
    signal k : std_logic;
    signal clk : std_logic;
    signal q : std_logic;
begin
    dut : entity work.jk_flip_flop
        port map (j => j, k => k, clk => clk, q => q);

    stimulus : process
        procedure drive_and_check (
            constant test_name : in string;
            constant j_in, k_in, clk_in : in std_logic;
            constant q_expected : in std_logic
        ) is
        begin
            j <= j_in;
            k <= k_in;
            clk <= clk_in;
            wait for 10 ns;

            if q_expected /= '-' then
                assert q = q_expected
                    report test_name & " | q expected " & std_logic'image(q_expected)
                        & ", observed " & std_logic'image(q)
                    severity failure;
            end if;
        end procedure drive_and_check;
    begin
        drive_and_check("01. Start with clock low", '0', '1', '0', '-');
        drive_and_check("02. Reset on rise", '0', '1', '1', '0');
        drive_and_check("03. Change to Hold while clock is high", '0', '0', '1', '0');
        drive_and_check("04. Fall with Hold", '0', '0', '0', '0');
        drive_and_check("05. Hold zero on rise", '0', '0', '1', '0');
        drive_and_check("06. Change to Set while clock is high", '1', '0', '1', '0');
        drive_and_check("07. Fall with Set", '1', '0', '0', '0');
        drive_and_check("08. Set on rise", '1', '0', '1', '1');
        drive_and_check("09. Change to Hold while Q is one", '0', '0', '1', '1');
        drive_and_check("10. Fall holds one", '0', '0', '0', '1');
        drive_and_check("11. Hold one on rise", '0', '0', '1', '1');
        drive_and_check("12. Toggle inputs with no edge", '1', '1', '1', '1');
        drive_and_check("13. Fall with Toggle holds one", '1', '1', '0', '1');
        drive_and_check("14. First rise toggles one to zero", '1', '1', '1', '0');
        drive_and_check("15. Fall with Toggle holds zero", '1', '1', '0', '0');
        drive_and_check("16. Second rise toggles zero to one", '1', '1', '1', '1');
        drive_and_check("17. Change to Reset while clock is high", '0', '1', '1', '1');
        drive_and_check("18. Fall with Reset holds one", '0', '1', '0', '1');
        drive_and_check("19. Reset on next rise", '0', '1', '1', '0');
        drive_and_check("20. Change to Set while clock is high", '1', '0', '1', '0');
        drive_and_check("21. Fall still holds zero", '1', '0', '0', '0');
        drive_and_check("22. Set on next rise", '1', '0', '1', '1');

        report "tb_jk_flip_flop PASS (21 checked states)" severity note;
        finish;
    end process stimulus;
end architecture test;
