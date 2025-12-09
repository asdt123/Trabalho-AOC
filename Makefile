# Pastas
SRC = src
TB  = tb
SIM = sim
BUILD = build

# Clock delay para simulação (opcional)
CLK_DELAY = 10ns

# Arquivos fonte
MYFADD = $(SRC)/myfadd.vhd
MEMORY = $(SRC)/memory.vhd
ALU    = $(SRC)/alu.vhd
C_ALU  = $(SRC)/control_alu.vhd
C_UNIT = $(SRC)/control_unit.vhd
F_UNIT = $(SRC)/forwading_unit.vhd
CACHE  = $(SRC)/instruction_cache.vhd
REGS 	 = $(SRC)/register.vhd
INST 	 = $(SRC)/instruction_memory.vhd
CPU    = $(SRC)/mips32.vhd

# Testbenches
TB_MYFADD = $(TB)/tb_myfadd.vhd
TB_MEMORY = $(TB)/tb_memory.vhd
TB_ALU    = $(TB)/tb_alu.vhd
TB_C_ALU  = $(TB)/tb_control_alu.vhd
TB_C_UNIT = $(TB)/tb_control_unit.vhd
TB_REGS 	= $(TB)/tb_register.vhd
TB_INST 	= $(TB)/tb_instruction_memory.vhd
TB_CPU    = $(TB)/tb_mips32.vhd

# Nome dos executáveis
EXE_MYFADD = tb_myfadd
EXE_MEMORY = tb_memory
EXE_ALU    = tb_alu
EXE_C_ALU  = tb_control_alu
EXE_C_UNIT = tb_control_unit
EXE_REGS 	 = tb_register
EXE_INST 	 = tb_instruction_memory
EXE_CPU    = tb_mips32

# Default: nada
all:
	@echo "Use make myfadd / make memory / make alu / make c_alu / make instruction /"
	@echo "make c_unit / make register / make cpu para simular cada entidade"

# -----------------------------
# Testbench myFAdd
# -----------------------------
myfadd: $(MYFADD) $(TB_MYFADD)
	@echo "Compilando myfadd..."
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(MYFADD) $(TB_MYFADD)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_MYFADD)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_MYFADD) --vcd=$(SIM)/myfadd.vcd --stop-time=12652ns
	@echo "Simulação myfadd concluída, arquivo VCD: $(SIM)/myfadd.vcd"


# -----------------------------
# Testbench memory
# -----------------------------
memory: $(MEMORY) $(TB_MEMORY)
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(MEMORY) $(TB_MEMORY)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_MEMORY)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_MEMORY) --vcd=$(SIM)/memory.vcd --stop-time=10042ns
	@echo "Simulação MEMORY concluída, arquivo VCD: $(SIM)/memory.vcd"

# -----------------------------
# Testbench ALU
# -----------------------------
alu: $(MYFADD) $(ALU) $(TB_ALU)
	@echo "Compilando ALU..."
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(MYFADD) $(ALU) $(TB_ALU)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_ALU)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit --backtrace $(EXE_ALU) --vcd=$(SIM)/alu.vcd --stop-time=500ns
	@echo "Simulação ALU concluída, arquivo VCD: $(SIM)/alu.vcd"

# -----------------------------
# Testbench control ALU
# -----------------------------
c_alu: $(C_ALU) $(TB_C_ALU)
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(C_ALU) $(TB_C_ALU)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_C_ALU)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_C_ALU) --vcd=$(SIM)/control_alu.vcd --stop-time=10042ns
	@echo "Simulação control_alu concluída, arquivo VCD: $(SIM)/control_alu.vcd"

# -----------------------------
# Testbench control ALU
# -----------------------------
c_unit: $(C_UNIT) $(TB_C_UNIT)
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(C_UNIT) $(TB_C_UNIT)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_C_UNIT)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_C_UNIT) --vcd=$(SIM)/control_unit.vcd --stop-time=10042ns
	@echo "Simulação control_unit concluída, arquivo VCD: $(SIM)/control_unit.vcd"

# -----------------------------
# Testbench Register
# -----------------------------
register: $(REGS) $(TB_REGS)
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(REGS) $(TB_REGS)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_REGS)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_REGS) --vcd=$(SIM)/register.vcd --stop-time=10042ns
	@echo "Simulação register concluída, arquivo VCD: $(SIM)/register.vcd"


# -----------------------------
# Testbench Instruction
# -----------------------------
instruction: $(INST) $(TB_INST)
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(INST) $(TB_INST)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_INST)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_INST) --vcd=$(SIM)/instruction.vcd --stop-time=10042ns
	@echo "Simulação instruction concluída, arquivo VCD: $(SIM)/instruction.vcd"


# -----------------------------
# Testbench CPU
# -----------------------------
cpu: $(MYFADD) $(ALU) $(INST) $(REGS) $(C_UNIT) $(C_ALU) $(MEMORY) $(F_UNIT) $(CACHE) $(CPU) $(TB_CPU)
	@echo "Compilando CPU..."
	ghdl -a --std=08 --ieee=standard --ieee=synopsys -fexplicit $(MYFADD) $(ALU) $(CACHE) $(F_UNIT) $(INST) $(REGS) $(C_UNIT) $(C_ALU) $(MEMORY) $(CPU) $(TB_CPU)
	ghdl -e --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_CPU)
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_CPU) --vcd=$(SIM)/cpu.vcd --stop-time=500ns
	@echo "Simulação CPU concluída, arquivo VCD: $(SIM)/cpu.vcd"

# -----------------------------
# Limpeza
# -----------------------------
clean:
	rm -f *.o *.cf $(BUILD)/* $(SIM)/*.vcd $(EXE_MYFADD) $(EXE_ALU) $(EXE_CPU)
	@echo "Arquivos temporários removidos"
