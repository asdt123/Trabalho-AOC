#!/bin/bash
# Script para compilar e simular MyFAdd do Flopoco (GHDL 3.0)

ghdl -a --ieee=standard --ieee=synopsys -fexplicit myfadd.vhd

ghdl -e --ieee=standard --ieee=synopsys -fexplicit TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15

ghdl -r --ieee=standard --ieee=synopsys -fexplicit TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15 --vcd=TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15.vcd --stop-time=12652ns

gtkwave TestBench_IEEEFPAdd_8_23_comb_uid2_comb_uid15.vcd