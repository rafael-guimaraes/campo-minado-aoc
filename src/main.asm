.data
mapa:       .byte 0:128             # negativo = bomba; 0 a 8 = bombas em volta
estado:     .byte 0:128             # 0 = fechada; 1 = aberta
cabecalho:  .asciiz "\n  A B C D E F G H I J K L M N O P\n"
pede_jogada:  .asciiz "\nJogada: "
msg_invalida: .asciiz "Jogada invalida\n"
buffer:       .space 16

.text
.globl main

main:
    jal colocar_minas

jogo:
    jal imprimir_tabuleiro

    jal ler_jogada
    bltz $v0,jogada_invalida

    move $s1,$v1
    lb  $s2,estado($s1)

jogada_abrir:
    bnez $s2,jogada_invalida

    li  $t0,1
    sb  $t0,estado($s1)
    j   jogo

jogada_invalida:
    li  $v0,4
    la  $a0,msg_invalida
    syscall
    j   jogo

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

ler_jogada:
    li  $v0,4
    la  $a0,pede_jogada
    syscall

    li  $v0,8
    la  $a0,buffer
    li  $a1,16
    syscall

    la  $t0,buffer
    li  $v0,0

lj_casa:
    lb  $t4,0($t0)
    lb  $t5,1($t0)
    lb  $t6,2($t0)

    bne  $t6,'\n',lj_invalida
    blt  $t4,'A',lj_invalida
    bgt  $t4,'P',lj_invalida
    blt  $t5,'1',lj_invalida
    bgt  $t5,'8',lj_invalida

    addi $t4,$t4,-65
    addi $t5,$t5,-49
    sll  $v1,$t5,4
    add  $v1,$v1,$t4
    jr  $ra

lj_invalida:
    li  $v0,-1
    jr  $ra
