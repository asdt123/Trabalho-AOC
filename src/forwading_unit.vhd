library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Forwarding_Unit is
    port (
        -- Endereços dos registradores que estão no estágio EX (operandos da ALU)
        ID_EX_Rs : in std_logic_vector(4 downto 0);
        ID_EX_Rt : in std_logic_vector(4 downto 0);
        
        -- Endereços de destino nos estágios posteriores (quem vai escrever)
        EX_MEM_Rd : in std_logic_vector(4 downto 0);
        MEM_WB_Rd : in std_logic_vector(4 downto 0);
        
        -- Sinais de controle de escrita
        EX_MEM_RegWrite : in std_logic;
        MEM_WB_RegWrite : in std_logic;
        
        -- Seletores de Forwarding para a ALU
        ForwardA : out std_logic_vector(1 downto 0); -- 00: Reg, 10: EX Hazard, 01: MEM Hazard
        ForwardB : out std_logic_vector(1 downto 0)
    );
end entity;

architecture Behavioral of Forwarding_Unit is
begin
    process(all) 
    begin
        -- Default: Sem forwarding (usa valor do registrador lido em ID)
        ForwardA <= "00";
        ForwardB <= "00";

        -- ==========================
        -- EX HAZARD (O dado está logo à frente, no estágio MEM)
        -- ==========================
        if (EX_MEM_RegWrite = '1' and (unsigned(EX_MEM_Rd) /= 0) and (EX_MEM_Rd = ID_EX_Rs)) then
            ForwardA <= "10";
        end if;
        
        if (EX_MEM_RegWrite = '1' and (unsigned(EX_MEM_Rd) /= 0) and (EX_MEM_Rd = ID_EX_Rt)) then
            ForwardB <= "10";
        end if;

        -- ==========================
        -- MEM HAZARD (O dado está no estágio WB)
        -- ==========================
        -- Nota: Só fazemos forwarding do WB se não houver um hazard do EX (o EX é mais recente/prioritário)
        
        if (MEM_WB_RegWrite = '1' and (unsigned(MEM_WB_Rd) /= 0) and (MEM_WB_Rd = ID_EX_Rs)) then
            if not (EX_MEM_RegWrite = '1' and (EX_MEM_Rd = ID_EX_Rs)) then -- Prioridade do EX
                ForwardA <= "01";
            end if;
        end if;
        
        if (MEM_WB_RegWrite = '1' and (unsigned(MEM_WB_Rd) /= 0) and (MEM_WB_Rd = ID_EX_Rt)) then
            if not (EX_MEM_RegWrite = '1' and (EX_MEM_Rd = ID_EX_Rt)) then -- Prioridade do EX
                ForwardB <= "01";
            end if;
        end if;
        
    end process;
end Behavioral;