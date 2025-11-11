--------------------------------------------------------------------------------
-- Testbench for ALU
-- Compatible with FloPoCo-style input files
-- Reads from: tests/alu.input
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity tb_alu is
end entity;

architecture behavioral of tb_alu is

  -------------------------------------------------------------------------
  -- Component under test
  -------------------------------------------------------------------------
  component alu
    port (
      clk      : in  std_logic;
      op_code  : in  std_logic_vector(3 downto 0);
      a, b     : in  std_logic_vector(31 downto 0);
      result   : out std_logic_vector(31 downto 0);
      overFlow : out std_logic;
      done     : out std_logic
    );
  end component;

  -------------------------------------------------------------------------
  -- Signals
  -------------------------------------------------------------------------
  signal clk       : std_logic := '0';
  signal rst       : std_logic := '0';
  signal op_code   : std_logic_vector(3 downto 0);
  signal a, b      : std_logic_vector(31 downto 0);
  signal result    : std_logic_vector(31 downto 0);
  signal overFlow  : std_logic;
  signal done      : std_logic;

  constant clk_period : time := 10 ns;

  -------------------------------------------------------------------------
  -- Functions for conversion and display
  -------------------------------------------------------------------------
  function chr(sl: std_logic) return character is
    variable c: character;
  begin
    case sl is
      when 'U' => c := 'U';
      when 'X' => c := 'X';
      when '0' => c := '0';
      when '1' => c := '1';
      when 'Z' => c := 'Z';
      when others => c := '-';
    end case;
    return c;
  end function;

  function str(slv: std_logic_vector) return string is
    variable result : string (1 to slv'length);
    variable r : integer := 1;
  begin
    for i in slv'range loop
      result(r) := chr(slv(i));
      r := r + 1;
    end loop;
    return result;
  end function;

begin

  -------------------------------------------------------------------------
  -- Clock generation
  -------------------------------------------------------------------------
  process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  -------------------------------------------------------------------------
  -- Instantiate the ALU
  -------------------------------------------------------------------------
  uut: alu
    port map (
      clk      => clk,
      op_code  => op_code,
      a        => a,
      b        => b,
      result   => result,
      overFlow => overFlow,
      done     => done
    );

  -------------------------------------------------------------------------
  -- Stimulus process
  -------------------------------------------------------------------------
  process
    file inputsFile : text open read_mode is "tests/alu.input";
    variable input_line, exp_line : line;
    variable tmpChar  : character;
    variable v_op     : bit_vector(3 downto 0);
    variable v_a      : bit_vector(31 downto 0);
    variable v_b      : bit_vector(31 downto 0);
    variable v_r      : bit_vector(32 downto 0);
    variable expected_R : std_logic_vector(32 downto 0);
    variable testCounter : integer := 1;
    variable errorCounter : integer := 0;
  begin
    wait for 10 ns;

    readline(inputsFile, input_line); -- skip header

    while not endfile(inputsFile) loop
      readline(inputsFile, input_line); -- comment line
      readline(inputsFile, input_line); -- actual input line

      read(input_line, v_op);
      read(input_line, v_a);
      read(input_line, v_b);

      op_code <= to_stdlogicvector(v_op);
      a       <= to_stdlogicvector(v_a);
      b       <= to_stdlogicvector(v_b);

      -- wait for operation to complete
      wait for clk_period * 2;

      -- skip comment line "# Expected outputs for R"
      readline(inputsFile, exp_line);
      -- read expected output line
      readline(inputsFile, exp_line);
      read(exp_line, v_r);

      expected_R := to_stdlogicvector(v_r);

      -------------------------------------------------------------------
      -- Check results
      -------------------------------------------------------------------
      if result & overFlow = expected_R then
        report "Test #" & integer'image(testCounter) & " passed.";
      else
        errorCounter := errorCounter + 1;
        report "X Test #" & integer'image(testCounter) & " failed:"
          & lf & "  Expected: " & str(expected_R)
          & lf & "  Got:      " & str(result & overFlow)
          severity error;
      end if;

      testCounter := testCounter + 1;
      wait for clk_period;
    end loop;

    report integer'image(errorCounter) & " error(s) encountered." severity note;
    report "End of simulation after " & integer'image(testCounter-1) & " tests" severity note;
    wait;
  end process;

end architecture behavioral;
