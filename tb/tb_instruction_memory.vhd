library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_instruction_memory is
end tb_instruction_memory;

architecture behavioral of tb_instruction_memory is

  --------------------------------------------------------------------------
  -- Component
  --------------------------------------------------------------------------
  component Instruction_Memory
    port (
      clk        : in  std_logic;
      pc         : in  std_logic_vector(31 downto 0);
      instruction: out std_logic_vector(31 downto 0)
    );
  end component;

  --------------------------------------------------------------------------
  -- Signals
  --------------------------------------------------------------------------
  signal clk         : std_logic := '0';
  signal pc          : std_logic_vector(31 downto 0) := (others => '0');
  signal instruction : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;

begin

  --------------------------------------------------------------------------
  -- Clock
  --------------------------------------------------------------------------
  clk <= not clk after clk_period/2;

  --------------------------------------------------------------------------
  -- Instantiate DUT
  --------------------------------------------------------------------------
  uut: Instruction_Memory
    port map (
      clk =>clk,
      pc => pc,
      instruction => instruction
    );

  --------------------------------------------------------------------------
  -- Simulate PC
  --------------------------------------------------------------------------
  pc_proc: process
    variable pc_int : integer := 0;
  begin
    wait for 20 ns;  -- espera inicial

    for i in 0 to 5 loop  -- simula 16 instruções
      pc <= std_logic_vector(to_unsigned(pc_int, 32));
      wait for clk_period;
      report "PC=" & integer'image(pc_int/4) &
             " INSTR=" & to_hstring(instruction);
      pc_int := pc_int + 4;
    end loop;

    wait;
  end process;

end architecture behavioral;
