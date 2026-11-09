library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity tb_d_flip_flop is
end entity tb_d_flip_flop;

architecture test of tb_d_flip_flop is
    signal d : std_logic;
    signal clk : std_logic;
    signal q : std_logic;
begin
    dut : entity work.d_flip_flop
        port map (d => d, clk => clk, q => q);

    stimulus : process
        procedure drive_and_check (
            constant test_name : in string;
            constant d_in, clk_in : in std_logic;
            constant q_expected : in std_logic
        ) is
        begin
            d <= d_in;
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
        drive_and_check("01. Start with clock low", '0', '0', '-');
        drive_and_check("02. Rise captures zero", '0', '1', '0');
        drive_and_check("03. D rises while clock stays high", '1', '1', '0');
        drive_and_check("04. Falling edge holds zero", '1', '0', '0');
        drive_and_check("05. D falls while clock stays low", '0', '0', '0');
        drive_and_check("06. D rises while clock stays low", '1', '0', '0');
        drive_and_check("07. Rise captures one", '1', '1', '1');
        drive_and_check("08. D falls while clock stays high", '0', '1', '1');
        drive_and_check("09. Falling edge holds one", '0', '0', '1');
        drive_and_check("10. Next rise captures zero", '0', '1', '0');
        drive_and_check("11. D rises while clock stays high", '1', '1', '0');
        drive_and_check("12. Next falling edge holds zero", '1', '0', '0');
        drive_and_check("13. Next rise captures one", '1', '1', '1');
        drive_and_check("14. Last falling edge holds one", '1', '0', '1');

        report "tb_d_flip_flop PASS (13 checked states)" severity note;
        finish;
    end process stimulus;
end architecture test;
