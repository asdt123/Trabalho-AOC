library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Cache is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        pc          : in std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0);
        cpu_stall   : out std_logic -- Sinal para pausar o processador no Miss
    );
end entity;

architecture Behavioral of Instruction_Cache is

    -- Configuração da Cache: 64 Linhas (Blocks)
    constant CACHE_LINES : integer := 64;
    
    -- Tipos para guardar Tag e Valid Bit
    type tag_array_type is array (0 to CACHE_LINES-1) of std_logic_vector(23 downto 0); -- Tag restante
    type valid_array_type is array (0 to CACHE_LINES-1) of std_logic;
    type data_array_type is array (0 to CACHE_LINES-1) of std_logic_vector(31 downto 0);

    signal tags   : tag_array_type;
    signal valid  : valid_array_type := (others => '0');
    signal data   : data_array_type;

    -- Simulação da Memória Principal (Lenta)
    type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);
    constant MAIN_MEMORY : ram_type := (
        0 => x"2001000F", -- addi $1, $0, 15
        1 => x"20020003", -- addi $2, $0, 3
        2 => x"00221820", -- add  $3, $1, $2
        3 => x"00221822", -- sub  $3, $1, $2
        others => x"00000000"
    );

    -- Máquina de Estados para controlar o Miss Penalty
    type state_type is (IDLE, MISS_WAIT);
    signal state : state_type := IDLE;
    signal wait_counter : integer range 0 to 10 := 0;

begin

    process(clk, reset, pc)
        -- Decodificando o endereço (Mapeamento Direto)
        -- Endereço: [TAG (24 bits)] [INDEX (6 bits)] [OFFSET (2 bits - ignorados)]
        variable index : integer;
        variable tag   : std_logic_vector(23 downto 0);
        variable word_addr : integer;
    begin
        -- Converte PC para índice
        -- "pc(7 downto 2)" pega 6 bits ignorando os 2 últimos (byte alignment)
        index := to_integer(unsigned(pc(7 downto 2))); 
        tag   := pc(31 downto 8);
        word_addr := to_integer(unsigned(pc(31 downto 2)));

        if reset = '1' then
            state <= IDLE;
            valid <= (others => '0');
            cpu_stall <= '0';
            wait_counter <= 0;
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    -- Verifica se é HIT (Valid=1 e Tag bate)
                    if valid(index) = '1' and tags(index) = tag then
                        -- CACHE HIT!
                        instruction <= data(index);
                        cpu_stall <= '0';
                    else
                        -- CACHE MISS!
                        cpu_stall <= '1'; -- Pausa o processador
                        wait_counter <= 5; -- Penalidade de 5 ciclos (exemplo)
                        state <= MISS_WAIT;
                    end if;

                when MISS_WAIT =>
                    cpu_stall <= '1'; -- Mantém pausado
                    if wait_counter > 0 then
                        wait_counter <= wait_counter - 1;
                    else
                        -- Fim da espera, busca da RAM principal
                        if word_addr < 256 then
                             data(index) <= MAIN_MEMORY(word_addr);
                             tags(index) <= tag;
                             valid(index) <= '1';
                        else
                             data(index) <= (others => '0'); -- Fora da memória
                        end if;
                        state <= IDLE; -- Volta para tentar ler de novo (agora vai dar Hit)
                    end if;
            end case;
        end if;
    end process;

end Behavioral;