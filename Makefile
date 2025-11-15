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
CPU    = $(SRC)/cpu_top.vhd

# Testbenches
TB_MYFADD = $(TB)/tb_myfadd.vhd
TB_MEMORY = $(TB)/tb_memory.vhd
TB_ALU    = $(TB)/tb_alu.vhd
TB_CPU    = $(TB)/tb_cpu.vhd

# Nome dos executáveis
EXE_MYFADD = tb_myfadd
EXE_MEMORY = tb_memory
EXE_ALU    = tb_alu
EXE_CPU    = tb_cpu

# Default: nada
all:
	@echo "Use make myfadd / make alu / make memory /make cpu para simular cada entidade"

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
# Testbench intAddSub
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
	ghdl -r --std=08 --ieee=standard --ieee=synopsys -fexplicit $(EXE_ALU) --vcd=$(SIM)/alu.vcd --stop-time=500ns
	@echo "Simulação ALU concluída, arquivo VCD: $(SIM)/alu.vcd"


# -----------------------------
# Testbench CPU
# -----------------------------
cpu: $(MYFADD) $(ALU) $(CPU) $(TB_CPU)
	@echo "Compilando CPU..."
	ghdl -a --std=08 $(MYFADD) $(ALU) $(CPU) $(TB_CPU)
	ghdl -e --std=08 $(EXE_CPU)
	ghdl -r --std=08 $(EXE_CPU) --vcd=$(SIM)/cpu.vcd --stop-time=500ns
	@echo "Simulação CPU concluída, arquivo VCD: $(SIM)/cpu.vcd"

# -----------------------------
# Limpeza
# -----------------------------
clean:
	rm -f *.o *.cf $(BUILD)/* $(SIM)/*.vcd $(EXE_MYFADD) $(EXE_ALU) $(EXE_CPU)
	@echo "Arquivos temporários removidos"
