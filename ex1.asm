#DESC: traducao de um programa em c para asm
#
#05.08.2021
#
#int main(void){
#  int x = 42;
#  int y;
#  float f,pi = 3.1415;
#  
#  printf("Digite um int: ");
#  scanf("%d", &y);
#  
#  printf("A soma de 42 + %d eh: %d\n", y, (x+y) );
#  return 0
#  }

.data
	x:	.word		42
	y:	.space		4
	pi:	.float		3.1415
	f:	.space		4
	p:	 .space		4
	v:	 .space		40
	v2:	 .word		1,2,3,4,5,6,7
       str:	 .asciiz		"Digite um int: "
       
       str21:   .asciiz		"A soma de 42 + "
       str22:   .asciiz		" eh "
       str23:	 .asciiz 	"\n"

.text
	#printf("digite um int: ");
	addiu	  $v0, $zero, 4      # imprimir string
	la	  $a0, str
	syscall
	
	# scanf("%d", &y);
	addiu	  $v0, $zero, 5      # le inteiro
	syscall
	la	  $at, y             # salva endereço de y
	sw	  $v0, 0($at)        # a memória do endereço at recebe o que está em v0
	addu	  $s0, $zero, $v0    # salva inteiro lido em s0
	
	#printf("A soma de 42 + %d eh %d\n", y, (y+x));
	# "A soma de 42 + "
	addiu    $v0, $zero, 4
	la	 $a0, str21		# printa str21
	syscall
	
	# " (valor de y) "
	addiu    $v0, $zero, 1
	addu	 $a0, $zero, $s0	# printa o y que está no s0
	syscall
	
	# " eh "
	addiu    $v0, $zero, 4
	la	 $a0, str22		# printa str22
	syscall
	
	la	$t0, x			# coloca x em um registrador temporário
	lw	$s1, 0($t0)		# s1 recebe o que estiver na memória do endereço de t0
	
	addu 	$t0, $s0, $s1		# t0 recebe x + y (reutilizamos o registrador t0)
	
	# " (valor de x + y)
	addiu    $v0, $zero, 1
	addu	 $a0, $zero, $t0		#printa o resultado da soma que está no t0
	syscall
	
	# " \n "
	addiu    $v0, $zero, 4
	la	 $a0, str23		# printa str23
		
	# return 0
	addiu	  $v0, $zero, 10
	syscall	
