# Projeto MIPS em VHDL

Este projeto implementa uma versão simplificada de um processador **MIPS de 32 bits** em **VHDL**, com suporte a operações inteiras e ponto flutuante. Ele foi desenvolvido com foco em modularidade, permitindo simulação e teste de cada componente individualmente.

---

## 🧩 Estrutura do Projeto

```
.
├── Makefile
├── README.md
├── build
├── sim
│   ├── alu.vcd
│   ├── control_alu.vcd
│   ├── control_unit.vcd
│   ├── cpu.vcd
│   ├── instruction.vcd
│   ├── intAddSub.vcd
│   ├── memory.vcd
│   ├── myfadd.vcd
│   └── register.vcd
├── src
│   ├── alu.vhd
│   ├── control_alu.vhd
│   ├── control_unit.vhd
│   ├── instruction_memory.vhd
│   ├── memory.vhd
│   ├── mips32.vhd
│   ├── myfadd.vhd
│   └── register.vhd
├── tb
│   ├── tb_alu.vhd
│   ├── tb_control_alu.vhd
│   ├── tb_control_unit.vhd
│   ├── tb_instruction_memory.vhd
│   ├── tb_memory.vhd
│   ├── tb_mips32.vhd
│   ├── tb_myfadd.vhd
│   └── tb_register.vhd
├── tests
│   ├── alu.input
│   ├── control_alu.input
│   ├── instruction.input
│   ├── memory.input
│   ├── my_fadd.input
│   └── register.input
├── work-obj08.cf
└── work-obj93.cf

```

---

## ⚙️ Requisitos

* **GHDL** (para simulação e compilação local)
* **GTKWave** (para visualização de formas de onda)
* Alternativamente, pode ser executado online usando o **EDA Playground**

---
## Tabela de instruções

# Instruções Implementadas no Projeto MIPS32 (Versão Atual)

| Instrução | Tipo | Opcode | Funct | Descrição |
|----------|------|---------|--------|------------|
| **add rd, rs, rt** | R | 000000 | 100000 | Soma inteira: rd = rs + rt |
| **sub rd, rs, rt** | R | 000000 | 100010 | Subtração inteira: rd = rs – rt |
| **addf rd, rs, rt** | R | 000000 | 110000 | Soma float32: rd = rs + rt |
| **subf rd, rs, rt** | R | 000000 | 110010 | Subtração float32: rd = rs – rt |
| **and rd, rs, rt** | R | 000000 | 100100 | AND bit a bit |
| **or rd, rs, rt** | R | 000000 | 100101 | OR bit a bit |
| **addi rt, rs, imm** | I | 001000 | — | Soma imediata inteira: rt = rs + imm |
| **subi rt, rs, imm** | I | 001001 | — | Subtração imediata inteira: rt = rs – imm |
| **addfi rt, rs, immf** | I | 001010 | — | Soma float immediate: rt = rs + imm_float |
| **subfi rt, rs, immf** | I | 001011 | — | Subtração float immediate: rt = rs – imm_float |
| **andi rt, rs, imm** | I | 100100 | — | AND imediato (zero extend) |
| **ori rt, rs, imm** | I | 100101 | — | OR imediato (zero extend) |

## ▶️ Como Executar no EDA Playground

1. Acesse [EDA Playground](https://edaplayground.com/x/SXVn)
2. Entre com as instruções do processador no arquivo `instruction.input`
3. O comando de compilação está no arquivo `run.bash`
---

# 🛠️ Tutorial: Como Usar o Makefile

O projeto utiliza um **Makefile** para automatizar o processo de **compilação, análise e simulação** dos módulos VHDL com o **GHDL**.
Isso evita a necessidade de digitar comandos longos no terminal e facilita a execução de testes específicos.

---

## ⚙️ Pré-requisitos

Antes de usar o `make`, verifique se você possui:

* **GHDL** instalado (preferencialmente com suporte IEEE Synopsys);
* **GTKWave** (para visualizar os sinais `.vcd`);
* Um terminal com `make` (Linux, macOS ou WSL no Windows).

Para instalar no Ubuntu ou Fedora:

```bash
# Ubuntu/Debian
sudo apt install ghdl gtkwave make

# Fedora
sudo dnf install ghdl gtkwave make
```

---

## ▶️ Comandos Principais

O `Makefile` define alvos (targets) que automatizam tarefas específicas.

### 🔹 Compilação dos componentes
make myfadd
make memory
make alu
make c_alu
make c_unit
make register
make instruction
make cpu

## 💡 Dica

Você pode adicionar mais módulos no Makefile seguindo o padrão existente.
Por exemplo, para criar um novo alvo `make mip32`, basta definir algo como:

```makefile
mip32:
	ghdl -a --ieee=standard --ieee=synopsys -fexplicit src/mip32.vhd tb/tb_mip32.vhd
	ghdl -e --ieee=standard --ieee=synopsys -fexplicit tb_mip32
	ghdl -r tb_mip32 --vcd=sim/mip32.vcd
```

Com esses comandos, você poderá simular qualquer módulo do processador, depurar erros e observar o comportamento dos sinais com facilidade.



## 🧾 Licença

Este projeto é de uso educacional e livre para modificação e aprimoramento.
