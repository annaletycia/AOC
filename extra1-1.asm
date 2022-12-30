#1) escreva um programa que calcule o fatorial de N. (sem fun��es)

.data
	N:	.space	4
	fat:	.word	1
	str1:	.asciiz  "Digite um n�mero: "
	str21:	.asciiz	 "O fatorial de "
	str22:	.asciiz  " eh "
	strerr:	.asciiz  "O n�mero indicado deve ser positivo."
	
.text
	#printf("Digite um n�mero: ")
	addiu	$v0, $zero, 4
	la	$a0, str1
	syscall
	
	addiu	$v0, $zero, 5	 # l� um inteiro
	syscall
	la	$at, N		 # at recebe endere�o de N
	sw	$v0, 0($at)	 # o conte�do de v0 � armazenado no endere�o de mem�ria de at (N);
	addu	$s0, $zero, $v0	 # s0 -> 0 + N  (registrador do N)
	
	# if(N == 0)  fat(0) = 1
	beq	$s0, $zero, IF1
	# if(N<0)   equivalente a 0 > N
	slt	$t0, $zero, $s0	  # se 0<N, t0 = 1. Sen�o t0 = 0.
	beq	$t0, $zero, SAI2  # compara se t0 � igual a zero, se sim, pula pra SAI2
	
	# continua o c�digo...
	#for(i = 1; i<=N; i++){		#i <= N equivale i < N+1 forall Z
	addiu	$s2, $zero, 1   		# $s2 = i = 1
	addiu	$s3, $s0, 1		#s3 = N+1
	addiu	$s1, $zero, 1		# $s1 : registrador do fat
	
FOR:	slt	$t7, $s2, $s3  		# se s2<s3, t7=1
	beq	$t7, $zero, SAI1		# se forem iguais, o for � finalizado, caso contr�rio, continua
	
	#corpo do for
	mult	$s1,$s2			# fat * i
	mflo	$s1			# atualizando registrador do fat
	la	$at, fat
	sw	$s1, 0($at)		# salva o fat em seu endee�o de mem�ria
	#corpo do for /
	
	addiu	$s2, $s2, 1	# i++
	j	FOR		# repete o loop
	
IF1:	
	# casos base em que fat = 1
	addiu	$s1, $zero, 1
	la	$t1, fat
	sw	$s1, 0($t1)
	j	SAI1
	
SAI1:
	# printf("O fatorial de ")
	addiu	$v0, $zero, 4
	la	$a0, str21  
	syscall
	# printf("%d", N)
	addiu	$v0, $zero, 1
	addu	$a0, $zero, $s0
	syscall
	# printf(" eh ")
	addiu	$v0, $zero, 4
	la	$a0, str22  
	syscall	
	# printf("%d", fat)
	addiu	$v0, $zero, 1
	addu	$a0, $zero, $s1
	syscall
	j	EXIT

SAI2:
	# printf("O n�mero indicado deve ser positivo")
	addiu	$v0, $zero, 4
	la	$a0, strerr  
	syscall	
	j	EXIT
EXIT:
	addiu	$v0, $zero, 10	#return 0;
	syscall
