library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control is
  port(
    Op          : in  std_logic_vector(1 downto 0);
    Funct       : in  std_logic_vector(5 downto 0);
    ALU_Cont    : out std_logic_vector(5 downto 0)
  );
end entity;

architecture Behavioral of ALU_Control is
  signal result : std_logic_vector(5 downto 0);
begin
  process(Op, Funct)
  begin
    case Op is

      -------------------------------------------------------------------
      -- Tipo R → operação definida pelo campo funct
      -------------------------------------------------------------------
      when "00" => 
        result <= Funct(5 downto 0);

      -------------------------------------------------------------------
      -- LW / SW → ADD inteiro (calcular endereço)
      -------------------------------------------------------------------
      when "01" =>
        result <= "100000";   -- ADD INT

      -------------------------------------------------------------------
      -- BEQ → SUB inteiro (comparar igualdade)
      -------------------------------------------------------------------
      when "10" =>
        result <= "100010";   -- SUB INT

      -------------------------------------------------------------------
      -- Operações imediatas 
      -------------------------------------------------------------------
      when "11" =>
        result <= Funct(5 downto 0);

      -------------------------------------------------------------------
      -- default
      -------------------------------------------------------------------
      when others =>
        result <= "100000";   -- ADD inteiro

    end case;
  end process;
  ALU_Cont <= result;
end architecture;
