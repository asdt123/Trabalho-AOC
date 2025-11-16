library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control is
  port(
    Op          : in  std_logic_vector(2 downto 0);
    Funct       : in  std_logic_vector(2 downto 0);
    ALU_Cont    : out std_logic_vector(2 downto 0)
  );
end entity;

architecture Behavioral of ALU_Control is
begin
  process(Op, Funct)
  begin
    case Op is

      -------------------------------------------------------------------
      -- Tipo R → operação definida pelo campo funct
      -------------------------------------------------------------------
      when "000" => 
        ALU_Cont <= Funct(2 downto 0);

      -------------------------------------------------------------------
      -- LW / SW → ADD inteiro (calcular endereço)
      -------------------------------------------------------------------
      when "001" =>
        ALU_Cont <= "000";   -- ADD INT

      -------------------------------------------------------------------
      -- BEQ → SUB inteiro (comparar igualdade)
      -------------------------------------------------------------------
      when "010" =>
        ALU_Cont <= "001";   -- SUB INT

      -------------------------------------------------------------------
      -- Operações imediatas 
      -------------------------------------------------------------------
      when "011" =>
        ALU_Cont <= Funct(2 downto 0);

      -------------------------------------------------------------------
      -- default
      -------------------------------------------------------------------
      when others =>
        ALU_Cont <= "000";   -- ADD inteiro

    end case;
  end process;
end architecture;
