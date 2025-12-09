library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Instruction_Memory is
    port (
        clk         : in  std_logic;
        pc          : in  std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
end Instruction_Memory;

architecture behavioral of Instruction_Memory is

    -- Memória de 256 posições (ajuste se precisar de mais)
    type memory_type is array(0 to 255) of std_logic_vector(31 downto 0);
    signal mem : memory_type := (others => (others => '0'));

begin

    -- =================================================================
    -- LEITURA COMBINACIONAL (COM PROTEÇÃO CONTRA 'X' E LIMITES)
    -- =================================================================
    process(pc, mem)
        variable index : integer;
    begin
        -- 1. Se PC for indefinido (X, U, Z), entrega NOP (Zero) para não travar
        if is_x(pc) then
            instruction <= (others => '0');
        
        else
            -- 2. Converte PC para índice (PC / 4)
            index := to_integer(unsigned(pc(31 downto 2)));
            
            -- 3. Verifica se o índice está dentro da memória (0 a 255)
            if index >= 0 and index <= 255 then
                instruction <= mem(index);
            else
                instruction <= (others => '0'); -- Fora do mapa de memória = NOP
            end if;
        end if;
    end process;

    -- =================================================================
    -- INICIALIZAÇÃO (CARREGA ARQUIVO .INPUT)
    -- =================================================================
    load_memory: process
        file f : text open read_mode is "tests/instruction.input"; -- VERIFIQUE O CAMINHO AQUI
        variable line_v : line;
        variable instr_v : std_logic_vector(31 downto 0);
        variable addr : integer := 0;
    begin
        -- Aguarda um delta para garantir que a simulação começou
        wait for 1 ns; 
        
        while not endfile(f) loop
            readline(f, line_v);
            hread(line_v, instr_v);
            
            if addr <= 255 then
                mem(addr) <= instr_v;
                addr := addr + 1;
            end if;
        end loop;
        
        report "Memoria de Instrucoes carregada com sucesso! Total: " & integer'image(addr) & " linhas.";
        wait;
    end process;

end behavioral;