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

  -- signals
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

  -- Função: slv -> string
  function slv_to_string(slv: std_logic_vector) return string is
    variable s : string(1 to slv'length);
  begin
    for i in slv'range loop
      s(i - slv'low + 1) := character'value(std_logic'image(slv(i)));
    end loop;
    return s;
  end function;

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

    procedure test_opcode(code: std_logic_vector(5 downto 0); name: string) is
    begin
      opcode <= code;
      wait for 10 ns;

      report "=== Testing " & name &
             " | opcode=" & slv_to_string(code) &
             " | reg_dst=" & slv_to_string(reg_dst) &
             " | mem_to_reg=" & slv_to_string(mem_to_reg) &
             " | alu_op=" & slv_to_string(alu_op) &
             " | jump=" & std_logic'image(jump) &
             " | branch=" & std_logic'image(branch) &
             " | mem_read=" & std_logic'image(mem_read) &
             " | mem_write=" & std_logic'image(mem_write) &
             " | alu_src=" & std_logic'image(alu_src) &
             " | reg_write=" & std_logic'image(reg_write) &
             " | sign_or_zero=" & std_logic'image(sign_or_zero);
    end procedure;

  begin

    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    test_opcode("000000", "R-type");
    test_opcode("000001", "sliu");
    test_opcode("000010", "j");
    test_opcode("000011", "jal");
    test_opcode("010011", "lw");
    test_opcode("101011", "sw");
    test_opcode("000100", "beq");
    test_opcode("100000", "addi");
    test_opcode("100001", "addfi");
    test_opcode("100010", "subi");
    test_opcode("100011", "subfi");
    test_opcode("100100", "andi");
    test_opcode("100101", "ori");

    test_opcode("111111", "default");

    wait;
  end process;

end architecture behavioral;
