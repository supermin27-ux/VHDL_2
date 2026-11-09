library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity tb_rs_latch is
end entity tb_rs_latch;

architecture test of tb_rs_latch is
    signal s : std_logic;
    signal r : std_logic;
    signal q : std_logic;
    signal q_n : std_logic;
begin
    dut : entity work.rs_latch
        port map (s => s, r => r, q => q, q_n => q_n);

    stimulus : process
        procedure drive_and_check (
            constant test_name : in string;
            constant s_in, r_in : in std_logic;
            constant q_expected, q_n_expected : in std_logic
        ) is
        begin
            s <= s_in;
            r <= r_in;
            wait for 10 ns;

            if q_expected /= '-' then
                assert q = q_expected
                    report test_name & " | q expected " & std_logic'image(q_expected)
                        & ", observed " & std_logic'image(q)
                    severity failure;
            end if;
            if q_n_expected /= '-' then
                assert q_n = q_n_expected
                    report test_name & " | q_n expected " & std_logic'image(q_n_expected)
                        & ", observed " & std_logic'image(q_n)
                    severity failure;
            end if;
        end procedure drive_and_check;
    begin
        drive_and_check("01. Reset", '0', '1', '0', '1');
        drive_and_check("02. Hold zero", '0', '0', '0', '1');
        drive_and_check("03. Set", '1', '0', '1', '0');
        drive_and_check("04. Hold one", '0', '0', '1', '0');
        drive_and_check("05. Forbidden from one", '1', '1', '0', '0');
        drive_and_check("06. Recover through Reset", '0', '1', '0', '1');
        drive_and_check("07. Hold zero after recovery", '0', '0', '0', '1');
        drive_and_check("08. Forbidden from zero", '1', '1', '0', '0');
        drive_and_check("09. Recover through Set", '1', '0', '1', '0');
        drive_and_check("10. Hold one after recovery", '0', '0', '1', '0');

        report "tb_rs_latch PASS (10 checked states)" severity note;
        finish;
    end process stimulus;
end architecture test;
