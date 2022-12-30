#2) escreva um programa que calcule a frequência de um elemento em um array  [1 1 2 3 2 4 5 6 5 4 8 9 1 1 14] freq(5)

.macro return0
	addiu	$v0, $zero, 10
	syscall
.end_macro

.macro readInt(%reg)
	addiu	$v0, $zero, 5
	syscall
	addu	%reg, $zero, $v0
.end_macro

.macro printStr(%str)
	addiu	$v0, $zero, 4
	la	$a0, %str
	syscall
.end_macro

.macro printInt(%intV)
	addiu	$v0, $zero, 1
	addu	$a0, $zero, %intV
	syscall
.end_macro


.data
	arr:	.space	40
	str1:	.asciiz	"Digite 10 números: "
	str2:	.asciiz	"Qual número você deseja descobrir a frequência? "
	#num:	.space	4
	str3:	.asciiz	"A frequência do número "
	str4:	.asciiz	" eh "
	
.text
	printStr(str1)
	addu	$s0, $zero, $zero  #contador
	la	$s7, arr	        	#ponteiro pro primeiro elemento do arr

FOR1:	slti	$t0, $s0, 10	   #s0<10 -> t0 = 1
	beq	$t0, $zero, SAI1	   #sai do laço

	# corpo do for	
	readInt($s1)
	sw	$s1, 0($s7)	#salva na mem o número lido no endereço do primeiro elemento do arr
	addiu	$s7, $s7, 4	#aponta para o próx elemento do arr (aritmética de ponteiro)
	
	# corpo do for /
	
	addiu 	$s0, $s0, 1	#contador++
	j	FOR1		#repete o loop
	
SAI1:
	printStr(str2)
	readInt($s3)
	#la	$at, num		 # at recebe endereço de num
	#sw	$s3, 0($at)
	
	addu	$s0, $zero, $zero  # i =0
	addu	$t3, $zero, $zero  # aux =0
	la	$s7, arr		   # aponta pro primeiro elemento do arr

FOR2:	slti	$t0, $s0, 10	# i < 10
	beq	$t0, $zero, SAI2	# sai do loop
	#corpo do FOR2
	lw	$s4, 0($s7)	#salva o que estiver no endereço do elemento do arr em $s4
	beq	$s4, $s3, SAI3	#compara o elemento do arr com o número salvo
	addiu	$s7, $s7, 4	#aponta para a próxima posição do arr
	#corpo do FOR2 /
	addiu 	$s0, $s0, 1	#i++
	j	FOR2		#repete o loop

SAI3:
	addiu	$s7, $s7, 4	##aponta para a próxima posição do arr
	addiu	$t3, $t3, 1 	#aux++
	addiu 	$s0, $s0, 1	#i++
	j	FOR2		#repete o loop
	
SAI2:
	printStr(str3)
	printInt($s3)
	printStr(str4)
	printInt($t3)
	
	return0