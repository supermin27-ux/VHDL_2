library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity tb_d_latch is
end entity tb_d_latch;

architecture test of tb_d_latch is
    signal d : std_logic;
    signal en : std_logic;
    signal q : std_logic;
begin
    dut : entity work.d_latch
        port map (d => d, en => en, q => q);

    stimulus : process
        procedure drive_and_check (
            constant test_name : in string;
            constant d_in, en_in : in std_logic;
            constant q_expected : in std_logic
        ) is
        begin
            d <= d_in;
            en <= en_in;
            wait for 10 ns;

            if q_expected /= '-' then
                assert q = q_expected
                    report test_name & " | q expected " & std_logic'image(q_expected)
                        & ", observed " & std_logic'image(q)
                    severity failure;
            end if;
        end procedure drive_and_check;
    begin
        drive_and_check("01. Enable with D low", '0', '1', '0');
        drive_and_check("02. Follow D to one", '1', '1', '1');
        drive_and_check("03. Follow D to zero", '0', '1', '0');
        drive_and_check("04. Close latch at zero", '0', '0', '0');
        drive_and_check("05. Ignore D high when closed", '1', '0', '0');
        drive_and_check("06. Reopen with D high", '1', '1', '1');
        drive_and_check("07. Close latch at one", '1', '0', '1');
        drive_and_check("08. Ignore D low when closed", '0', '0', '1');
        drive_and_check("09. Reopen with D low", '0', '1', '0');
        drive_and_check("10. Follow D high again", '1', '1', '1');

        report "tb_d_latch PASS (10 checked states)" severity note;
        finish;
    end process stimulus;
end architecture test;
