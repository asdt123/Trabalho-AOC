library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
    clk      : in  std_logic;
    op_code  : in  std_logic_vector(3 downto 0);
    a, b     : in  std_logic_vector(31 downto 0);
    result   : out std_logic_vector(32 downto 0);
    done     : out std_logic
  );
end entity alu;

architecture Behavioral of alu is

  ---------------------------------------------------------------------------
  -- Componentes
  ---------------------------------------------------------------------------
  component IEEEFPAdd_8_23_comb_uid2
    port (
      X, Y : in  std_logic_vector(31 downto 0);
      R    : out std_logic_vector(31 downto 0)
    );
  end component;

  component IntAddSub_w32_XcY_comb_uid2 is
    port (
      X     : in  std_logic_vector(31 downto 0);
      Y     : in  std_logic_vector(31 downto 0);
      negY  : in  std_logic;
      R     : out std_logic_vector(32 downto 0)
    );
  end component;

  ---------------------------------------------------------------------------
  -- Sinais internos
  ---------------------------------------------------------------------------
  signal int_sum   : std_logic_vector(32 downto 0);
  signal float_res : std_logic_vector(31 downto 0);
  signal int_res   : std_logic_vector(32 downto 0);
  signal r_logic   : std_logic_vector(31 downto 0);
  signal neg_y     : std_logic;
  signal fadd_x, fadd_y : std_logic_vector(31 downto 0);
  signal done_reg  : std_logic := '0';

begin

  ---------------------------------------------------------------------------
  -- Instancias dos modulos
  ---------------------------------------------------------------------------
  -- Inteiro (Add/Sub)
  u_intaddsub : IntAddSub_w32_XcY_comb_uid2
    port map (
      X     => a,
      Y     => b,
      negY  => neg_y,
      R     => int_sum
    );

  -- Ponto flutuante (Add/Sub)
  u_fadd : IEEEFPAdd_8_23_comb_uid2
    port map (
      X => fadd_x,
      Y => fadd_y,
      R => float_res
    );

  ---------------------------------------------------------------------------
  -- Processo principal da ALU
  ---------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then

      done_reg <= '0';
      neg_y    <= '0';
      fadd_x   <= (others => '0');
      fadd_y   <= (others => '0');

      case op_code is

        -- Soma inteira
        when "0000" =>
          neg_y    <= '0';
          int_res  <= int_sum(32 downto 0);
          done_reg <= '1';

        -- Subtracao inteira
        when "0001" =>
          neg_y    <= '1';
          int_res  <= int_sum(32 downto 0);
          done_reg <= '1';

        -- Soma ponto flutuante
        when "0010" =>
          fadd_x   <= a;
          fadd_y   <= b;
          int_res  <= float_res & '0' ;
          done_reg <= '1';

        -- Subtracao ponto flutuante
        when "0011" =>
          fadd_x   <= a;
          fadd_y   <= not b(31) & b(30 downto 0);
          int_res  <= float_res & '0';
          done_reg <= '1';

        -- AND logico
        when "0100" =>
          r_logic  <= a and b;
          int_res  <= r_logic & '0';
          done_reg <= '1';

        -- OR logico
        when "0101" =>
          r_logic  <= a or b;
          int_res  <= r_logic & '0';
          done_reg <= '1';

        when others =>
          int_res <= (others => '0');
          done_reg <= '0';


      end case;
    end if;
  end process;

  result <= int_res;
  done   <= done_reg;

end architecture Behavioral;
