-- fpga4student.com: FPGA projects, Verilog projects, VHDL projects
-- VHDL project: VHDL code for single-cycle MIPS Processor
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- VHDL code for Control Unit of the MIPS Processor
entity control_unit_VHDL is
port (
  opcode: in std_logic_vector(5 downto 0);
  reset: in std_logic;
  reg_dst,mem_to_reg,alu_op,sign_or_zero: out std_logic_vector(1 downto 0);
  jump,branch,mem_read,mem_write,alu_src,reg_write: out std_logic
 );
end control_unit_VHDL;

architecture Behavioral of control_unit_VHDL is

begin
process(reset,opcode)
begin
 if(reset = '1') then
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "00";
   jump <= '0';
   branch <= '0';
   mem_read <= '0';
   mem_write <= '0';
   alu_src <= '0';
   reg_write <= '0';
   sign_or_zero <= "01";
 else 
  case opcode is
    when "000000" => -- R
      reg_dst <= "01";
      mem_to_reg <= "00";
      alu_op <= "00";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '0';
      reg_write <= '1';
      sign_or_zero <= "01";
    when "100000" =>-- addi
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "11";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '1';
      reg_write <= '1';
      sign_or_zero <= "01";
    when "100001" =>-- addfi
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "11";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '1';
      reg_write <= '1';
      sign_or_zero <= "10";
    when "100010" =>-- subi
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "11";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '1';
      reg_write <= '1';
      sign_or_zero <= "01";
    when "100011" =>-- subfi
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "11";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '1';
      reg_write <= '1';
      sign_or_zero <= "10";
    when "100100" =>-- andi
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "11";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '1';
      reg_write <= '1';
      sign_or_zero <= "01";
    when "100101" =>-- ori
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "11";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '1';
      reg_write <= '1';
      sign_or_zero <= "01";
    when others =>   
      reg_dst <= "01";
      mem_to_reg <= "00";
      alu_op <= "00";
      jump <= '0';
      branch <= '0';
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '0';
      reg_write <= '1';
      sign_or_zero <= "01";
  end case;
 end if;
end process;

end Behavioral;