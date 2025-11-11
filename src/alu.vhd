library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
    clk      : in  std_logic;
    op_code  : in  std_logic_vector(3 downto 0);
    a, b     : in  std_logic_vector(31 downto 0);
    result   : out std_logic_vector(31 downto 0);
    overFlow : out std_logic;
    done     : out std_logic
  );
end entity alu;

architecture Behavioral of alu is

  -- Componentes
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

  -- Sinais internos
  signal int_sum   : std_logic_vector(32 downto 0);
  signal float_res : std_logic_vector(31 downto 0);
  signal int_res   : std_logic_vector(31 downto 0);
  signal r_logic   : std_logic_vector(31 downto 0);
  signal neg_y     : std_logic;
  signal ovf       : std_logic;
  signal done_reg  : std_logic := '0';
  signal fadd_x, fadd_y : std_logic_vector(31 downto 0);

begin

  -- Instancias
  u_intaddsub : IntAddSub_w32_XcY_comb_uid2
    port map (
      X     => a,
      Y     => b,
      negY  => neg_y,
      R     => int_sum
    );

  u_fadd : IEEEFPAdd_8_23_comb_uid2
    port map (
      X => fadd_x,
      Y => fadd_y,
      R => float_res
    );

  -------------------------------------------------------------------------
  -- Lógica combinacional principal
  -------------------------------------------------------------------------
  process(all)
  begin
    -- Valores padrão
    int_res  <= (others => '0');
    neg_y    <= '0';
    ovf      <= '0';
    done_reg <= '0';
    fadd_x   <= (others => '0');
    fadd_y   <= (others => '0');

    case op_code is
      when "0000" =>  -- ADD inteiro
        neg_y    <= '0';
        int_res  <= int_sum(31 downto 0);
        ovf      <= int_sum(32);
        done_reg <= '1';

      when "0001" =>  -- SUB inteiro
        neg_y    <= '1';
        int_res  <= int_sum(31 downto 0);
        ovf      <= int_sum(32);
        done_reg <= '1';

      when "0010" =>  -- ADD float
        fadd_x   <= a;
        fadd_y   <= b;
        int_res  <= float_res;
        done_reg <= '1';

      when "0011" =>  -- SUB float
        fadd_x   <= a;
        fadd_y   <= not b(31) & b(30 downto 0);
        int_res  <= float_res;
        done_reg <= '1';

      when "0100" =>  -- AND lógico
        int_res  <= a and b;
        done_reg <= '1';

      when "0101" =>  -- OR lógico
        int_res  <= a or b;
        done_reg <= '1';

      when others =>
        int_res  <= (others => '0');
        done_reg <= '0';
    end case;
  end process;

  -------------------------------------------------------------------------
  -- Registrando saída (opcional)
  -------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      result   <= int_res;
      overFlow <= ovf;
      done     <= done_reg;
    end if;
  end process;

end architecture Behavioral;
