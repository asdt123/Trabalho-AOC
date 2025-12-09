library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips32 is
    port (
        clk, reset      : in std_logic;
        pc_out          : out std_logic_vector(31 downto 0);
        alu_result  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of mips32 is

    -- =================================================================
    -- SINAIS DO ESTÁGIO IF (Instruction Fetch)
    -- =================================================================
    signal pc_current, pc_next, pc_plus4_IF : std_logic_vector(31 downto 0);
    signal instr_IF : std_logic_vector(31 downto 0);

    -- =================================================================
    -- REGISTRADOR PIPELINE: IF / ID
    -- =================================================================
    signal IF_ID_pc_plus4 : std_logic_vector(31 downto 0);
    signal IF_ID_instr    : std_logic_vector(31 downto 0);

    -- =================================================================
    -- SINAIS DO ESTÁGIO ID (Instruction Decode)
    -- =================================================================
    signal reg_dst, mem_to_reg : std_logic_vector(1 downto 0);
    signal alu_op, sign_or_zero: std_logic_vector(1 downto 0);
    signal jump, branch, mem_read, mem_write, alu_src, reg_write : std_logic;
    
    signal reg_read_data_1, reg_read_data_2 : std_logic_vector(31 downto 0);
    signal sign_ext_im, zero_ext_im, float_ext_im, imm_ext_ID : std_logic_vector(31 downto 0);
    
    -- Controle de escrita no registrador (Write Back signal logic needs to be carried over)
    signal wb_reg_write_ID : std_logic;
    signal wb_mem_to_reg_ID: std_logic_vector(1 downto 0);
    
    -- Controle de Memória
    signal m_mem_read_ID, m_mem_write_ID, m_branch_ID : std_logic;
    
    -- Controle de Execução
    signal ex_alu_src_ID : std_logic;
    signal ex_reg_dst_ID : std_logic_vector(1 downto 0);
    signal ex_alu_op_ID  : std_logic_vector(1 downto 0);

    -- =================================================================
    -- REGISTRADOR PIPELINE: ID / EX
    -- =================================================================
    signal ID_EX_pc_plus4      : std_logic_vector(31 downto 0);
    signal ID_EX_read_data_1   : std_logic_vector(31 downto 0);
    signal ID_EX_read_data_2   : std_logic_vector(31 downto 0);
    signal ID_EX_imm_ext       : std_logic_vector(31 downto 0);
    signal ID_EX_instr_25_21   : std_logic_vector(4 downto 0); -- Rs
    signal ID_EX_instr_20_16   : std_logic_vector(4 downto 0); -- Rt
    signal ID_EX_instr_15_11   : std_logic_vector(4 downto 0); -- Rd
    signal ID_EX_funct         : std_logic_vector(5 downto 0); -- Funct field (Instruction[5-0])
    
    -- Sinais de Controle propagados
    signal ID_EX_wb_reg_write  : std_logic;
    signal ID_EX_wb_mem_to_reg : std_logic_vector(1 downto 0);
    signal ID_EX_m_mem_read    : std_logic;
    signal ID_EX_m_mem_write   : std_logic;
    signal ID_EX_m_branch      : std_logic;
    signal ID_EX_ex_alu_src    : std_logic;
    signal ID_EX_ex_reg_dst    : std_logic_vector(1 downto 0);
    signal ID_EX_ex_alu_op     : std_logic_vector(1 downto 0);

    -- =================================================================
    -- SINAIS DO ESTÁGIO EX (Execute)
    -- =================================================================
    signal ALU_Cont_EX      : std_logic_vector(5 downto 0);
    signal alu_in_b_EX      : std_logic_vector(31 downto 0);
    signal alu_result_EX    : std_logic_vector(31 downto 0);
    signal zero_flag_EX     : std_logic;
    signal reg_write_dest_EX: std_logic_vector(4 downto 0);
    signal branch_target_EX : std_logic_vector(31 downto 0); -- PC + 4 + offset

    -- =================================================================
    -- REGISTRADOR PIPELINE: EX / MEM
    -- =================================================================
    signal EX_MEM_alu_result   : std_logic_vector(31 downto 0);
    signal EX_MEM_write_data   : std_logic_vector(31 downto 0); -- Data to write to memory
    signal EX_MEM_reg_dest     : std_logic_vector(4 downto 0);
    signal EX_MEM_zero         : std_logic;
    signal EX_MEM_branch_target: std_logic_vector(31 downto 0);

    -- Sinais de Controle propagados
    signal EX_MEM_wb_reg_write  : std_logic;
    signal EX_MEM_wb_mem_to_reg : std_logic_vector(1 downto 0);
    signal EX_MEM_m_mem_read    : std_logic;
    signal EX_MEM_m_mem_write   : std_logic;
    signal EX_MEM_m_branch      : std_logic;

    -- =================================================================
    -- SINAIS DO ESTÁGIO MEM (Memory)
    -- =================================================================
    signal mem_read_data_MEM : std_logic_vector(31 downto 0);
    signal pc_src_MEM        : std_logic; -- Branch decision

    -- =================================================================
    -- REGISTRADOR PIPELINE: MEM / WB
    -- =================================================================
    signal MEM_WB_read_data  : std_logic_vector(31 downto 0);
    signal MEM_WB_alu_result : std_logic_vector(31 downto 0);
    signal MEM_WB_reg_dest   : std_logic_vector(4 downto 0);
    signal MEM_WB_pc_plus4   : std_logic_vector(31 downto 0); -- Needed for JAL logic if implemented, ignoring for simplicity here

    -- Sinais de Controle propagados
    signal MEM_WB_wb_reg_write  : std_logic;
    signal MEM_WB_wb_mem_to_reg : std_logic_vector(1 downto 0);

    -- =================================================================
    -- SINAIS DO ESTÁGIO WB (Write Back)
    -- =================================================================
    signal write_back_data_WB : std_logic_vector(31 downto 0);

    signal ForwardA, ForwardB : std_logic_vector(1 downto 0);
    signal alu_src_a_mux, alu_src_b_mux : std_logic_vector(31 downto 0);
    -- Sinais
    signal stall_from_cache : std_logic; -- Novo sinal
    signal instruction_wire : std_logic_vector(31 downto 0);

begin

    -- Instância da CACHE (Substitui a IMEM antiga)
    icache: entity work.Instruction_Cache
        port map (
            clk => clk,
            reset => reset,
            pc => pc_current,
            instruction => instruction_wire,
            cpu_stall => stall_from_cache -- Conecta o sinal de stall
        );
    
    instr_IF <= instruction_wire; -- Conecta a saída da cache

    -- ----------------------------------------------------------------
    -- PC (Congela se stall_from_cache = '1')
    -- ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset='1' then
            pc_current <= (others => '0');
        elsif rising_edge(clk) then
            if stall_from_cache = '1' then
                -- STALL: Não faz nada (mantém o valor atual)
                pc_current <= pc_current; 
            else
                -- Normal operation
                if pc_src_MEM = '1' then
                    pc_current <= EX_MEM_branch_target;
                else
                    pc_current <= pc_plus4_IF;
                end if;
            end if;
        end if;
    end process;

    -- ----------------------------------------------------------------
    -- REGISTRADOR IF / ID (Congela se stall_from_cache = '1')
    -- ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            IF_ID_instr <= (others => '0');
            IF_ID_pc_plus4 <= (others => '0');
        elsif rising_edge(clk) then
            if stall_from_cache = '1' then
                 -- STALL: Não atualiza o registrador pipeline!
                 -- Mantém os dados antigos para quando o stall acabar
            else
                 -- Normal operation
                 if pc_src_MEM = '1' then
                     IF_ID_instr <= (others => '0'); -- Flush do Branch tem prioridade
                 else
                     IF_ID_instr <= instr_IF;
                     IF_ID_pc_plus4 <= pc_plus4_IF;
                 end if;
            end if;
        end if;
    end process;
    -- ----------------------------------------------------------------
    -- 2. ID STAGE (Decode)
    -- ----------------------------------------------------------------
    
    ctrl: entity work.control_unit_VHDL
        port map (
            reset => reset,
            opcode => IF_ID_instr(31 downto 26),
            reg_dst => reg_dst,
            mem_to_reg => mem_to_reg,
            alu_op => alu_op,
            jump => jump, -- Jump logic needs special handling in IF
            branch => branch,
            mem_read => mem_read,
            mem_write => mem_write,
            alu_src => alu_src,
            reg_write => reg_write,
            sign_or_zero => sign_or_zero
        );

    -- Agrupando sinais de controle para passar para os pipelines
    -- WB Group
    wb_reg_write_ID <= reg_write;
    wb_mem_to_reg_ID <= mem_to_reg;
    -- M Group
    m_mem_read_ID <= mem_read;
    m_mem_write_ID <= mem_write;
    m_branch_ID <= branch;
    -- EX Group
    ex_alu_src_ID <= alu_src;
    ex_reg_dst_ID <= reg_dst;
    ex_alu_op_ID <= alu_op;

    regfile: entity work.register_file_VHDL
        port map(
            clk => clk,
            rst => reset,
            reg_write_en => MEM_WB_wb_reg_write,     -- Vem do estágio WB!
            reg_write_dest => MEM_WB_reg_dest,       -- Vem do estágio WB!
            reg_write_data => write_back_data_WB,    -- Vem do estágio WB!
            reg_read_addr_1 => IF_ID_instr(25 downto 21),
            reg_read_data_1 => reg_read_data_1,
            reg_read_addr_2 => IF_ID_instr(20 downto 16),
            reg_read_data_2 => reg_read_data_2
        );

    -- Extensores de Imediato
    sign_ext_im <= (31 downto 16 => IF_ID_instr(15)) & IF_ID_instr(15 downto 0);
    zero_ext_im <= (31 downto 16 => '0') & IF_ID_instr(15 downto 0);
    float_ext_im<= IF_ID_instr(15 downto 0) & x"0000";
    
    imm_ext_ID <= sign_ext_im when sign_or_zero="01" else 
                  float_ext_im when sign_or_zero="10" else 
                  zero_ext_im;

    -- ----------------------------------------------------------------
    -- REGISTRADOR ID / EX
    -- ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            ID_EX_wb_reg_write <= '0';
            ID_EX_m_mem_write <= '0';
            ID_EX_m_branch <= '0';
            -- Zerar outros sinais críticos
        elsif rising_edge(clk) then
            -- Se Branch for tomado, FLUSH (Control signals = 0)
            if pc_src_MEM = '1' then
                ID_EX_wb_reg_write <= '0';
                ID_EX_m_mem_write <= '0';
                ID_EX_m_branch <= '0';
                ID_EX_m_mem_read <= '0';
            else
                -- Pass Control Signals
                ID_EX_wb_reg_write <= wb_reg_write_ID;
                ID_EX_wb_mem_to_reg <= wb_mem_to_reg_ID;
                ID_EX_m_mem_read <= m_mem_read_ID;
                ID_EX_m_mem_write <= m_mem_write_ID;
                ID_EX_m_branch <= m_branch_ID;
                ID_EX_ex_alu_src <= ex_alu_src_ID;
                ID_EX_ex_reg_dst <= ex_reg_dst_ID;
                ID_EX_ex_alu_op <= ex_alu_op_ID;

                -- Pass Data
                ID_EX_pc_plus4 <= IF_ID_pc_plus4;
                ID_EX_read_data_1 <= reg_read_data_1;
                ID_EX_read_data_2 <= reg_read_data_2;
                ID_EX_imm_ext <= imm_ext_ID;
                ID_EX_instr_25_21 <= IF_ID_instr(25 downto 21);
                ID_EX_instr_20_16 <= IF_ID_instr(20 downto 16);
                ID_EX_instr_15_11 <= IF_ID_instr(15 downto 11);
                ID_EX_funct <= IF_ID_instr(5 downto 0);
            end if;
        end if;
    end process;

   -- ----------------------------------------------------------------
    -- 3. EX STAGE (Execute) - MODIFICADO COM FORWARDING
    -- ----------------------------------------------------------------
    
    -- Instância da Unidade de Forwarding
    fw_unit: entity work.Forwarding_Unit
        port map (
            ID_EX_Rs => ID_EX_instr_25_21, -- Rs
            ID_EX_Rt => ID_EX_instr_20_16, -- Rt
            EX_MEM_Rd => EX_MEM_reg_dest,
            MEM_WB_Rd => MEM_WB_reg_dest,
            EX_MEM_RegWrite => EX_MEM_wb_reg_write,
            MEM_WB_RegWrite => MEM_WB_wb_reg_write,
            ForwardA => ForwardA,
            ForwardB => ForwardB
        );

    -- MUX 3x1 para a entrada A da ALU (Resolve Hazard no Rs)
    alu_src_a_mux <= ID_EX_read_data_1    when ForwardA = "00" else
                     MEM_WB_read_data     when ForwardA = "01" and MEM_WB_wb_mem_to_reg = "01" else -- Hazard do Load (WB)
                     write_back_data_WB   when ForwardA = "01" else -- Hazard R-Type (WB)
                     EX_MEM_alu_result    when ForwardA = "10" else -- Hazard R-Type (MEM)
                     ID_EX_read_data_1;

    -- MUX 3x1 para a entrada B (antes do Mux do Imediato) (Resolve Hazard no Rt)
    alu_src_b_mux <= ID_EX_read_data_2    when ForwardB = "00" else
                     MEM_WB_read_data     when ForwardB = "01" and MEM_WB_wb_mem_to_reg = "01" else
                     write_back_data_WB   when ForwardB = "01" else
                     EX_MEM_alu_result    when ForwardB = "10" else
                     ID_EX_read_data_2;

    -- MUX original do ALU Src (Imediato ou Registrador)
    -- Nota: Agora usa alu_src_b_mux em vez de ID_EX_read_data_2 direto
    alu_in_b_EX <= ID_EX_imm_ext when ID_EX_ex_alu_src='1' else alu_src_b_mux;

    -- ALU Control e ALU (sem alterações nos port maps, apenas na lógica acima)
    ALUControl: entity work.ALU_Control
        port map(
            Op => ID_EX_ex_alu_op,
            Funct => ID_EX_imm_ext(5 downto 0),
            ALU_Cont => ALU_Cont_EX
        );

    alu: entity work.ALU
        port map(
            a => alu_src_a_mux,     -- Agora usa o Mux de Forwarding A
            b => alu_in_b_EX,       -- Agora usa o resultado processado do Mux B + Imediato
            alu_cont => ALU_Cont_EX,
            alu_result => alu_result_EX,
            zero => zero_flag_EX
        );
        
    -- Destino do Registrador (Mux RegDst)
    reg_write_dest_EX <= "11111" when ID_EX_ex_reg_dst="10" else -- JAL (exemplo)
                         ID_EX_instr_15_11 when ID_EX_ex_reg_dst="01" else -- R-Type
                         ID_EX_instr_25_21; -- I-Type

    -- Calculo do Endereço de Branch (PC + 4 + offset<<2)
    branch_target_EX <= std_logic_vector(unsigned(ID_EX_pc_plus4) + unsigned(ID_EX_imm_ext(29 downto 0) & "00"));

    -- ----------------------------------------------------------------
    -- REGISTRADOR PIPELINE: EX / MEM
    -- ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            -- (resets iguais...)
        elsif rising_edge(clk) then
            if pc_src_MEM = '1' then 
                -- (flush igual...)
            else
                -- Control (igual...)
                EX_MEM_wb_reg_write <= ID_EX_wb_reg_write;
                EX_MEM_wb_mem_to_reg <= ID_EX_wb_mem_to_reg;
                EX_MEM_m_mem_read <= ID_EX_m_mem_read;
                EX_MEM_m_mem_write <= ID_EX_m_mem_write;
                EX_MEM_m_branch <= ID_EX_m_branch;

                -- Data
                EX_MEM_branch_target <= branch_target_EX;
                EX_MEM_zero <= zero_flag_EX;
                EX_MEM_alu_result <= alu_result_EX;
                
                -- === CORREÇÃO AQUI ===
                -- Use o sinal do MUX B, que já tem o dado adiantado/corrigido
                EX_MEM_write_data <= alu_src_b_mux; 
                -- =====================
                
                EX_MEM_reg_dest <= reg_write_dest_EX;
            end if;
        end if;
    end process;

    -- ----------------------------------------------------------------
    -- 4. MEM STAGE (Memory)
    -- ----------------------------------------------------------------
    
    dmem: entity work.Data_Memory_VHDL
        port map(
            clk => clk,
            mem_access_addr => EX_MEM_alu_result,
            mem_write_data => EX_MEM_write_data,
            mem_write_en => EX_MEM_m_mem_write,
            mem_read => EX_MEM_m_mem_read,
            mem_read_data => mem_read_data_MEM
        );

    -- ----------------------------------------------------------------
    -- REGISTRADOR MEM / WB
    -- ----------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            MEM_WB_wb_reg_write <= '0';
        elsif rising_edge(clk) then
            -- Control
            MEM_WB_wb_reg_write <= EX_MEM_wb_reg_write;
            MEM_WB_wb_mem_to_reg <= EX_MEM_wb_mem_to_reg;
            
            -- Data
            MEM_WB_read_data <= mem_read_data_MEM;
            MEM_WB_alu_result <= EX_MEM_alu_result;
            MEM_WB_reg_dest <= EX_MEM_reg_dest;
        end if;
    end process;

    -- ----------------------------------------------------------------
    -- 5. WB STAGE (Write Back)
    -- ----------------------------------------------------------------
    
    write_back_data_WB <= MEM_WB_read_data when MEM_WB_wb_mem_to_reg="01" else
                          MEM_WB_alu_result; -- Simplificado, remover JAL logic do Mux para brevidade

    -- Outputs para debug/teste
    pc_out <= pc_current;
    alu_result <= MEM_WB_alu_result;

end Behavioral;