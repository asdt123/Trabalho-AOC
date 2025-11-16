library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips32 is
    port (
        clk, reset     : in std_logic;
        pc_out         : out std_logic_vector(31 downto 0);
        alu_result     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of mips32 is

    -- PC
    signal pc_current, pc_next, pc_plus4 : std_logic_vector(31 downto 0);

    -- Instruction
    signal instr : std_logic_vector(31 downto 0);

    -- Control signals
    signal reg_dst, mem_to_reg : std_logic_vector(1 downto 0);
    signal alu_op               : std_logic_vector(1 downto 0);
    signal jump, branch, mem_read, mem_write, alu_src, reg_write, sign_or_zero : std_logic;

    -- Register file
    signal reg_write_dest, reg_read_addr_1, reg_read_addr_2 : std_logic_vector(4 downto 0);
    signal reg_write_data, reg_read_data_1, reg_read_data_2 : std_logic_vector(31 downto 0);

    -- Immediate
    signal sign_ext_im, zero_ext_im, imm_ext : std_logic_vector(31 downto 0);

    -- ALU
    signal ALU_Cont : std_logic_vector(2 downto 0);
    signal read_data2, ALU_out : std_logic_vector(31 downto 0);
    signal zero_flag : std_logic;

    -- Branch / Jump
    signal jump_shift_1, PC_beq, PC_4beqj, PC_jr : std_logic_vector(31 downto 0);
    signal beq_control, JRControl : std_logic;

    -- Memory
    signal mem_read_data : std_logic_vector(31 downto 0);

begin

    ----------------------------------------------------------------
    -- PC
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            pc_current <= (others => '0');
        elsif rising_edge(clk) then
            pc_current <= pc_next;
        end if;
    end process;

    pc_plus4 <= std_logic_vector(unsigned(pc_current) + 4);

    ----------------------------------------------------------------
    -- Instruction Memory
    ----------------------------------------------------------------
    imem: entity work.Instruction_Memory
        port map (
            clk => clk,
            pc => pc_current,
            instruction => instr
        );

    ----------------------------------------------------------------
    -- Control Unit
    ----------------------------------------------------------------
    ctrl: entity work.control_unit_VHDL
        port map (
            reset => reset,
            opcode => instr(31 downto 26),
            reg_dst => reg_dst,
            mem_to_reg => mem_to_reg,
            alu_op => alu_op,
            jump => jump,
            branch => branch,
            mem_read => mem_read,
            mem_write => mem_write,
            alu_src => alu_src,
            reg_write => reg_write,
            sign_or_zero => sign_or_zero
        );

    ----------------------------------------------------------------
    -- Register Destination Multiplexer
    ----------------------------------------------------------------
    reg_write_dest <= "11111" when reg_dst="10" else
                      instr(24 downto 20) when reg_dst="01" else
                      instr(19 downto 15);

    reg_read_addr_1 <= instr(28 downto 24);
    reg_read_addr_2 <= instr(23 downto 19);

    ----------------------------------------------------------------
    -- Register File
    ----------------------------------------------------------------
    regfile: entity work.register_file_VHDL
        port map(
            clk => clk,
            rst => reset,
            reg_write_en => reg_write,
            reg_write_dest => reg_write_dest,
            reg_write_data => reg_write_data,
            reg_read_addr_1 => reg_read_addr_1,
            reg_read_data_1 => reg_read_data_1,
            reg_read_addr_2 => reg_read_addr_2,
            reg_read_data_2 => reg_read_data_2
        );

    ----------------------------------------------------------------
    -- Immediate Extenders
    ----------------------------------------------------------------
    sign_ext_im <= (31 downto 16 => instr(15)) & instr(15 downto 0);  -- 16 bits de sinal + 16 bits imediato
    zero_ext_im <= (31 downto 16 => '0') & instr(15 downto 0);         -- 16 bits zeros + 16 bits imediato
    imm_ext <= sign_ext_im when sign_or_zero='1' else zero_ext_im;

    ----------------------------------------------------------------
    -- ALU Control
    ----------------------------------------------------------------
    ALUControl: entity work.ALU_Control
        port map(
            Op => alu_op,
            Funct => instr(2 downto 0),
            ALU_Cont => ALU_Cont
        );

    read_data2 <= imm_ext when alu_src='1' else reg_read_data_2;

    ----------------------------------------------------------------
    -- ALU
    ----------------------------------------------------------------
    alu: entity work.ALU
        port map(
            a => reg_read_data_1,
            b => read_data2,
            alu_cont => ALU_Cont,
            alu_result => ALU_out,
            zero => zero_flag
        );

    ----------------------------------------------------------------
    -- Branch / Jump
    ----------------------------------------------------------------
    jump_shift_1 <= instr(27 downto 0) & x"0";
    PC_beq <= std_logic_vector(unsigned(pc_plus4) + unsigned(imm_ext));
    beq_control <= branch and zero_flag;
    PC_4beqj <= PC_beq when beq_control='1' else pc_plus4;
    PC_jr <= reg_read_data_1;
    pc_next <= PC_jr when JRControl='1' else
           jump_shift_1 when jump='1' else
           PC_4beqj;

    ----------------------------------------------------------------
    -- Data Memory
    ----------------------------------------------------------------
    dmem: entity work.Data_Memory_VHDL
        port map(
            clk => clk,
            mem_access_addr => ALU_out,
            mem_write_data => reg_read_data_2,
            mem_write_en => mem_write,
            mem_read => mem_read,
            mem_read_data => mem_read_data
        );

    ----------------------------------------------------------------
    -- Write Back
    ----------------------------------------------------------------
    reg_write_data <= pc_plus4 when mem_to_reg="10" else
                      mem_read_data when mem_to_reg="01" else
                      ALU_out;

    ----------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------
    pc_out <= pc_current;
    alu_result <= ALU_out;

end Behavioral;
