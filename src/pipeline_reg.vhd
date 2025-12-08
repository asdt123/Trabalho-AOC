library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipeline_reg is
    generic (
        N : integer := 32
    );
    port(
        clk   : in std_logic;
        reset : in std_logic;
        stall : in std_logic;
        flush : in std_logic;
        d_in  : in std_logic_vector(N-1 downto 0);
        d_out : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of pipeline_reg is
    signal reg_int : std_logic_vector(N-1 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset='1' then
            reg_int <= (others => '0');
        elsif rising_edge(clk) then
            if flush='1' then
                reg_int <= (others => '0');
            elsif stall='0' then
                reg_int <= d_in;
            end if;
        end if;
    end process;

    d_out <= reg_int;
end architecture;
