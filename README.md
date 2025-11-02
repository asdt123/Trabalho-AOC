# Projeto MIPS em VHDL

Este projeto implementa uma versão simplificada de um processador **MIPS de 32 bits** em **VHDL**, com suporte a operações inteiras e ponto flutuante. Ele foi desenvolvido com foco em modularidade, permitindo simulação e teste de cada componente individualmente.

---

## 🧩 Estrutura do Projeto

```
.
├── Makefile                   # Script de automação para compilação e simulação local
├── build/                     # Diretório de saída de compilação
├── intADD/
│   └── flopoco.vhdl            # Implementação gerada do somador inteiro (Flopoco)
├── sim/
│   ├── alu.vcd                 # Resultados de simulação (dump de ondas)
│   ├── intAddSub.vcd
│   └── myfadd.vcd
├── src/
│   ├── alu.vhd                 # Unidade Lógica e Aritmética
│   ├── control_unit.vhd        # Unidade de Controle
│   ├── instruction_decoder.vhd # Decodificador de Instruções
│   ├── intAddSub.vhd           # Módulo de soma/subtração inteira
│   ├── memory.vhd              # Memória de dados e instruções
│   ├── mip32.vhd               # Top-level do processador
│   ├── myfadd.vhd              # Somador de ponto flutuante
│   ├── program.mem             # Programa de teste carregado na memória
│   ├── register.vhd            # Banco de registradores
│   └── testbench_mips.vhd      # Testbench principal
├── tb/
│   ├── tb_alu.vhd              # Testbench da ALU
│   ├── tb_intAddSub.vhd        # Testbench do somador/subtrator inteiro
│   └── tb_myfadd.vhd           # Testbench do somador de ponto flutuante
├── tests/
│   ├── intAddSub.input         # Vetores de teste para módulo intAddSub
│   └── my_fadd.input           # Vetores de teste para módulo myfadd
└── work-obj93.cf               # Arquivo de trabalho da simulação (GHDL)
```

---

## ⚙️ Requisitos

* **GHDL** (para simulação e compilação local)
* **GTKWave** (para visualização de formas de onda)
* Alternativamente, pode ser executado online usando o **EDA Playground**

---

## ▶️ Como Executar no EDA Playground

1. Acesse [EDA Playground](https://www.edaplayground.com/)
2. Selecione:

   * **Language:** VHDL 2008
   * **Tools:** GHDL + GTKWave
3. Copie o conteúdo da pasta `src/` (ou o módulo/testbench específico que deseja testar)
4. Caso vá testar um módulo isolado:

   * Cole o conteúdo do respectivo `tb_*.vhd` na aba **Testbench**
   * Cole o módulo em **Design files**
5. Clique em **Run**
6. Visualize as ondas geradas em **View Waveform**

💡 *Dica:* para testar o `intAddSub`, use o `tb_intAddSub.vhd` e inclua o arquivo `intAddSub.vhd` como dependência.

---

## 🧠 Principais Componentes

| Componente                | Descrição                                                   |
| ------------------------- | ----------------------------------------------------------- |
| `alu.vhd`                 | Implementa as operações aritméticas e lógicas básicas       |
| `control_unit.vhd`        | Gera sinais de controle para os módulos do processador      |
| `instruction_decoder.vhd` | Interpreta o campo das instruções MIPS                      |
| `intAddSub.vhd`           | Somador/subtrator inteiro com suporte a operandos negativos |
| `myfadd.vhd`              | Somador de ponto flutuante (IEEE 754)                       |
| `memory.vhd`              | Armazena instruções e dados                                 |
| `register.vhd`            | Banco de registradores de propósito geral                   |
| `testbench_mips.vhd`      | Testbench completo para o processador MIPS                  |

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

### 🔹 Compilar e simular a ULA

```bash
make alu
```

Analisa, elabora e simula o arquivo `tb_alu.vhd`.
O resultado da simulação é salvo em `sim/alu.vcd`, podendo ser visualizado com:

```bash
gtkwave sim/alu.vcd
```

---

### 🔹 Compilar e simular o módulo de soma/subtração inteira

```bash
make addsub
```

Executa o testbench `tb_intAddSub.vhd` e salva o resultado em `sim/intAddSub.vcd`.

---

### 🔹 Compilar e simular o módulo de soma de ponto flutuante (FloPoCo)

```bash
make myfadd
```

Executa o testbench `tb_myfadd.vhd` e gera `sim/myfadd.vcd`.

---

### 🔹 Limpar arquivos gerados

```bash
make clean
```

Remove arquivos temporários e intermediários (`work-obj93.cf`, `.vcd`, etc.).

---

## 💡 Dica

Você pode adicionar mais módulos no Makefile seguindo o padrão existente.
Por exemplo, para criar um novo alvo `make mip32`, basta definir algo como:

```makefile
mip32:
	ghdl -a --ieee=standard --ieee=synopsys -fexplicit src/mip32.vhd tb/tb_mip32.vhd
	ghdl -e --ieee=standard --ieee=synopsys -fexplicit tb_mip32
	ghdl -r tb_mip32 --vcd=sim/mip32.vcd
```

---

## 🌐 Rodando no EDA Playground

1. Acesse: [https://edaplayground.com](https://edaplayground.com)
2. Escolha o compilador **GHDL (mcode)**.
3. Cole os arquivos `.vhd` da pasta `src/` e o testbench correspondente.
4. Marque “Run simulation” e rode.
5. Para ver as formas de onda, abra o **GTKWave** embutido na aba de resultados.

---

Com esses comandos, você poderá simular qualquer módulo do processador, depurar erros e observar o comportamento dos sinais com facilidade.



## 🧾 Licença

Este projeto é de uso educacional e livre para modificação e aprimoramento.
