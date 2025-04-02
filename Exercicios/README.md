# Tabelas de Referência para Assembly RISC-V

Aqui estão tabelas organizadas para facilitar a visualização dos principais comandos e estruturas em RISC-V:

## Tabela 1: Instruções Load e Store

| Instrução | Sintaxe           | Descrição                                 | Exemplo                 |
|-----------|-------------------|-------------------------------------------|-------------------------|
| **lw**    | `lw rd, offset(rs1)` | Carrega palavra (32 bits) com sinal       | `lw t0, 4(sp)`         |
| **lh**    | `lh rd, offset(rs1)` | Carrega meia palavra (16 bits) com sinal  | `lh t1, 8(s0)`         |
| **lb**    | `lb rd, offset(rs1)` | Carrega byte (8 bits) com sinal           | `lb t2, -3(gp)`        |
| **lhu**   | `lhu rd, offset(rs1)`| Carrega meia palavra sem sinal            | `lhu t3, 12(a0)`       |
| **lbu**   | `lbu rd, offset(rs1)`| Carrega byte sem sinal                    | `lbu t4, 1(ra)`        |
| **sw**    | `sw rs2, offset(rs1)`| Armazena palavra (32 bits)                | `sw a0, 0(sp)`         |
| **sh**    | `sh rs2, offset(rs1)`| Armazena meia palavra (16 bits)           | `sh a1, 6(t0)`         |
| **sb**    | `sb rs2, offset(rs1)`| Armazena byte (8 bits)                    | `sb a2, -4(s1)`        |

## Tabela 2: Syscalls Comuns (ambiente RARS/SPIM)

| Serviço | Código (a7) | Argumentos | Retorno | Descrição |
|---------|------------|------------|---------|-----------|
| print_int | 1 | a0 = inteiro | - | Imprime inteiro |
| print_float | 2 | fa0 = float | - | Imprime float |
| print_double | 3 | fa0 = double | - | Imprime double |
| print_string | 4 | a0 = endereço | - | Imprime string |
| read_int | 5 | - | a0 = inteiro | Lê inteiro |
| read_float | 6 | - | fa0 = float | Lê float |
| read_double | 7 | - | fa0 = double | Lê double |
| read_string | 8 | a0 = buffer, a1 = tamanho | - | Lê string |
| sbrk | 9 | a0 = bytes | a0 = endereço | Aloca memória |
| exit | 10 | - | - | Termina programa |
| print_char | 11 | a0 = caractere | - | Imprime caractere |
| read_char | 12 | - | a0 = caractere | Lê caractere |
| open_file | 13 | a0 = nome, a1 = flags | a0 = descritor | Abre arquivo |
| read_file | 14 | a0 = descritor, a1 = buffer, a2 = tamanho | a0 = bytes lidos | Lê arquivo |
| write_file | 15 | a0 = descritor, a1 = buffer, a2 = tamanho | a0 = bytes escritos | Escreve arquivo |
| close_file | 16 | a0 = descritor | - | Fecha arquivo |

## Tabela 3: Estruturas de Controle e Repetição

| Padrão | Implementação em RISC-V | Exemplo |
|--------|-------------------------|---------|
| **if** | `beq/bne/blt/bge` + label | ```beq t0, t1, label_true``` |
| **if-else** | ```beq t0, t1, if_true<br>j else<br>if_true:<br>  # código if<br>j end_if<br>else:<br>  # código else<br>end_if:``` | [Ver exemplo completo abaixo] |
| **while** | ```loop:<br>  bge t0, t1, end_loop<br>  # corpo<br>  j loop<br>end_loop:``` | [Ver exemplo completo abaixo] |
| **for** | ```li t0, 0       # i=0<br>li t1, 10      # limite<br>for_loop:<br>  bge t0, t1, end_for<br>  # corpo<br>  addi t0, t0, 1 # i++<br>  j for_loop<br>end_for:``` | [Ver exemplo completo abaixo] |
| **do-while** | ```do:<br>  # corpo<br>  blt t0, t1, do``` | [Ver exemplo completo abaixo] |

## Tabela 4: Instruções de Branch (Desvio)

| Instrução | Sintaxe               | Descrição                          | Flags |
|-----------|-----------------------|------------------------------------|-------|
| **beq**   | `beq rs1, rs2, label` | Salta se igual (==)                | Z = 1 |
| **bne**   | `bne rs1, rs2, label` | Salta se diferente (!=)            | Z = 0 |
| **blt**   | `blt rs1, rs2, label` | Salta se menor (<, signed)         | N ≠ V |
| **bge**   | `bge rs1, rs2, label` | Salta se maior ou igual (≥, signed)| N = V |
| **bltu**  | `bltu rs1, rs2, label`| Salta se menor (unsigned)          | C = 1 |
| **bgeu**  | `bgeu rs1, rs2, label`| Salta se maior ou igual (unsigned) | C = 0 |

## Exemplos Completos em Tabela

### Exemplo 1: If-Else

| Código C | Código RISC-V |
|----------|---------------|
| ```c<br>if (a == b) {<br>  // bloco if<br>} else {<br>  // bloco else<br>}<br>``` | ```asm<br>  beq a0, a1, if_true<br>  # bloco else<br>  j end_if<br>if_true:<br>  # bloco if<br>end_if:<br>``` |

### Exemplo 2: Loop While

| Código C | Código RISC-V |
|----------|---------------|
| ```c<br>while (i < 10) {<br>  // corpo<br>  i++;<br>}<br>``` | ```asm<br>  li t0, 0       # i=0<br>  li t1, 10      # limite<br>loop:<br>  bge t0, t1, end_loop<br>  # corpo<br>  addi t0, t0, 1 # i++<br>  j loop<br>end_loop:<br>``` |

### Exemplo 3: Loop For

| Código C | Código RISC-V |
|----------|---------------|
| ```c<br>for (i=0; i<10; i++) {<br>  // corpo<br>}<br>``` | ```asm<br>  li t0, 0       # i=0<br>  li t1, 10      # limite<br>for_loop:<br>  bge t0, t1, end_for<br>  # corpo<br>  addi t0, t0, 1 # i++<br>  j for_loop<br>end_for:<br>``` |

### Exemplo 4: Do-While

| Código C | Código RISC-V |
|----------|---------------|
| ```c<br>do {<br>  // corpo<br>  i++;<br>} while (i < 10);<br>``` | ```asm<br>  li t0, 0       # i=0<br>  li t1, 10      # limite<br>do:<br>  # corpo<br>  addi t0, t0, 1 # i++<br>  blt t0, t1, do<br>``` |


___

**Compilar**
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o NOME.o NOME.s
riscv64-unknown-elf-ld -m elf32lriscv -o NOME NOME.o

**Executar**
qemu-riscv32 NOME

**Excluir**
rm *.o NOME

**Excutar o simulador**
java -jar rars1_5.jar# Organizacao_Arquitetura_Computadores