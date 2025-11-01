library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
    clk      : in  std_logic;
    op_code  : in  std_logic_vector(3 downto 0);  -- define operação
    a, b     : in  std_logic_vector(31 downto 0);
    result   : out std_logic_vector(31 downto 0);
    done     : out std_logic
  );
end entity alu;

architecture Behavioral of alu is

  ---------------------------------------------------------------------------
  component IEEEFPAdd_8_23_comb_uid2
    port (
      X, Y : in std_logic_vector(31 downto 0);
      R : out std_logic_vector(31 downto 0)
    );
  end component;

  ---------------------------------------------------------------------------
  signal r_int      : std_logic_vector(31 downto 0);
  signal fp_result  : std_logic_vector(31 downto 0);
  signal y_input    : std_logic_vector(31 downto 0);
  signal start_op   : std_logic := '0';
  signal done_shift : std_logic_vector(7 downto 0) := (others => '0'); -- 8 ciclos latência max
  signal op_latency : integer := 0;

begin

  ---------------------------------------------------------------------------
  -- Instância FP adder
  ---------------------------------------------------------------------------
  fp_add : IEEEFPAdd_8_23_comb_uid2
    port map (
      X   => a,
      Y   => y_input,
      R   => fp_result
    );

  ---------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then

      -- detectar início da operação
      if start_op = '0' then
        start_op <= '1';

        -- operações imediatas (inteiro ou FP)
        case op_code is
          when "0000" => r_int <= std_logic_vector(signed(a)+signed(b));  -- ADD
          when "0001" => r_int <= std_logic_vector(signed(a)-signed(b));  -- SUB
          when "0010" => r_int <= a and b;                                  -- AND
          when "0011" => r_int <= a or b;                                   -- OR
          when "0100" => y_input <= b;                                      -- FPADD
          when "0101" => y_input <= not(b(31)) & b(30 downto 0);           -- FPSUB
          when others => r_int <= (others=>'0');
        end case;

        -- inicializa shift register
        done_shift <= (others=>'0');

      else
        -- operação em andamento: shift register sempre 8 bits
        done_shift <= done_shift(6 downto 0) & '1';

        -- captura resultado de FP quando o shift finaliza
        if op_code = "0100" or op_code = "0101" then
          r_int <= fp_result;
        end if;

      end if;

      -- define done final com índice fixo
      case op_code is
        when "0000" | "0001" | "0010" | "0011" => done <= done_shift(0);  -- 2 ciclos
        when "0100" | "0101" => done <= done_shift(7);                    -- 8 ciclos
        when others => done <= '0';
      end case;

      -- resetar start_op quando done
      if ((op_code = "0000" or op_code = "0001" or op_code = "0010" or op_code = "0011") and done_shift(0)='1') or
        ((op_code = "0100" or op_code = "0101") and done_shift(7)='1') then
        start_op <= '0';
        done_shift <= (others=>'0');
      end if;

      -- resultado final
      result <= r_int;

    end if;
  end process;

end architecture Behavioral;
