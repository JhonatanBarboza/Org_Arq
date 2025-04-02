.data
    # Vetor de words (32 bits) a ser ordenado
    .align 2          # Alinhamento em 4 bytes (2^2)
vetor: .word 7, 5, 2, 1, 1, 3, 4  # Dados iniciais
tamanho: .word 7      # Tamanho do vetor

.text
    .align 2          # Alinhamento de instruções em 4 bytes
    .globl main

main:
    # Inicialização
    la s0, vetor       # s0 = endereço base do vetor
    lw s1, tamanho     # s1 = tamanho do vetor
    addi s1, s1, -2    # s1 = tamanho-2 (para acesso j+1 seguro)
    li t0, -1          # t0 = contador externo (i) = -1

loop_externo:
    # Verifica se terminou o loop externo
    bgt t0, s1, fim    # Se i > tamanho-2, termina
    
    # Prepara próxima iteração
    addi t0, t0, 1     # i++
    li t1, 0           # t1 = contador interno (j) = 0

loop_interno:
    # Verifica se terminou o loop interno
    bgt t1, s1, loop_externo  # Se j > tamanho-2, volta para externo
    
    # Calcula endereço e carrega elementos
    slli t2, t1, 2     # t2 = j * 4 (offset em bytes para words)
    add t3, s0, t2     # t3 = endereço de vetor[j]
    lw t4, 0(t3)       # t4 = vetor[j]
    lw t5, 4(t3)       # t5 = vetor[j+1]
    
    addi t1, t1, 1     # j++
    
    # Decide se precisa fazer swap
    ble t4, t5, loop_interno  # Se vetor[j] <= vetor[j+1], continua
    
    # Faz swap dos elementos
    sw t5, 0(t3)       # vetor[j] = t5 (antigo vetor[j+1])
    sw t4, 4(t3)       # vetor[j+1] = t4 (antigo vetor[j])
    j loop_interno     # Continua loop interno

fim:
    # Imprime o vetor ordenado
    li t2, 0           # Contador de impressão
    lw t3, tamanho     # Tamanho do vetor
    li a7, 1           # Código de syscall para print_int

print_loop:
    bge t2, t3, exit   # Se imprimiu todos, sai
    slli t4, t2, 2     # Calcula offset (4 bytes por elemento)
    add t4, s0, t4     # Endereço do elemento
    lw a0, 0(t4)       # Carrega elemento (32 bits)
    ecall              # Imprime inteiro
    addi t2, t2, 1     # Incrementa contador
    j print_loop       # Repete

exit:
    li a7, 10          # Código para exit
    ecall              # Termina programa