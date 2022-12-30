#----------------------------------------------------
#quickSort.asm
#
#Autores: Matheus Antonio, Leonardo, Anna Letycia
#
#DESC: programa que implementa o algoritmo de ordenacao quicksort. O programa deve ler um arquivo texto 
#	chamado numeros.csv (nos arquivos do grupo) e ordena-los.  
#	O programa deve ainda possuir uma funcao que converte uma string de n�meros para um inteiro 
#
#USO: Para o programa rodar corretamente deve usar o caso de teste 'entrada.txt', ou alguma sequencia de numeros 
#	separados por espaco e nao virgula. Eh importante verificar o path que eh passado em 'file', deve apontar
#	para onde esta o arquivo de teste de quem esta utilizando
#
#----------------------------------------------------



.data
	array: 		.space 	4000
	file: 		.asciiz "C:/work/UFU/AOC/Trabalho1/entrada.txt"
	newline: 	.asciiz "\n"
	apos: 		.asciiz "apos ordenacao: "
	antes: 		.asciiz "antes ordenacao: "
	qtdelementos:	.asciiz "numero de elementos do array: "
	space:		.asciiz " "
	buffer:		.asciiz ""
	number:		.asciiz ""

.text
.globl main

main:
	# abrir arquivo
	jal abreArquivo
	# ler arquivo
	jal lerArquivo

	move $s0,$v0
	li $v0,16
	move $a0,$s0
	syscall

	# aponta pro buffer
	la $t0, buffer
	li $t3,0
	li $t2,0

	#get N que e o numero de elementos do array
	li $v0,4
	la $a0,qtdelementos  #print quantidade de elementos
	syscall
	add $t5, $zero, 1000  # $t5 = tamanho do array
	li $v0,1
	add $a0,$t5,$zero
	syscall
	sub $v1,$t5,$zero # $v1 = $t5
	jal montaArray

	jal newLine
	# print array antes da ordenacao
	add $t5,$v1,1	# t5 = numero de elementos do array
	li $t0,0
	la $t4,array
	li $v0,4
	la $a0,antes
	syscall
	jal printArray
	
	# quickSort
	la $t0, array
	add $a0,$t0,$0
	li $a1,0
	add $a2,$0,$v1
	jal quickSort

	jal newLine
	# print array apos sort
	li $t0,0
	la $t4,array
	li $v0,4
	la $a0,apos
	syscall
	jal printArray

	li $v0,16
	move $a0,$s1
	syscall
	
	la $t4,array
	li $t2,0
	la $t6,number
	
	jal converteParaString

	li $v0,16
	move $a0,$s1
	syscall

	# end program
	li $v0,10
	syscall

abreArquivo:
	#abre o arquivo para leitura
 	 li $v0, 13      # syscall para abertura do arquivo
 	 la $a0, file     # nome do arquivo a abrir
 	 li $a1, 0        # flags (ignorado)
 	 li $a2, 0         # abre o arquivo em modo para leitura
	syscall
	move $s0,$v0

lerArquivo:
    #ler o arquivo 
	li $v0,14     # syscall para ler o arquivo
	move $a0,$s0   
	la $a1,buffer  # endereco do buffer para onde eh copiado o ficheiro
	li $a2,4000    # tamanho do buffer
	syscall
newLine:
    #print '\n'
	li $v0,4
	la $a0,newline
	syscall
	jr $ra

montaArray:
	# monta o array
	lb $t1,($t0)
	sub $t1,$t1,48
	addi $t0,$t0,1
	blt $t5,0,end
	blt $t1,0,continue
	bgt $t1,9,continue
	
	li $t4,10
	mul $t2,$t2,$t4
	add $t2,$t2,$t1
	b montaArray
continue:
	sw $t2,array($t3)
	sub $t5,$t5,1
	addi $t3,$t3,4
	li $t2,0
	b montaArray
end:
	sw $t2,array($t3)
	li $t2,0
	jr $ra
printArray:
	# print array
	bge $t0,$t5,fimPrint
	li $t9,4
	mul $t2,$t0,$t9
	add $t2,$t2,$t4
	lw $a0, ($t2)
	li $v0,1
	syscall
	# print " "
	la $a0,space
	li $v0,4
	syscall
	add $t0,$t0,1
	b printArray  	# recursividade 
fimPrint:
	jr $ra

troca:
	li $t9,4
	mult $a1,$t9
	mflo $t1
	add $t1,$t1,$a0	# t1 = arr + 4i
	lw $s1,($t1)	# s1 = arr[i]
	
	mult $a2,$t9
	mflo $t2
	add $t2,$t2,$a0
	lw $s2,($t2)	# s2 = arr[j]
	
	sw $s1,($t2)
	sw $s2,($t1)
	jr $ra
quickSort:
	sub $sp,$sp,16
	sw $a0,($sp) # a0 = array
	sw $a1,4($sp)	# a1 = esquerda
	sw $a2,8($sp)	# a2 = direita
	sw $ra,12($sp)

	bgt $a1,$a2,fimQS

	li $t9,4
	mult $a2,$t9
	mflo $t3
	add $t3,$t3,$a0
	lw $s3,($t3)	# s3 = array[esquerda] = pivo
	Loop:
		bge $a1,$a2,fim_If
		loop_menor:
			mult $a1,$t9
			mflo $t3
			add $t3,$t3,$a0
			lw $s4,($t3)	# s4 = array[i]
			bge $s4,$s3,fim_loop_1
			add $a1,$a1,1
			j loop_menor
		fim_loop_1:
			j loop_maior
		loop_maior:
			mult $a2,$t9
			mflo $t3
			add $t3,$t3,$a0
			lw $s4,($t3)	# s4 = array[j]
			ble $s4,$s3,fim_loop_2
			sub $a2,$a2,1
			j loop_maior
		fim_loop_2:
			bgt $a1,$a2,fim_if_1
			jal troca
			add $a1,$a1,1
			sub $a2,$a2,1
			j Loop
		fim_if_1:
			j Loop
	fim_If:
		move $t7,$a1	# t7 = i
		move $t8,$a2	# t8 = j
		lw $a1,4($sp)
		lw $a2,8($sp)
		bge $a1,$t8, sort_arr
		move $a2,$t8
		jal quickSort
		j sort_arr
	sort_arr:
		lw $a1,4($sp)
		lw $a2,8($sp)
		ble $a2,$t7,fimQS
		move $a1,$t7
		jal quickSort
fimQS:
	lw $a0,($sp)
	lw $a1,4($sp)
	lw $a2,8($sp)
	lw $ra,12($sp)
	add $sp,$sp,16
	jr $ra
	
converteParaString:
	beq $t5,$zero,exitConvert
	li $t9,4
	mult $t2,$t9
	mflo $t3
	add $t3,$t3,$t4
	lw $s3,($t3)
	move $s4,$s3
	li $s5,0
	size:
		add $s5,$s5,1
		div $s3,$s3,10
		beq $s3,$zero,exitContador
		b size
	exitContador:
		move $s3,$s4
		j convert
	convert:
		beq $s5,$zero,repeteConvert
		li $t9,1
		sub $t7,$s5,1
		multiply10th:
			beq $t7,$zero,exit_multiply
			li $t8,10
			mul $t9,$t9,$t8
			sub $t7,$t7,1
			b multiply10th
		exit_multiply:
			div $s3,$t9
			mflo $s2
			mfhi $s3
			add $s2,$s2,48
			sb $s2,($t6)
			li $v0,15
			move $a0,$s1
			la $a1,($t6)
			li $a2,1
			syscall
			add $t6,$t6,1
			sub $s5,$s5,1
			b convert
	repeteConvert:
		add $t2,$t2,1
		sub $t5,$t5,1
		li $v0,15
		move $a0,$s1
		la $a1,space
		li $a2,1
		syscall
		j converteParaString
exitConvert:
	jr $ra


