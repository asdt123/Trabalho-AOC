library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;   -- para hread

entity tb_register is
end entity;

architecture behavioral of tb_register is

  ------------------------------------------------------------------------------
  -- Component under test
  ------------------------------------------------------------------------------
  component register_file_VHDL
    port (
      clk            : in  std_logic;
      rst            : in  std_logic;
      reg_write_en   : in  std_logic;
      reg_write_dest : in  std_logic_vector(4 downto 0);
      reg_write_data : in  std_logic_vector(31 downto 0);
      reg_read_addr_1: in  std_logic_vector(4 downto 0);
      reg_read_data_1: out std_logic_vector(31 downto 0);
      reg_read_addr_2: in  std_logic_vector(4 downto 0);
      reg_read_data_2: out std_logic_vector(31 downto 0)
    );
  end component;

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------
  signal clk            : std_logic := '0';
  signal rst            : std_logic := '1';
  signal reg_write_en   : std_logic := '0';
  signal reg_write_dest : std_logic_vector(4 downto 0) := (others => '0');
  signal reg_write_data : std_logic_vector(31 downto 0) := (others => '0');
  signal reg_read_addr_1: std_logic_vector(4 downto 0) := (others => '0');
  signal reg_read_data_1: std_logic_vector(31 downto 0);
  signal reg_read_addr_2: std_logic_vector(4 downto 0) := (others => '0');
  signal reg_read_data_2: std_logic_vector(31 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Clock generation
  ------------------------------------------------------------------------------
  clk <= not clk after 5 ns;

  ------------------------------------------------------------------------------
  -- Instantiate DUT
  ------------------------------------------------------------------------------
  uut: register_file_VHDL
    port map (
      clk             => clk,
      rst             => rst,
      reg_write_en    => reg_write_en,
      reg_write_dest  => reg_write_dest,
      reg_write_data  => reg_write_data,
      reg_read_addr_1 => reg_read_addr_1,
      reg_read_data_1 => reg_read_data_1,
      reg_read_addr_2 => reg_read_addr_2,
      reg_read_data_2 => reg_read_data_2
    );

  ------------------------------------------------------------------------------
  -- Stimulus process
  ------------------------------------------------------------------------------
  stim_proc : process
    file f        : text open read_mode is "tests/register.input";
    variable line_v : line;
    variable cmd_str : string(1 to 5);
    variable dest, addr1, addr2 : integer;
    variable data, expected1, expected2 : std_logic_vector(31 downto 0);
    variable test_count : integer := 0;
    variable error_count: integer := 0;
  begin
    -- Release reset
    wait for 20 ns;
    rst <= '0';

    while not endfile(f) loop
      readline(f, line_v);
      read(line_v, cmd_str);
      
      if cmd_str = "WRITE" then
        read(line_v, dest);
        hread(line_v, data);  -- lê valor hex
        reg_write_dest <= std_logic_vector(to_unsigned(dest,5));
        reg_write_data <= data;
        reg_write_en   <= '1';
        wait for 10 ns;
        reg_write_en   <= '0';
        test_count := test_count + 1;
        
      elsif cmd_str = "READ " then
        read(line_v, addr1);
        read(line_v, addr2);
        hread(line_v, expected1);
        hread(line_v, expected2);

        reg_read_addr_1 <= std_logic_vector(to_unsigned(addr1,5));
        reg_read_addr_2 <= std_logic_vector(to_unsigned(addr2,5));
        wait for 10 ns;

        test_count := test_count + 1;

        if reg_read_data_1 /= expected1 then
          report "ERRO: Test #" & integer'image(test_count) &
                 " addr1=" & integer'image(addr1) &
                 " esperado=" & to_hstring(expected1) &
                 " obtido=" & to_hstring(reg_read_data_1)
                 severity error;
          error_count := error_count + 1;
        else
          report "OK: Test #" & integer'image(test_count) &
                 " addr1=" & integer'image(addr1) &
                 " valor=" & to_hstring(reg_read_data_1)
                 severity note;
        end if;

        if reg_read_data_2 /= expected2 then
          report "ERRO: Test #" & integer'image(test_count) &
                 " addr2=" & integer'image(addr2) &
                 " esperado=" & to_hstring(expected2) &
                 " obtido=" & to_hstring(reg_read_data_2)
                 severity error;
          error_count := error_count + 1;
        else
          report "OK: Test #" & integer'image(test_count) &
                 " addr2=" & integer'image(addr2) &
                 " valor=" & to_hstring(reg_read_data_2)
                 severity note;
        end if;
      end if;

      wait for 10 ns;
    end loop;

    report "Simulação finalizada: " & integer'image(test_count) & " testes, " &
           integer'image(error_count) & " erros." severity note;

    wait;
  end process;

end architecture behavioral;
