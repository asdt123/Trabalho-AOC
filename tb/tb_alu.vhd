--------------------------------------------------------------------------------
-- Testbench for ALU (updated for combinational ALU without clk/overflow/done)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity tb_alu is
end entity;

architecture behavioral of tb_alu is

  ------------------------------------------------------------------------------
  -- Component under test
  ------------------------------------------------------------------------------
  component alu
    port (
      alu_cont   : in  std_logic_vector(2 downto 0);
      a, b       : in  std_logic_vector(31 downto 0);
      alu_result : out std_logic_vector(31 downto 0);
      zero       : out std_logic
    );
  end component;

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------
  signal alu_cont   : std_logic_vector(2 downto 0);
  signal a, b       : std_logic_vector(31 downto 0);
  signal alu_result : std_logic_vector(31 downto 0);
  signal zero       : std_logic;

  ------------------------------------------------------------------------------
  -- Helpers to convert text file input to std_logic_vector
  ------------------------------------------------------------------------------
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

  ------------------------------------------------------------------------------
  -- Instantiate ALU
  ------------------------------------------------------------------------------
  uut: alu
    port map (
      alu_cont   => alu_cont,
      a          => a,
      b          => b,
      alu_result => alu_result,
      zero       => zero
    );

  ------------------------------------------------------------------------------
  -- Stimulus process
  ------------------------------------------------------------------------------
  process
    file f : text open read_mode is "tests/alu.input";
    variable line_in  : line;
    variable line_exp : line;

    variable v_op  : std_logic_vector(2 downto 0);
    variable v_a   : std_logic_vector(31 downto 0);
    variable v_b   : std_logic_vector(31 downto 0);
    variable v_r   : std_logic_vector(31 downto 0);

    variable expected : std_logic_vector(31 downto 0);

    variable test_count  : integer := 1;
    variable error_count : integer := 0;
  begin

    -- skip header if any
    if not endfile(f) then
      readline(f, line_in);
    end if;

    while not endfile(f) loop

      ------------------------------------------------------------------------
      -- Read test input
      ------------------------------------------------------------------------
      readline(f, line_in);   -- actual data

      read(line_in, v_op);
      read(line_in, v_a);
      read(line_in, v_b);

      alu_cont <= std_logic_vector(v_op);
      a        <= std_logic_vector(v_a);
      b        <= std_logic_vector(v_b);

      wait for 30 ns; -- ALU is combinational -> small delay

      ------------------------------------------------------------------------
      -- Read expected output
      ------------------------------------------------------------------------
      readline(f, line_exp);  -- expected value line
      read(line_exp, v_r);
      expected := std_logic_vector(v_r);

      ------------------------------------------------------------------------
      -- Compare
      ------------------------------------------------------------------------
      if alu_result = expected then
        report "Test #" & integer'image(test_count) & " passed:";
      else
        error_count := error_count + 1;

        report "X Test #" & integer'image(test_count) & " FAILED:" &
               lf & "  Expected: " & str(expected) &
               lf & "  Got:      " & str(alu_result)
               severity error;
      end if;

      test_count := test_count + 1;

    end loop;

    --------------------------------------------------------------------------
    -- End report
    --------------------------------------------------------------------------
    report integer'image(error_count) & " error(s) encountered." severity note;
    report "End of simulation with " & integer'image(test_count-1) &
           " tests." severity note;

    wait;
  end process;

end architecture behavioral;
