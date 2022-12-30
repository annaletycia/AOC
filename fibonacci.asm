#fibonacci.asm

# F_n = 1 , 1 , 2 , 3 , 5 , 8 , ....
#       1   2   3   4   5   6        n 
#
# int main(void){
#   int n,i,anterior, atual;
#
#
#   printf("Digite o num de termos:");
#   scanf("%d", &n);
#   if(n<=0){
#     printf("o num de termos deve ser um inteiro positivo");
#     return 0; }
#	if((n ==1) || (n == 2)){    
#		printf("O fibonacci de %d eh: 1", n);
#		return 0;
#   }
#   anterior = 1;
#   atual = 1;
#   for(i = 3; i<=n; i++){
#   	tmp = atual;
#		atual = atual + anterior;
#		anterior = tmp;
#   }
#   printf("O fibonacci de %d eh: %d", n, atual); 
#}
# DDA 09.08.2021

.data
	# int n,i,anterior, atual;
	n:		.space	4
	i:		.space	4
	anterior:	.space	4
	atual:		.space	4
	str1:		.asciiz	"Digite o num de termos:"
	strerr:		.asciiz	"o num de termos deve ser um inteiro positivo"
	str21:		.asciiz	"O fibonacci de "
	str22:		.asciiz	" eh: 1"
	str31:		.asciiz	"O fibonacci de "
	str32:		.asciiz	" eh "
	
.text
	# printf("Digite o num de termos:");
	addiu	$v0, $zero, 4
	la	$a0, str1
	syscall
	
	#   scanf("%d", &n);
	addiu	$v0, $zero, 5  
	syscall			  # o resultado do scanf é armazenado no v0
	addu	$s0, $zero, $v0	  # s0 = n
	la	$t0, n		  # salva endereço de n em $t0
	sw	$s0, 0($t0)	  # a memória do endereço $t0 recebe o que está em v0 
	
	#   if(n<=0)   é equivalente a 0 >= n
	slt	$t0, $zero, $s0	  # se 0<n, t0 = 1. Senão t0 = 0.
	bne	$t0, $zero, SAI1  # compara se t0 é igual a zero, se sim, pula pra SAI1
				  # SAI1 possui endereço de memória igual ao endereço da próxima instrução a ser realizada

	# corpo do if
	# printf "o num de termos deve ser um inteiro positivo"
	addiu	$v0, $zero, 4
	la	$a0, strerr
	syscall
	j	EXIT            # pula o ELSE1, para não executar o código dele
	# corpo do if /

SAI1:	
#	if((n == 1) || (n == 2)){    
#		printf("O fibonacci de %d eh: 1", n);
#		return 0;
#   }		
	addiu		$t1, $zero, 1
	addiu		$t2, $zero, 2
	
	beq		$s0, $t1, IF2
	beq		$s0, $t2, IF2
	j		SAI2
IF2: #corpo do if
	addiu		$v0, $zero, 4
	la		$a0, str21
	syscall
	
	addiu		$v0, $zero, 1
	addu		$a0, $zero, $s0
	syscall
	
	addiu		$v0, $zero, 4
	la		$a0, str22
	syscall

	 #corpo do if /
SAI2:

	#for(i = 3; i<=n; i++){		#i <= n equiv. i < n+1 forall Z
	addiu	$s2, $zero, 3   		# i = 3
	addiu	$s3, $s0, 1		#s3 = n+1
	
FOR:	slt     $t7, $s2, $s3  		# se s2<s3, t7=1
	beq	$t7, $zero, SAI1		# se forem iguais, o for é finalizado
	#corpo do for
	
	#corpo do for /
	addiu		$s2, $s2, 1
	j		FOR
	
EXIT:
	# return 0
	addiu	$v0, $zero, 10
	syscall
	
