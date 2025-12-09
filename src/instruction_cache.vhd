library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Instruction_Cache is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        pc          : in std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0);
        cpu_stall   : out std_logic -- '1' = Pausa o processador
    );
end entity;

architecture Behavioral of Instruction_Cache is

    -- ========================================================================
    -- CONFIGURAÇÃO DA CACHE (Mapeamento Direto)
    -- ========================================================================
    constant CACHE_LINES : integer := 64; 
    -- PC[31..8] = Tag (24 bits) | PC[7..2] = Index (6 bits) | PC[1..0] = Offset
    
    type tag_array_type is array (0 to CACHE_LINES-1) of std_logic_vector(23 downto 0);
    type valid_array_type is array (0 to CACHE_LINES-1) of std_logic;
    type data_array_type is array (0 to CACHE_LINES-1) of std_logic_vector(31 downto 0);

    signal tags   : tag_array_type := (others => (others => '0'));
    signal valid  : valid_array_type := (others => '0');
    signal cache_data : data_array_type := (others => (others => '0'));

    -- ========================================================================
    -- SIMULAÇÃO DA RAM PRINCIPAL (Lenta e Gigante)
    -- ========================================================================
    type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal main_memory : ram_type := (others => (others => '0'));

    -- Estado da Máquina de Miss
    type state_type is (IDLE, MISS_WAIT);
    signal state : state_type := IDLE;
    signal wait_counter : integer range 0 to 10 := 0;

begin

    -- ========================================================================
    -- 1. CARREGAMENTO DO ARQUIVO (Inicializa a RAM)
    -- ========================================================================
    load_memory: process
        file f : text open read_mode is "tests/instruction.input";
        variable line_v : line;
        variable instr_v : std_logic_vector(31 downto 0);
        variable addr : integer := 0;
    begin
        wait for 1 ns; -- Pequeno delay inicial
        while not endfile(f) loop
            readline(f, line_v);
            hread(line_v, instr_v);
            if addr <= 255 then
                main_memory(addr) <= instr_v;
                addr := addr + 1;
            end if;
        end loop;
        report "CACHE: Memoria Principal carregada com sucesso via arquivo.";
        wait;
    end process;

    -- ========================================================================
    -- 2. LÓGICA DE CONTROLE DA CACHE
    -- ========================================================================
    process(clk, reset)
        variable index : integer;
        variable tag   : std_logic_vector(23 downto 0);
        variable word_addr : integer;
    begin
        if reset = '1' then
            state <= IDLE;
            valid <= (others => '0');
            cpu_stall <= '0';
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            
            -- Proteção contra PC indefinido ('X')
            if is_x(pc) then
                cpu_stall <= '0';
                instruction <= (others => '0');
            else
                -- Decodifica PC
                index := to_integer(unsigned(pc(7 downto 2))); -- Bits para índice
                tag   := pc(31 downto 8);                      -- Bits para Tag
                word_addr := to_integer(unsigned(pc(31 downto 2))); -- Endereço linear

                case state is
                    when IDLE =>
                        -- Verifica HIT: Valid=1 e Tag bate
                        if valid(index) = '1' and tags(index) = tag then
                            -- HIT!
                            instruction <= cache_data(index);
                            cpu_stall <= '0'; 
                        else
                            -- MISS!
                            cpu_stall <= '1'; -- Pausa o pipeline
                            wait_counter <= 4; -- Penalidade de 4 ciclos
                            state <= MISS_WAIT;
                        end if;

                    when MISS_WAIT =>
                        cpu_stall <= '1'; -- Mantém pausado
                        if wait_counter > 0 then
                            wait_counter <= wait_counter - 1;
                        else
                            -- Fim da espera: Busca da RAM e salva na Cache
                            if word_addr <= 255 then
                                cache_data(index) <= main_memory(word_addr);
                                tags(index) <= tag;
                                valid(index) <= '1';
                            else
                                cache_data(index) <= (others => '0'); -- Fora da RAM
                            end if;
                            state <= IDLE; -- Volta para tentar ler de novo (agora vai dar Hit)
                        end if;
                end case;
            end if;
        end if;
    end process;

end Behavioral;