library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_control_unit is
end entity;

architecture behavioral of tb_control_unit is

  component control_unit_VHDL
    port (
      opcode        : in  std_logic_vector(5 downto 0);
      reset         : in  std_logic;
      reg_dst       : out std_logic_vector(1 downto 0);
      mem_to_reg    : out std_logic_vector(1 downto 0);
      alu_op        : out std_logic_vector(1 downto 0);
      jump          : out std_logic;
      branch        : out std_logic;
      mem_read      : out std_logic;
      mem_write     : out std_logic;
      alu_src       : out std_logic;
      reg_write     : out std_logic;
      sign_or_zero  : out std_logic
    );
  end component;

  signal opcode        : std_logic_vector(5 downto 0) := (others => '0');
  signal reset         : std_logic := '1';
  signal reg_dst       : std_logic_vector(1 downto 0);
  signal mem_to_reg    : std_logic_vector(1 downto 0);
  signal alu_op        : std_logic_vector(1 downto 0);
  signal jump          : std_logic;
  signal branch        : std_logic;
  signal mem_read      : std_logic;
  signal mem_write     : std_logic;
  signal alu_src       : std_logic;
  signal reg_write     : std_logic;
  signal sign_or_zero  : std_logic;

begin

  uut: control_unit_VHDL
    port map(
      opcode       => opcode,
      reset        => reset,
      reg_dst      => reg_dst,
      mem_to_reg   => mem_to_reg,
      alu_op       => alu_op,
      jump         => jump,
      branch       => branch,
      mem_read     => mem_read,
      mem_write    => mem_write,
      alu_src      => alu_src,
      reg_write    => reg_write,
      sign_or_zero => sign_or_zero
    );

  stim_proc: process
    variable idx : integer;
    function slv2string(slv: std_logic_vector) return string is
      variable result : string(1 to slv'length);
    begin
      for i in slv'range loop
        result(i - slv'low + 1) := character'VALUE(std_logic'image(slv(i)));
      end loop;
      return result;
    end function;
  begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    for idx in 0 to 7 loop
      opcode <= std_logic_vector(to_unsigned(idx, 6));
      wait for 10 ns;

      report "Opcode=" & integer'image(idx) &
             " | reg_dst=" & slv2string(reg_dst) &
             " mem_to_reg=" & slv2string(mem_to_reg) &
             " alu_op=" & slv2string(alu_op) &
             " jump=" & std_logic'image(jump) &
             " branch=" & std_logic'image(branch) &
             " mem_read=" & std_logic'image(mem_read) &
             " mem_write=" & std_logic'image(mem_write) &
             " alu_src=" & std_logic'image(alu_src) &
             " reg_write=" & std_logic'image(reg_write) &
             " sign_or_zero=" & std_logic'image(sign_or_zero);
    end loop;

    wait;
  end process;

end architecture behavioral;
