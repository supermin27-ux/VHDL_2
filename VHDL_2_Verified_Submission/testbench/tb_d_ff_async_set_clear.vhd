library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity tb_d_ff_async_set_clear is
end entity tb_d_ff_async_set_clear;

architecture test of tb_d_ff_async_set_clear is
    signal d : std_logic;
    signal clk : std_logic;
    signal set : std_logic;
    signal clr : std_logic;
    signal q : std_logic;
begin
    dut : entity work.d_ff_async_set_clear
        port map (d => d, clk => clk, set => set, clr => clr, q => q);

    stimulus : process
        procedure drive_and_check (
            constant test_name : in string;
            constant d_in, clk_in, set_in, clr_in : in std_logic;
            constant q_expected : in std_logic
        ) is
        begin
            d <= d_in;
            clk <= clk_in;
            set <= set_in;
            clr <= clr_in;
            wait for 10 ns;

            if q_expected /= '-' then
                assert q = q_expected
                    report test_name & " | q expected " & std_logic'image(q_expected)
                        & ", observed " & std_logic'image(q)
                    severity failure;
            end if;
        end procedure drive_and_check;
    begin
        drive_and_check("01. Clear at low clock with D high", '1', '0', '0', '1', '0');
        drive_and_check("02. Release Clear at low clock", '1', '0', '0', '0', '0');
        drive_and_check("03. Normal rise captures one", '1', '1', '0', '0', '1');
        drive_and_check("04. D falls with clock high", '0', '1', '0', '0', '1');
        drive_and_check("05. Clear at high clock without an edge", '0', '1', '0', '1', '0');
        drive_and_check("06. Both active with clock high", '0', '1', '1', '1', '0');
        drive_and_check("07. Clear release leaves Set active", '0', '1', '1', '0', '1');
        drive_and_check("08. Set release at high clock with D low", '0', '1', '0', '0', '1');
        drive_and_check("09. Falling edge holds one", '0', '0', '0', '0', '1');
        drive_and_check("10. Normal rise captures zero", '0', '1', '0', '0', '0');
        drive_and_check("11. Falling edge holds zero", '0', '0', '0', '0', '0');
        drive_and_check("12. Set at low clock with D low", '0', '0', '1', '0', '1');
        drive_and_check("13. Set release at low clock with D low", '0', '0', '0', '0', '1');
        drive_and_check("14. Rise after Set release captures zero", '0', '1', '0', '0', '0');
        drive_and_check("15. Set at high clock without an edge", '0', '1', '1', '0', '1');
        drive_and_check("16. Clear overrides active Set from one", '0', '1', '1', '1', '0');
        drive_and_check("17. Both active ignore D change", '1', '1', '1', '1', '0');
        drive_and_check("18. Set release leaves Clear active", '1', '1', '0', '1', '0');
        drive_and_check("19. Clear release at high clock with D high", '1', '1', '0', '0', '0');
        drive_and_check("20. Fall after Clear release holds zero", '1', '0', '0', '0', '0');
        drive_and_check("21. Rise after Clear release captures one", '1', '1', '0', '0', '1');
        drive_and_check("22. Falling edge holds one again", '1', '0', '0', '0', '1');
        drive_and_check("23. Clear at low clock from one", '1', '0', '0', '1', '0');
        drive_and_check("24. Rising edge with Clear active", '1', '1', '0', '1', '0');
        drive_and_check("25. Falling edge with Clear active", '1', '0', '0', '1', '0');
        drive_and_check("26. Both active with clock low", '1', '0', '1', '1', '0');
        drive_and_check("27. Clear release at low clock leaves Set active", '1', '0', '1', '0', '1');
        drive_and_check("28. D falls while Set stays active", '0', '0', '1', '0', '1');
        drive_and_check("29. Rising edge with Set active and D low", '0', '1', '1', '0', '1');
        drive_and_check("30. Falling edge with Set active", '0', '0', '1', '0', '1');
        drive_and_check("31. Clear overrides Set at low clock", '0', '0', '1', '1', '0');
        drive_and_check("32. Release both controls together", '0', '0', '0', '0', '0');
        drive_and_check("33. D rises while clock stays low", '1', '0', '0', '0', '0');
        drive_and_check("34. Normal rise after both controls released", '1', '1', '0', '0', '1');
        drive_and_check("35. Assert both controls together from one", '1', '1', '1', '1', '0');
        drive_and_check("36. Release both together at high clock", '1', '1', '0', '0', '0');
        drive_and_check("37. Fall after simultaneous release", '1', '0', '0', '0', '0');
        drive_and_check("38. Normal capture resumes on next rise", '1', '1', '0', '0', '1');

        report "tb_d_ff_async_set_clear PASS (38 checked states)" severity note;
        finish;
    end process stimulus;
end architecture test;
