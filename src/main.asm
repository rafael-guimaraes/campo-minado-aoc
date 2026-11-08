.data
mapa:       .byte 0:128             # -1 = bomba; 0 a 8 = bombas em volta
estado:     .byte 0:128             # 0 = fechada; 1 = aberta
cabecalho:  .asciiz "\n  A B C D E F G H I J K L M N O P\n"

.text
.globl main
main:
	jal  imprimir_tabuleiro

	li   $v0, 10
	syscall

imprimir_tabuleiro:
	li   $v0, 4
	la   $a0, cabecalho
	syscall

	li   $t0, 0
	li   $t2, 0
it_linha:
	li   $v0, 1
	addi $a0, $t0, 1
	syscall

	li   $v0, 11
	li   $a0, ' '
	syscall

	li   $t1, 0
it_coluna:
	lb   $t3, estado($t2)
	li   $a0, '#'
	beqz $t3, it_casa

	lb   $t3, mapa($t2)
	li   $a0, '*'
	bltz $t3, it_casa

	li   $a0, '.'
	beqz $t3, it_casa

	addi $a0, $t3, '0'
it_casa:
	li   $v0, 11
	syscall

	li   $v0, 11
	li   $a0, ' '
	syscall

	addi $t2, $t2, 1
	addi $t1, $t1, 1
	blt  $t1, 16, it_coluna

	li   $v0, 11
	li   $a0, 10
	syscall

	addi $t0, $t0, 1
	blt  $t0, 8, it_linha

	jr   $ra
