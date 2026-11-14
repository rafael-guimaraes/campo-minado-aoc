.data
mapa:       .byte 0:128             # negativo = bomba; 0 a 8 = bombas em volta
estado:     .byte 0:128             # 0 = fechada; 1 = aberta
cabecalho:  .asciiz "\n  A B C D E F G H I J K L M N O P\n"

.text
.globl main

main:
    jal colocar_minas

    jal imprimir_tabuleiro
    li  $v0,10
    syscall

imprimir_tabuleiro:
    li  $v0,4
    la  $a0,cabecalho
    syscall

    li  $t0,0
    li  $t2,0

it_linha:
    li  $v0,1
    addi $a0,$t0,1
    syscall

    li  $v0,11
    li  $a0,' '
    syscall

    li  $t1,0

it_coluna:
    lb  $t3,estado($t2)

    li  $a0,'#'
    beqz $t3,it_imprime

    lb  $t3,mapa($t2)

    li  $a0,'*'
    bltz $t3,it_imprime

    li  $a0,'.'
    beqz $t3,it_imprime

    addi $a0,$t3,'0'

it_imprime:
    li  $v0,11
    syscall

    li  $v0,11
    li  $a0,' '
    syscall

    addi $t2,$t2,1
    addi $t1,$t1,1
    blt  $t1,16,it_coluna

    li  $v0,11
    li  $a0,'\n'
    syscall

    addi $t0,$t0,1
    blt  $t0,8,it_linha

    jr  $ra

colocar_minas:
    li  $t1,0

cm_sortear:
    li  $v0,42
    li  $a0,0
    li  $a1,128
    syscall
    move $t3,$a0

    lb  $t4,mapa($t3)
    bltz $t4,cm_sortear

    li  $t4,-9
    sb  $t4,mapa($t3)

    srl  $t5,$t3,4
    andi $t6,$t3,15

    li  $t7,-1

cm_linha:
    li  $t8,-1

cm_coluna:
    add  $t9,$t5,$t7
    bltz $t9,cm_pular
    bge  $t9,8,cm_pular

    add  $t2,$t6,$t8
    bltz $t2,cm_pular
    bge  $t2,16,cm_pular

    sll  $t4,$t9,4
    add  $t4,$t4,$t2
    lb   $t2,mapa($t4)
    addi $t2,$t2,1
    sb   $t2,mapa($t4)

cm_pular:
    addi $t8,$t8,1
    ble  $t8,1,cm_coluna

    addi $t7,$t7,1
    ble  $t7,1,cm_linha

    addi $t1,$t1,1
    blt  $t1,20,cm_sortear

    jr  $ra
