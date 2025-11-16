library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Instruction_Memory is
    port (
        clk        : in  std_logic;
        pc         : in  std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0)
    );
end Instruction_Memory;

architecture behavioral of Instruction_Memory is

    type memory_type is array(0 to 255) of std_logic_vector(31 downto 0);
    signal mem : memory_type := (others => (others => '0'));

begin

    -- Leitura combinacional baseada no PC
    instruction <= mem(to_integer(unsigned(pc(9 downto 2))));

    ----------------------------------------------------------------
    -- Inicialização da memória a partir do arquivo .input
    ----------------------------------------------------------------
    load_memory: process
        file f : text open read_mode is "tests/instruction.input";
        variable line_v : line;
        variable instr_v : std_logic_vector(31 downto 0);
        variable addr : integer := 0;
    begin
        wait for 30 ns;  -- tempo inicial para simulação
        while not endfile(f) loop
            readline(f, line_v);
            hread(line_v, instr_v);  -- lê instrução em hexadecimal
            mem(addr) <= instr_v;
            addr := addr + 1;
        end loop;
        wait;
    end process;

end behavioral;
