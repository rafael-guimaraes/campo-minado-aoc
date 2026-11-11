.data
mapa:       .byte 0:128
estado:     .byte 0:128
cabecalho:  .asciiz "\n  A B C D E F G H I J K L M N O P\n"

.text
.globl main

main:
    jal imprimir_tabuleiro
    li  $v0,10
    syscall

imprimir_tabuleiro:
    li  $v0,4
    la  $a0,cabecalho
    syscall

    li  $t0,0
    li  $t2,0

linha:
    li  $v0,1
    addi $a0,$t0,1
    syscall

    li  $v0,11
    li  $a0,' '
    syscall

    li  $t1,0

coluna:
    lb  $t3,estado($t2)

    li  $a0,'#'
    beqz $t3,imprime

    lb  $t3,mapa($t2)

    li  $a0,'*'
    bltz $t3,imprime

    li  $a0,'.'
    beqz $t3,imprime

    addi $a0,$t3,'0'

imprime:
    li  $v0,11
    syscall

    li  $v0,11
    li  $a0,' '
    syscall

    addi $t2,$t2,1
    addi $t1,$t1,1
    blt  $t1,16,coluna

    li  $v0,11
    li  $a0,'\n'
    syscall

    addi $t0,$t0,1
    blt  $t0,8,linha

    jr  $ra
