# Assembly RISC-V: Comandos Básicos e Estruturas de Controle

Vou detalhar os principais comandos e estruturas em assembly RISC-V, incluindo load/store, syscalls e estruturas de repetição.

## Comandos Load e Store

Em RISC-V, os comandos de load (carregar) e store (armazenar) são usados para transferir dados entre memória e registradores.

### Load (Carregar)
- `lw rd, offset(rs1)` - Load Word (carrega uma palavra de 32 bits)
  ```asm
  lw t0, 4(sp)  # Carrega o valor do endereço [sp + 4] no registrador t0
  ```

- `lh rd, offset(rs1)` - Load Halfword (carrega meio palavra, 16 bits)
- `lb rd, offset(rs1)` - Load Byte (carrega um byte, 8 bits)
- `lbu rd, offset(rs1)` - Load Byte Unsigned (carrega byte sem sinal)
- `lhu rd, offset(rs1)` - Load Halfword Unsigned (carrega meio palavra sem sinal)

### Store (Armazenar)
- `sw rs2, offset(rs1)` - Store Word (armazena palavra de 32 bits)
  ```asm
  sw t0, 8(sp)  # Armazena o valor de t0 no endereço [sp + 8]
  ```

- `sh rs2, offset(rs1)` - Store Halfword (armazena meio palavra)
- `sb rs2, offset(rs1)` - Store Byte (armazena um byte)

## Syscalls (Chamadas de Sistema)

As syscalls em RISC-V dependem do ambiente de execução. No simulador RARS (RISC-V Assembler and Runtime Simulator), as syscalls são implementadas da seguinte forma:

1. Carregar o número da syscall no registrador `a7`
2. Colocar os argumentos nos registradores `a0`, `a1`, etc.
3. Executar a instrução `ecall`

Principais syscalls:

| Serviço | Código (a7) | Argumentos | Retorno |
|---------|------------|------------|---------|
| print_int | 1 | a0: inteiro a ser impresso | - |
| print_string | 4 | a0: endereço da string | - |
| read_int | 5 | - | a0: inteiro lido |
| read_string | 8 | a0: buffer, a1: tamanho | - |
| exit | 10 | - | - |
| print_char | 11 | a0: caractere a imprimir | - |
| read_char | 12 | - | a0: caractere lido |

Exemplo de syscall para imprimir um inteiro:
```asm
li a0, 42       # Valor a ser impresso
li a7, 1        # Código da syscall para print_int
ecall           # Executa a syscall
```

## Estruturas de Repetição

Em assembly, as estruturas de repetição são implementadas com instruções de branch (desvio).

### Loop Básico (while)

```asm
# Exemplo: while (t0 < t1) { ... }
loop:
    bge t0, t1, end_loop  # Se t0 >= t1, sai do loop
    # Corpo do loop aqui
    addi t0, t0, 1        # Incrementa t0
    j loop                # Volta para o início do loop
end_loop:
```

### Loop For

```asm
# Exemplo: for (i=0; i<10; i++) { ... }
    li t0, 0             # t0 = 0 (i)
    li t1, 10            # t1 = 10 (limite)
for_loop:
    bge t0, t1, end_for  # Se i >= 10, sai do loop
    # Corpo do loop aqui
    addi t0, t0, 1       # i++
    j for_loop           # Repete
end_for:
```

### Loop Do-While

```asm
# Exemplo: do { ... } while (t0 < t1)
loop:
    # Corpo do loop aqui
    addi t0, t0, 1       # Incrementa t0
    blt t0, t1, loop     # Se t0 < t1, repete
```

## Instruções de Controle de Fluxo

Principais instruções para controle de fluxo:

- `beq rs1, rs2, label` - Branch if Equal (desvia se igual)
- `bne rs1, rs2, label` - Branch if Not Equal (desvia se diferente)
- `blt rs1, rs2, label` - Branch if Less Than (desvia se menor)
- `bge rs1, rs2, label` - Branch if Greater or Equal (desvia se maior ou igual)
- `bltu rs1, rs2, label` - Branch if Less Than Unsigned
- `bgeu rs1, rs2, label` - Branch if Greater or Equal Unsigned
- `j label` - Jump incondicional
- `jal rd, label` - Jump and Link (para chamadas de função)
- `jalr rd, offset(rs1)` - Jump and Link Register

Exemplo de if-else:
```asm
    # if (t0 == t1) { ... } else { ... }
    bne t0, t1, else
    # Código do if
    j end_if
else:
    # Código do else
end_if:
```

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