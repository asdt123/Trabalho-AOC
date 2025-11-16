library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;

entity alu is
  port (
    alu_cont     : in  std_logic_vector(5 downto 0);
    a, b         : in  std_logic_vector(31 downto 0);
    alu_result   : out std_logic_vector(31 downto 0);
    zero         : out std_logic
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

 -- Sinais internos
  signal int_res   : std_logic_vector(32 downto 0);
  signal float_res : std_logic_vector(31 downto 0);
  signal result    : std_logic_vector(31 downto 0);
  signal fadd_x    : std_logic_vector(31 downto 0);
  signal fadd_y    : std_logic_vector(31 downto 0);

begin

  u_fadd : IEEEFPAdd_8_23_comb_uid2
    port map (
      X => fadd_x,
      Y => fadd_y,
      R => float_res
    );

  -------------------------------------------------------------------------
  -- Lógica combinacional principal
  -------------------------------------------------------------------------
  process(alu_cont,a,b,float_res)
  begin
    -- valores default (evita latch)
    fadd_x <= (others => '0');
    fadd_y <= (others => '0');
    result <= (others => '0');

    case alu_cont is
      when "100000" =>  -- ADD inteiro
        result <= std_logic_vector(signed(a) + signed(b));

      when "100010" =>  -- SUB inteiro
        result <= std_logic_vector(signed(a) - signed(b));

      when "100001" =>  -- ADD float
        fadd_x   <= a;
        fadd_y   <= b;
        result  <= float_res;

      when "100011" =>  -- SUB float
        fadd_x   <= a;
        fadd_y   <= not b(31) & b(30 downto 0);
        result  <= float_res;

      when "100100" =>  -- AND lógico
        result  <= a and b;

      when "100101" =>  -- OR lógico
        result  <= a or b;

      when others => -- ADD int
        result   <= a + b;
        
    end case;
  end process;
  zero <= '1' when result=x"00000000" else '0';
  alu_result <= result;
end architecture Behavioral;
