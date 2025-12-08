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

    ----------------------------------------------------------------
    -- PC (IF stage)
    ----------------------------------------------------------------
    signal pc_current, pc_next, pc_plus4 : std_logic_vector(31 downto 0);

    ----------------------------------------------------------------
    -- IF/ID pipeline registers
    ----------------------------------------------------------------
    signal IFID_instr    : std_logic_vector(31 downto 0);
    signal IFID_pc_plus4 : std_logic_vector(31 downto 0);

    ----------------------------------------------------------------
    -- ID stage signals
    ----------------------------------------------------------------
    -- control signals (from control_unit, valid in ID)
    signal reg_dst_ID, mem_to_reg_ID : std_logic_vector(1 downto 0);
    signal alu_op_ID, sign_or_zero_ID: std_logic_vector(1 downto 0);
    signal jump_ID, branch_ID, mem_read_ID, mem_write_ID, alu_src_ID, reg_write_ID : std_logic;

    -- register file read addresses and outputs (read in ID)
    signal reg_read_addr_1_ID, reg_read_addr_2_ID : std_logic_vector(4 downto 0);
    signal reg_read_data_1_ID, reg_read_data_2_ID : std_logic_vector(31 downto 0);

    -- immediate ext in ID
    signal sign_ext_im_ID, zero_ext_im_ID, float_ext_im_ID, imm_ext_ID : std_logic_vector(31 downto 0);

    -- funct field in ID (for R-type)
    signal funct_ID : std_logic_vector(5 downto 0);

    ----------------------------------------------------------------
    -- ID/EX pipeline registers (transfer ID -> EX)
    ----------------------------------------------------------------
    signal IDEX_reg_dst, IDEX_mem_to_reg : std_logic_vector(1 downto 0);
    signal IDEX_alu_op, IDEX_sign_or_zero : std_logic_vector(1 downto 0);
    signal IDEX_jump, IDEX_branch, IDEX_mem_read, IDEX_mem_write, IDEX_alu_src, IDEX_reg_write : std_logic;

    signal IDEX_reg_data1, IDEX_reg_data2 : std_logic_vector(31 downto 0);
    signal IDEX_imm : std_logic_vector(31 downto 0);
    signal IDEX_rs, IDEX_rt, IDEX_rd : std_logic_vector(4 downto 0);
    signal IDEX_pc_plus4 : std_logic_vector(31 downto 0);
    signal IDEX_funct : std_logic_vector(5 downto 0);
    signal IDEX_instr : std_logic_vector(31 downto 0);  -- ADICIONADO: guarda instrução completa para J

    ----------------------------------------------------------------
    -- EX stage signals
    ----------------------------------------------------------------
    signal ALU_Cont_EX : std_logic_vector(5 downto 0);
    signal read_data2_EX, ALU_out_EX : std_logic_vector(31 downto 0);
    signal zero_flag_EX : std_logic;
    signal jump_shift_1_EX, PC_beq_EX, PC_4beqj_EX, PC_jr_EX : std_logic_vector(31 downto 0);
    signal beq_control_EX, JRControl_EX : std_logic;
    signal instr : std_logic_vector(31 downto 0);

    ----------------------------------------------------------------
    -- EX/MEM pipeline registers
    ----------------------------------------------------------------
    signal EXMEM_mem_to_reg : std_logic_vector(1 downto 0);
    signal EXMEM_mem_read, EXMEM_mem_write, EXMEM_reg_write : std_logic;
    signal EXMEM_alu_out : std_logic_vector(31 downto 0);
    signal EXMEM_write_data : std_logic_vector(31 downto 0);
    signal EXMEM_rd : std_logic_vector(4 downto 0);
    signal EXMEM_pc_plus4 : std_logic_vector(31 downto 0);

    ----------------------------------------------------------------
    -- MEM stage signals
    ----------------------------------------------------------------
    signal mem_read_data : std_logic_vector(31 downto 0);

    ----------------------------------------------------------------
    -- MEM/WB pipeline registers
    ----------------------------------------------------------------
    signal MEMWB_mem_to_reg : std_logic_vector(1 downto 0);
    signal MEMWB_reg_write : std_logic;
    signal MEMWB_mem_read_data, MEMWB_alu_out : std_logic_vector(31 downto 0);
    signal MEMWB_rd : std_logic_vector(4 downto 0);
    signal MEMWB_pc_plus4 : std_logic_vector(31 downto 0);

    ----------------------------------------------------------------
    -- WB stage signals
    ----------------------------------------------------------------
    signal reg_write_data_WB : std_logic_vector(31 downto 0);

begin

    ----------------------------------------------------------------
    -- PC register (IF)
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
    -- Instruction Memory (IF)
    ----------------------------------------------------------------
    imem: entity work.Instruction_Memory
        port map (
            clk => clk,
            pc => pc_current,
            instruction => instr  -- note: instr is transient, captured into IF/ID below
        );

    ----------------------------------------------------------------
    -- IF/ID pipeline register
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            IFID_instr    <= (others => '0');
            IFID_pc_plus4 <= (others => '0');
        elsif rising_edge(clk) then
            IFID_instr    <= instr;
            IFID_pc_plus4 <= pc_plus4;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Control Unit (ID stage) : use opcode from IF/ID
    ----------------------------------------------------------------
    ctrl: entity work.control_unit_VHDL
        port map (
            reset => reset,
            opcode => IFID_instr(31 downto 26),
            reg_dst => reg_dst_ID,
            mem_to_reg => mem_to_reg_ID,
            alu_op => alu_op_ID,
            jump => jump_ID,
            branch => branch_ID,
            mem_read => mem_read_ID,
            mem_write => mem_write_ID,
            alu_src => alu_src_ID,
            reg_write => reg_write_ID,
            sign_or_zero => sign_or_zero_ID
        );

    ----------------------------------------------------------------
    -- Register read addresses (ID) from IF/ID instr
    ----------------------------------------------------------------
    reg_read_addr_1_ID <= IFID_instr(25 downto 21);
    reg_read_addr_2_ID <= IFID_instr(20 downto 16);

    ----------------------------------------------------------------
    -- Register File: reads happen in ID; writes happen in WB (MEM/WB)
    -- Note: regfile assumed to provide combinational read outputs when addresses change
    ----------------------------------------------------------------
    regfile: entity work.register_file_VHDL
        port map(
            clk => clk,
            rst => reset,
            reg_write_en => MEMWB_reg_write,         -- write enable comes from WB stage
            reg_write_dest => MEMWB_rd,              -- write destination from WB
            reg_write_data => reg_write_data_WB,     -- data to write from WB mux
            reg_read_addr_1 => reg_read_addr_1_ID,
            reg_read_data_1 => reg_read_data_1_ID,
            reg_read_addr_2 => reg_read_addr_2_ID,
            reg_read_data_2 => reg_read_data_2_ID
        );

    ----------------------------------------------------------------
    -- Immediate extenders (ID)
    ----------------------------------------------------------------
    sign_ext_im_ID <= (31 downto 16 => IFID_instr(15)) & IFID_instr(15 downto 0);
    zero_ext_im_ID <= (31 downto 16 => '0') & IFID_instr(15 downto 0);
    float_ext_im_ID<= IFID_instr(15 downto 0) & x"0000";
    imm_ext_ID <= sign_ext_im_ID when sign_or_zero_ID="01" else
                  float_ext_im_ID when sign_or_zero_ID="10" else
                  zero_ext_im_ID;

    ----------------------------------------------------------------
    -- Funct (ID)
    ----------------------------------------------------------------
    funct_ID <= IFID_instr(5 downto 0) when reg_dst_ID="01" else
                IFID_instr(31 downto 26);

    ----------------------------------------------------------------
    -- ID/EX pipeline registers (capture control + operands + fields)
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            IDEX_reg_dst       <= (others => '0');
            IDEX_mem_to_reg    <= (others => '0');
            IDEX_alu_op        <= (others => '0');
            IDEX_jump          <= '0';
            IDEX_branch        <= '0';
            IDEX_mem_read      <= '0';
            IDEX_mem_write     <= '0';
            IDEX_alu_src       <= '0';
            IDEX_reg_write     <= '0';
            IDEX_reg_data1     <= (others => '0');
            IDEX_reg_data2     <= (others => '0');
            IDEX_imm           <= (others => '0');
            IDEX_rs            <= (others => '0');
            IDEX_rt            <= (others => '0');
            IDEX_rd            <= (others => '0');
            IDEX_pc_plus4      <= (others => '0');
            IDEX_funct         <= (others => '0');
            IDEX_sign_or_zero  <= (others => '0');
            IDEX_instr         <= (others => '0');
        elsif rising_edge(clk) then
            IDEX_reg_dst       <= reg_dst_ID;
            IDEX_mem_to_reg    <= mem_to_reg_ID;
            IDEX_alu_op        <= alu_op_ID;
            IDEX_jump          <= jump_ID;
            IDEX_branch        <= branch_ID;
            IDEX_mem_read      <= mem_read_ID;
            IDEX_mem_write     <= mem_write_ID;
            IDEX_alu_src       <= alu_src_ID;
            IDEX_reg_write     <= reg_write_ID;

            IDEX_reg_data1     <= reg_read_data_1_ID;
            IDEX_reg_data2     <= reg_read_data_2_ID;
            IDEX_imm           <= imm_ext_ID;
            IDEX_rs            <= IFID_instr(25 downto 21);
            IDEX_rt            <= IFID_instr(20 downto 16);
            IDEX_rd            <= IFID_instr(15 downto 11);
            IDEX_pc_plus4      <= IFID_pc_plus4;
            IDEX_funct         <= funct_ID;
            IDEX_sign_or_zero  <= sign_or_zero_ID;
            IDEX_instr         <= IFID_instr;  -- guarda instrução inteira para J-type
        end if;
    end process;

    ----------------------------------------------------------------
    -- ALU Control (EX): using IDEX_alu_op and IDEX_funct
    ----------------------------------------------------------------
    ALUControl_EX: entity work.ALU_Control
        port map(
            Op => IDEX_alu_op,
            Funct => IDEX_funct,
            ALU_Cont => ALU_Cont_EX
        );

    ----------------------------------------------------------------
    -- ALU input MUX in EX
    ----------------------------------------------------------------
    read_data2_EX <= IDEX_imm when IDEX_alu_src='1' else IDEX_reg_data2;

    ----------------------------------------------------------------
    -- ALU (EX stage)
    ----------------------------------------------------------------
    alu_EX: entity work.ALU
        port map(
            a => IDEX_reg_data1,
            b => read_data2_EX,
            alu_cont => ALU_Cont_EX,
            alu_result => ALU_out_EX,
            zero => zero_flag_EX
        );

    ----------------------------------------------------------------
    -- Branch / Jump calculation in EX (use IDEX values)
    -- NOW using IDEX_instr for J-type target (safe)
    ----------------------------------------------------------------
    jump_shift_1_EX <= IDEX_pc_plus4(31 downto 28) & IDEX_instr(25 downto 0) & "00";
    PC_beq_EX <= std_logic_vector(unsigned(IDEX_pc_plus4) + unsigned(IDEX_imm));
    beq_control_EX <= IDEX_branch and zero_flag_EX;
    PC_4beqj_EX <= PC_beq_EX when beq_control_EX='1' else IDEX_pc_plus4;
    PC_jr_EX <= IDEX_reg_data1;
    -- Note: we'll compute pc_next below using EX outputs

    ----------------------------------------------------------------
    -- EX/MEM pipeline registers
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            EXMEM_mem_to_reg <= (others => '0');
            EXMEM_mem_read <= '0';
            EXMEM_mem_write <= '0';
            EXMEM_reg_write <= '0';
            EXMEM_alu_out <= (others => '0');
            EXMEM_write_data <= (others => '0');
            EXMEM_rd <= (others => '0');
            EXMEM_pc_plus4 <= (others => '0');
        elsif rising_edge(clk) then
            EXMEM_mem_to_reg <= IDEX_mem_to_reg;
            EXMEM_mem_read <= IDEX_mem_read;
            EXMEM_mem_write <= IDEX_mem_write;
            EXMEM_reg_write <= IDEX_reg_write;
            EXMEM_alu_out <= ALU_out_EX;
            EXMEM_write_data <= IDEX_reg_data2;
            -- choose destination register according to reg_dst (from ID)
            EXMEM_rd <= "11111" when IDEX_reg_dst="10" else
                        IDEX_rd when IDEX_reg_dst="01" else
                        IDEX_rs;

            EXMEM_pc_plus4 <= IDEX_pc_plus4;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Data Memory (MEM stage)
    ----------------------------------------------------------------
    dmem: entity work.Data_Memory_VHDL
        port map(
            clk => clk,
            mem_access_addr => EXMEM_alu_out,
            mem_write_data => EXMEM_write_data,
            mem_write_en => EXMEM_mem_write,
            mem_read => EXMEM_mem_read,
            mem_read_data => mem_read_data
        );

    ----------------------------------------------------------------
    -- MEM/WB pipeline registers
    ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            MEMWB_mem_to_reg <= (others => '0');
            MEMWB_reg_write <= '0';
            MEMWB_mem_read_data <= (others => '0');
            MEMWB_alu_out <= (others => '0');
            MEMWB_rd <= (others => '0');
            MEMWB_pc_plus4 <= (others => '0');
        elsif rising_edge(clk) then
            MEMWB_mem_to_reg <= EXMEM_mem_to_reg;
            MEMWB_reg_write <= EXMEM_reg_write;
            MEMWB_mem_read_data <= mem_read_data;
            MEMWB_alu_out <= EXMEM_alu_out;
            MEMWB_rd <= EXMEM_rd;
            MEMWB_pc_plus4 <= EXMEM_pc_plus4;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Write Back (WB): select data to write to regfile
    ----------------------------------------------------------------
    reg_write_data_WB <= MEMWB_pc_plus4 when MEMWB_mem_to_reg="10" else
                        MEMWB_mem_read_data when MEMWB_mem_to_reg="01" else
                        MEMWB_alu_out;

    ----------------------------------------------------------------
    -- PC next selection
    -- Resolve branch/jump that were computed in EX stage (IDEX signals used)
    ----------------------------------------------------------------
    -- priority: Jump (J-type), Branch taken, else sequential
    process(IDEX_reg_data1, IDEX_pc_plus4, IDEX_instr, IDEX_jump, IDEX_branch, zero_flag_EX, pc_plus4)
        variable jump_shift_tmp : std_logic_vector(31 downto 0);
        variable pc_beq_tmp     : std_logic_vector(31 downto 0);
    begin
        -- compute targets based on EX results (use IDEX_instr for J-type)
        jump_shift_tmp := IDEX_pc_plus4(31 downto 28) & IDEX_instr(25 downto 0) & "00";
        pc_beq_tmp := std_logic_vector(unsigned(IDEX_pc_plus4) + unsigned(IDEX_imm));
        if IDEX_jump = '1' then
            pc_next <= jump_shift_tmp;
        elsif (IDEX_branch = '1' and zero_flag_EX = '1') then
            pc_next <= pc_beq_tmp;
        else
            pc_next <= pc_plus4;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Outputs for debug
    ----------------------------------------------------------------
    pc_out <= pc_current;
    alu_result <= ALU_out_EX;

end Behavioral;
