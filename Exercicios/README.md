**Compilar**
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o NOME.o NOME.s
riscv64-unknown-elf-ld -m elf32lriscv -o NOME NOME.o

**Executar**
qemu-riscv32 NOME

**Excluir**
rm *.o NOME

**Excutar o simulador**
java -jar rars1_5.jar# Organizacao_Arquitetura_Computadores
