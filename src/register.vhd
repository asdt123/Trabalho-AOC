library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;  

entity register_file_VHDL is
port (
 clk, rst          : in std_logic;
 reg_write_en      : in std_logic;
 reg_write_dest    : in std_logic_vector(4 downto 0);
 reg_write_data    : in std_logic_vector(31 downto 0);
 reg_read_addr_1   : in std_logic_vector(4 downto 0);
 reg_read_data_1   : out std_logic_vector(31 downto 0);
 reg_read_addr_2   : in std_logic_vector(4 downto 0);
 reg_read_data_2   : out std_logic_vector(31 downto 0)
);
end register_file_VHDL;

architecture Behavioral of register_file_VHDL is

  type reg_type is array (0 to 31) of std_logic_vector(31 downto 0);
  signal reg_array : reg_type;

begin

  process(clk, rst) 
  begin
    if rst = '1' then
      reg_array(0) <= x"00000000";
      reg_array(1) <= x"00000000";
      reg_array(2) <= x"00000000";
      reg_array(3) <= x"00000000";
      reg_array(4) <= x"00000000";
      reg_array(5) <= x"00000000";
      reg_array(6) <= x"00000000";
      reg_array(7) <= x"00000000";
      reg_array(8) <= x"00000000";
      reg_array(9) <= x"00000000";
      reg_array(10) <= x"00000000";
      reg_array(11) <= x"00000000";
      reg_array(12) <= x"00000000";
      reg_array(13) <= x"00000000";
      reg_array(14) <= x"00000000";
      reg_array(15) <= x"00000000";
      reg_array(16) <= x"00000000";
      reg_array(17) <= x"00000000";
      reg_array(18) <= x"00000000";
      reg_array(19) <= x"00000000";
      reg_array(20) <= x"00000000";
      reg_array(21) <= x"00000000";
      reg_array(22) <= x"00000000";
      reg_array(23) <= x"00000000";
      reg_array(24) <= x"00000000";
      reg_array(25) <= x"00000000";
      reg_array(26) <= x"00000000";
      reg_array(27) <= x"00000000";
      reg_array(28) <= x"00000000";
      reg_array(29) <= x"00000000";
      reg_array(30) <= x"00000000";
      reg_array(31) <= x"00000000";

    elsif rising_edge(clk) then
      if reg_write_en = '1' then
        reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
      end if;
    end if;
  end process;

  reg_read_data_1 <= reg_array(to_integer(unsigned(reg_read_addr_1)));
  reg_read_data_2 <= reg_array(to_integer(unsigned(reg_read_addr_2)));

end Behavioral;
