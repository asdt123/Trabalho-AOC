LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_mips32 IS
END tb_mips32;

ARCHITECTURE behavior OF tb_mips32 IS 

    -- Component Declaration for the 32-bit MIPS Processor
    COMPONENT mips32
        PORT(
            clk        : IN  std_logic;
            reset      : IN  std_logic;
            pc_out     : OUT std_logic_vector(31 downto 0);
            alu_result : OUT std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    -- Inputs
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';

    -- Outputs
    signal pc_out     : std_logic_vector(31 downto 0);
    signal alu_result : std_logic_vector(31 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the 32-bit MIPS Processor
    uut: mips32
        PORT MAP (
            clk => clk,
            reset => reset,
            pc_out => pc_out,
            alu_result => alu_result
        );

    ----------------------------------------------------------------
    -- Clock process
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
    -- Stimulus process
    ----------------------------------------------------------------
    stim_proc: process
        variable cycle : integer := 0;
    begin
        -- Apply reset
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';

        -- Run simulation for 20 cycles (ou mais se quiser)
        for cycle in 0 to 60 loop
            wait until rising_edge(clk);
            report "Cycle " & integer'image(cycle) & 
                   " | PC=" & to_hstring(pc_out) &
                   " | ALU=" & to_hstring(alu_result);
        end loop;

        wait;  -- stop simulation
    end process;

END ARCHITECTURE;