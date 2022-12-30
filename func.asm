# Funções

.macro	PUSH
	sw	$ra, 0($sp)	#salva o $ra no end. de mem. do sp
	sw	$a0, -4($sp)	#salva os prox. reg. nas posições livres
	sw	$a1, -8($sp)
	sw	$a2, -12($sp)
	sw	$a3, -16($sp)
	sw	$s0, -20($sp)
	sw	$s1, -24($sp)
	sw	$s2, -28($sp)
	sw	$s3, -32($sp)
	sw	$s4, -36($sp)
	sw	$s5, -40($sp)
	sw	$s6, -44($sp)
	sw	$s7, -48($sp)
	addiu	$sp, $sp, -52
	
.end_macro

.macro	POP
	addiu	$sp, $sp, 52	#onde o ponteiro deve ficar depois da desalocação
	lw	$ra, 0($sp)	#restaura o $ra no end. de mem. do sp
	lw	$a0, -4($sp)	#restaura os prox. reg.
	lw	$a1, -8($sp)
	lw	$a2, -12($sp)
	lw	$a3, -16($sp)
	lw	$s0, -20($sp)
	lw	$s1, -24($sp)
	lw	$s2, -28($sp)
	lw	$s3, -32($sp)
	lw	$s4, -36($sp)
	lw	$s5, -40($sp)
	lw	$s6, -44($sp)
	lw	$s7, -48($sp)
	
.end_macro


.data

.text
	addiu	$a0, $zero, 42
	addiu	$a1, $zero, 10
	jal	FUNC1	#chama a função, $ra recebe endereço da próxima instrução e pula para FUNC1
	
	addu $a0, $zero, $v0
	addiu $v0, $zero, 1
	syscall
	
	#return0
	addiu	$v0, $zero, 10
	syscall
	
FUNC1: 	PUSH
	add	$v0, $a0, $a1	#$a0 + $a1 e seta o valor de retorno no regist. de retorno
	POP
	jr	$ra	#salta de volta para a próxima instrução depois do chamado da função
