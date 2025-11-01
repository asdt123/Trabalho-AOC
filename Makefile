# Pastas
SRC = src
TB  = tb
SIM = sim
BUILD = build

# Clock delay para simulação (opcional)
CLK_DELAY = 10ns

# Arquivos fonte
MYFADD = $(SRC)/myfadd.vhd
ALU    = $(SRC)/alu.vhd
CPU    = $(SRC)/cpu_top.vhd

# Testbenches
TB_MYFADD = $(TB)/tb_myfadd.vhd
TB_ALU    = $(TB)/tb_alu.vhd
TB_CPU    = $(TB)/tb_cpu.vhd

# Nome dos executáveis
EXE_MYFADD = tb_myfadd
EXE_ALU    = tb_alu
EXE_CPU    = tb_cpu

# Default: nada
all:
	@echo "Use make myfadd / make alu / make cpu para simular cada entidade"

# -----------------------------
# Testbench myFAdd
# -----------------------------
myfadd: $(MYFADD) $(TB_MYFADD)
	@echo "Compilando myfadd..."
	ghdl -a --ieee=standard --ieee=synopsys -fexplicit $(MYFADD) $(TB_MYFADD)
	ghdl -e --ieee=standard --ieee=synopsys -fexplicit $(EXE_MYFADD)
	ghdl -r --ieee=standard --ieee=synopsys -fexplicit $(EXE_MYFADD) --vcd=$(SIM)/myfadd.vcd --stop-time=12652ns
	@echo "Simulação myfadd concluída, arquivo VCD: $(SIM)/myfadd.vcd"

# -----------------------------
# Testbench ALU
# -----------------------------
alu: $(MYFADD) $(ALU) $(TB_ALU)
	@echo "Compilando ALU..."
	ghdl -a --ieee=standard --ieee=synopsys -fexplicit $(MYFADD) $(ALU) $(TB_ALU)
	ghdl -e --ieee=standard --ieee=synopsys -fexplicit $(EXE_ALU)
	ghdl -r --ieee=standard --ieee=synopsys -fexplicit $(EXE_ALU) --vcd=$(SIM)/alu.vcd --stop-time=500ns
	@echo "Simulação ALU concluída, arquivo VCD: $(SIM)/alu.vcd"


# -----------------------------
# Testbench CPU
# -----------------------------
cpu: $(MYFADD) $(ALU) $(CPU) $(TB_CPU)
	@echo "Compilando CPU..."
	ghdl -a $(MYFADD) $(ALU) $(CPU) $(TB_CPU)
	ghdl -e $(EXE_CPU)
	ghdl -r $(EXE_CPU) --vcd=$(SIM)/cpu.vcd --stop-time=500ns
	@echo "Simulação CPU concluída, arquivo VCD: $(SIM)/cpu.vcd"

# -----------------------------
# Limpeza
# -----------------------------
clean:
	rm -f *.o *.cf $(BUILD)/* $(SIM)/*.vcd $(EXE_MYFADD) $(EXE_ALU) $(EXE_CPU)
	@echo "Arquivos temporários removidos"
