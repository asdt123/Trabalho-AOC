--------------------------------------------------------------------------------
-- Testbench para CONTROL_ALU
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity tb_control_alu is
end entity;

architecture behavioral of tb_control_alu is

  ------------------------------------------------------------------------------
  -- Componente sob teste
  ------------------------------------------------------------------------------
  component ALU_Control is
    port(
      Op       : in  std_logic_vector(2 downto 0);
      funct       : in  std_logic_vector(2 downto 0);
      ALU_Cont    : out std_logic_vector(2 downto 0)
    );
  end component;
  
  ------------------------------------------------------------------------------
  -- Sinais
  ------------------------------------------------------------------------------
  signal Op    : std_logic_vector(2 downto 0);
  signal funct    : std_logic_vector(2 downto 0);
  signal ALU_Cont : std_logic_vector(2 downto 0);

  ------------------------------------------------------------------------------
  -- Funções de ajuda (mesmas do seu tb_alu)
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
  -- DUT Instantiation
  ------------------------------------------------------------------------------
  uut: ALU_Control
    port map (
      Op    => Op,
      funct    => funct,
      ALU_Cont => ALU_Cont
    );

  ------------------------------------------------------------------------------
  -- Process de estímulo
  ------------------------------------------------------------------------------
  process
    file f : text open read_mode is "tests/control_alu.input";
    variable line_in  : line;
    variable line_exp : line;

    variable v_aluop  : std_logic_vector(2 downto 0);
    variable v_funct  : std_logic_vector(2 downto 0);
    variable v_cont   : std_logic_vector(2 downto 0);

    variable expected : std_logic_vector(2 downto 0);

    variable test_count  : integer := 1;
    variable error_count : integer := 0;

  begin

    -- pular header se existir
    if not endfile(f) then
      readline(f, line_in);
    end if;

    while not endfile(f) loop

      ------------------------------------------------------------------------
      -- Ler entrada
      ------------------------------------------------------------------------
      readline(f, line_in);
      read(line_in, v_aluop);
      read(line_in, v_funct);

      Op <= v_aluop;
      funct <= v_funct;

      wait for 20 ns;

      ------------------------------------------------------------------------
      -- Ler valor esperado
      ------------------------------------------------------------------------
      readline(f, line_exp);
      read(line_exp, v_cont);
      expected := v_cont;

      ------------------------------------------------------------------------
      -- Comparação
      ------------------------------------------------------------------------
      if alu_cont = expected then
        report "Test #" & integer'image(test_count) & " passed.";
      else
        error_count := error_count + 1;
        report "X Test #" & integer'image(test_count) & " FAILED:"
          & lf & "  Expected: " & str(expected)
          & lf & "  Got:      " & str(alu_cont)
          severity error;
      end if;

      test_count := test_count + 1;

    end loop;

    --------------------------------------------------------------------------
    -- Summary
    --------------------------------------------------------------------------
    report integer'image(error_count) & " error(s) encountered." severity note;
    report "End of simulation with " &
           integer'image(test_count-1) & " tests." severity note;

    wait;
  end process;

end architecture behavioral;
