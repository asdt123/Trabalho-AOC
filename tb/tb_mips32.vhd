LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_mips32 IS
END tb_mips32;

ARCHITECTURE behavior OF tb_mips32 IS 

    COMPONENT mips32
        PORT(
            clk        : IN  std_logic;
            reset      : IN  std_logic;
            pc_out     : OUT std_logic_vector(31 downto 0);
            alu_result : OUT std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    -- Signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';

    signal pc_out     : std_logic_vector(31 downto 0);
    signal alu_result : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

BEGIN

    ----------------------------------------------------------------
    -- DUT (Device Under Test)
    ----------------------------------------------------------------
    uut: mips32
        PORT MAP (
            clk        => clk,
            reset      => reset,
            pc_out     => pc_out,
            alu_result => alu_result
        );

    ----------------------------------------------------------------
    -- Clock generator
    ----------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    ----------------------------------------------------------------
    -- Stimulus
    ----------------------------------------------------------------
    stim_proc: process
        variable cycle : integer := 0;
    begin
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';

        -- roda somente até o fim real do programa
        for cycle in 0 to 14 loop
            wait until rising_edge(clk);
            report "Cycle " & integer'image(cycle) &
                " | PC=" & to_hstring(pc_out) &
                " | ALU=" & to_hstring(alu_result);
        end loop;

        assert false report "Simulation Finished" severity failure;
        wait;
    end process;

END ARCHITECTURE;
