library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
end tb_alu;

architecture sim of tb_alu is

  component alu
    port (
      clk      : in  std_logic;
      op_code  : in  std_logic_vector(3 downto 0);
      a, b     : in  std_logic_vector(31 downto 0);
      result   : out std_logic_vector(32 downto 0);
      done     : out std_logic
    );
  end component;

  signal clk      : std_logic := '0';
  signal op_code  : std_logic_vector(3 downto 0);
  signal a, b     : std_logic_vector(31 downto 0);
  signal result   : std_logic_vector(32 downto 0);
  signal done     : std_logic;

begin

  uut: alu
    port map (
      clk => clk,
      op_code => op_code,
      a => a,
      b => b,
      result => result,
      done => done
    );

  -- Clock
  clk <= not clk after 10 ns;

  process
  begin
    ---------------------------------------------------------------------
    -- Teste: ADD inteiro
    ---------------------------------------------------------------------
    a <= std_logic_vector(to_signed(10, 32));
    b <= std_logic_vector(to_signed(3, 32));
    op_code <= "0000";  -- ADD
    wait for 40 ns;

    ---------------------------------------------------------------------
    -- Teste: SUB inteiro
    ---------------------------------------------------------------------
    op_code <= "0001";  -- SUB
    wait for 40 ns;

    ---------------------------------------------------------------------
    -- Teste: FPADD (exemplo com floats)
    ---------------------------------------------------------------------
    a <= x"41200000";  -- 10.0 em IEEE-754
    b <= x"40A00000";  -- 5.0 em IEEE-754
    op_code <= "0100";  -- FPADD
    wait for 40 ns;

    ---------------------------------------------------------------------
    -- Teste: FPSUB
    ---------------------------------------------------------------------
    op_code <= "0101";  -- FPSUB (10.0 - 5.0)
    wait for 40 ns;

    wait;
  end process;
end architecture;
