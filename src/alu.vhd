library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
    clk      : in  std_logic;
    op_code  : in  std_logic_vector(3 downto 0);  -- define operação
    a, b     : in  std_logic_vector(31 downto 0);
    result   : out std_logic_vector(31 downto 0);
    done     : out std_logic                    -- 1 quando operação finalizada
  );
end entity alu;

architecture Behavioral of alu is

  ---------------------------------------------------------------------------
  -- Declaração do componente da FloPoCo (ajuste o nome da entidade se for diferente)
  ---------------------------------------------------------------------------
  component myfadd
    port (
      clk : in std_logic;
      X, Y : in std_logic_vector(31 downto 0);
      R : out std_logic_vector(31 downto 0)
    );
  end component;

  ---------------------------------------------------------------------------
  -- Sinais internos
  ---------------------------------------------------------------------------
  signal fp_result : std_logic_vector(31 downto 0);
  signal y_input   : std_logic_vector(31 downto 0);
  signal r_int     : std_logic_vector(31 downto 0);

begin

  ---------------------------------------------------------------------------
  -- Instância da unidade de ponto flutuante
  ---------------------------------------------------------------------------
  fp_add : myfadd
    port map (
      clk => clk,
      X   => a,
      Y   => y_input,
      R   => fp_result
    );

  ---------------------------------------------------------------------------
  -- Processo principal: define a operação da ULA
  ---------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      case op_code is
        ---------------------------------------------------------------------
        -- Operações inteiras
        ---------------------------------------------------------------------
        when "0000" =>  -- ADD (inteiro)
          r_int <= std_logic_vector(signed(a) + signed(b));

        when "0001" =>  -- SUB (inteiro)
          r_int <= std_logic_vector(signed(a) - signed(b));

        when "0010" =>  -- AND
          r_int <= a and b;

        when "0011" =>  -- OR
          r_int <= a or b;

        ---------------------------------------------------------------------
        -- Operações de ponto flutuante
        ---------------------------------------------------------------------
        when "0100" =>  -- FPADD
          y_input <= b;
          r_int   <= fp_result;

        when "0101" =>  -- FPSUB
          y_input <= not(b(31)) & b(30 downto 0);  -- inverte sinal
          r_int   <= fp_result;

        ---------------------------------------------------------------------
        when others =>
          r_int <= (others => '0');
      end case;

      result <= r_int;
      done   <= '1';  -- simplificado: sempre 1 (pode adicionar latência se quiser)
    end if;
  end process;

end architecture Behavioral;
