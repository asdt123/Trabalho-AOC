library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_MyFAdd is
end tb_MyFAdd;

architecture sim of tb_MyFAdd is
    signal clk : std_logic := '0';
    signal X, Y, R : std_logic_vector(33 downto 0);

begin

    -- Instancia o somador
    uut: entity work.MyFAdd
        port map (
            clk => clk,
            X => X,
            Y => Y,
            R => R
        );

    -- Clock simples de 10 ns
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Estímulos e gravação em arquivo
    stim_proc: process
    begin
        -- Exemplo 1: 1.5 + 2.25
        X <= "00" & x"3FC00000"; -- 1.5
        Y <= "00" & x"40100000"; -- 2.25
        wait for 100 ns;

        -- Exemplo 2: -3.0 + 1.0
        X <= "00" & x"C0400000"; -- -3.0
        Y <= "00" & x"3F800000"; -- 1.0
        wait for 40 ns;

        wait;
    end process;

end sim;
