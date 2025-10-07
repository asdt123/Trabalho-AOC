#!/bin/bash
# Script para compilar e simular MyFAdd do Flopoco

# 1. Analisa VHDL do Flopoco
ghdl -a -fsynopsys -fexplicit myfadd.vhd || exit 1

# 2. Analisa Testbench
ghdl -a -fsynopsys -fexplicit tb_myfadd.vhd || exit 1

# 3. Elabora o testbench
ghdl -e -fsynopsys -fexplicit tb_MyFAdd || exit 1

# 4. Roda a simulação
ghdl -r tb_MyFAdd --vcd=MyFAdd.vcd --stop-time=500ns || exit 1

# 5. Abre no GTKWave
gtkwave MyFAdd.vcd
