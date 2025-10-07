#!/bin/bash
# Script para compilar e simular MyFAdd do Flopoco (GHDL 3.0)

# Diretórios
ENTIDADES="./entidades"
TESTBENCH="./testbench"
BUILD="./build"
SAIDAS="./saidas"
SIMULACOES="./simulações"

# Cria pastas se não existirem
mkdir -p $BUILD $SAIDAS $SIMULACOES

# 1. Analisa VHDL do Flopoco
ghdl -a -fsynopsys -fexplicit --workdir=$BUILD $ENTIDADES/myfadd.vhd || exit 1

# 2. Analisa Testbench
ghdl -a -fsynopsys -fexplicit --workdir=$BUILD $TESTBENCH/tb_myfadd.vhd || exit 1

# 3. Elabora o testbench
ghdl -e -fsynopsys -fexplicit --workdir=$BUILD -o $SAIDAS/tb_myfadd tb_myfadd || exit 1

# 4. Roda a simulação
$SAIDAS/tb_myfadd --vcd=$SIMULACOES/MyFAdd.vcd --stop-time=500ns || exit 1

# 5. Abre no GTKWave
gtkwave $SIMULACOES/MyFAdd.vcd
