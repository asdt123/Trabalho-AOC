library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;   -- <-- IMPORTANTE para hread

entity tb_memory is
end tb_memory;

architecture behavioral of tb_memory is

    component Data_Memory_VHDL 
    port (
        clk: in std_logic;
        mem_access_addr: in std_logic_vector(31 downto 0);
        mem_write_data: in std_logic_vector(31 downto 0);
        mem_write_en,mem_read: in std_logic;
        mem_read_data: out std_logic_vector(31 downto 0)
    );
    end component;

    signal clk              : std_logic := '0';
    signal mem_access_addr : std_logic_vector(31 downto 0);
    signal mem_write_data  : std_logic_vector(31 downto 0);
    signal mem_write_en    : std_logic;
    signal mem_read        : std_logic;
    signal mem_read_data   : std_logic_vector(31 downto 0);

begin

    clk <= not clk after 5 ns;

    uut: Data_Memory_VHDL 
        port map(
            clk => clk,
            mem_access_addr => mem_access_addr,
            mem_write_data => mem_write_data,
            mem_write_en => mem_write_en,
            mem_read => mem_read,
            mem_read_data => mem_read_data
        );

    
    ------------------------------------------------------
    -- PROCESSO DE LEITURA DO ARQUIVO HEX
    ------------------------------------------------------
    P1: process
        file f         : text open read_mode is "tests/memory.input";
        variable line_v: line;
        variable addr_v: std_logic_vector(31 downto 0);
        variable data_v: std_logic_vector(31 downto 0);
    begin
        --------------------------------------------------
        -- FASE DE LEITURA INICIAL
        --------------------------------------------------
        report "MEMORIA INICIAL";
        mem_read <= '1';
        for i in 0 to 5 loop
            mem_access_addr <= std_logic_vector(to_unsigned(i*4, 32));
            wait for 10 ns;
            report "ADDR=" & to_hstring(mem_access_addr) &
                    " DATA=" & to_hstring(mem_read_data);

        end loop;


        mem_write_en <= '0';
        mem_read <= '0';
        wait for 20 ns;
        report "ESCRITA NA MEMORIA";

        -- pular header se existir
        if not endfile(f) then
        readline(f, line_v);
        end if;

        while not endfile(f) loop
            readline(f, line_v);

            -- LÊ ENDEREÇO EM HEX
            hread(line_v, addr_v);

            -- LÊ DADO EM HEX
            hread(line_v, data_v);
            
            mem_access_addr <= addr_v;
            mem_write_data <= data_v;

            mem_write_en <= '1';
            wait for 10 ns;
            mem_write_en <= '0';
            wait for 10 ns;
        end loop;

        --------------------------------------------------
        -- FASE DE LEITURA
        --------------------------------------------------
        mem_read <= '1';
        report "MEMORIA FINAL";
        
        for i in 0 to 5 loop
            mem_access_addr <= std_logic_vector(to_unsigned(i*4, 32));
            wait for 10 ns;
            report "ADDR=" & to_hstring(mem_access_addr) &
                    " DATA=" & to_hstring(mem_read_data);

        end loop;

        wait;
    end process;

end behavioral;
