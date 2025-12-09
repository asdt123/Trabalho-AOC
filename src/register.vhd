library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_VHDL is
    port (
        clk, rst : in std_logic;
        reg_write_en : in std_logic;
        reg_write_dest : in std_logic_vector(4 downto 0);
        reg_write_data : in std_logic_vector(31 downto 0);
        reg_read_addr_1 : in std_logic_vector(4 downto 0);
        reg_read_data_1 : out std_logic_vector(31 downto 0);
        reg_read_addr_2 : in std_logic_vector(4 downto 0);
        reg_read_data_2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of register_file_VHDL is
    type reg_type is array (0 to 31) of std_logic_vector(31 downto 0);
    signal reg_array : reg_type := (others => (others => '0'));
begin
    -- Processo de Escrita (Síncrono com Clock)
    process(clk, rst)
    begin
        if rst = '1' then
            reg_array <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if reg_write_en = '1' then
                if to_integer(unsigned(reg_write_dest)) /= 0 then -- Não escreve no $0
                    reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
                end if;
            end if;
        end if;
    end process;

    -- Processo de Leitura (Assíncrono com "Internal Forwarding")
    -- Se o endereço de leitura for igual ao de escrita ATUAL, já repassa o dado direto!
    process(all) 
    begin
        -- Leitura Porta 1
        if (reg_read_addr_1 = "00000") then
            reg_read_data_1 <= (others => '0');
        elsif (reg_write_en = '1' and reg_write_dest = reg_read_addr_1) then
            reg_read_data_1 <= reg_write_data; -- BYPASS: Entrega o dado que está sendo escrito agora
        else
            reg_read_data_1 <= reg_array(to_integer(unsigned(reg_read_addr_1)));
        end if;

        -- Leitura Porta 2
        if (reg_read_addr_2 = "00000") then
            reg_read_data_2 <= (others => '0');
        elsif (reg_write_en = '1' and reg_write_dest = reg_read_addr_2) then
            reg_read_data_2 <= reg_write_data; -- BYPASS
        else
            reg_read_data_2 <= reg_array(to_integer(unsigned(reg_read_addr_2)));
        end if;
    end process;

end Behavioral;