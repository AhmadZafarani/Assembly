	.text	
main:	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb  $t0 , n
	move $t1 , $t0  ## t1 is cl
	addi $t1 , $zero , 1
	sb $t1 , n_plus
	addi $t1 , $zero , -1
	addi $t1 , $zero , -1
	sb $t1 , n_minus
	addi $t1 , $zero , 1
	
	move $t2 , $zero     ## t2 is bl
	
	lb $t3 , n
	bne $t3 , 1 ,cont1
	
	li $t0 , 1
	
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	li	$v0, 10		# system call code for exit = 10
	syscall	
	
		
cont1:	                       # prepare array
	lb $t3 , n
	
	beq $t2 , $t3 , cont2
	
	
	addi $t2 , $t2 , 1
	li $t4 , 0           ## t4 is di
	addi $t4 , $t2 , -1  
	sb $t2 , arr($t4)
	j cont1

cont2:
	
	lb $t2 , n
	sb $t2 ,counter
	li $t5 , 1
	sb $t5 , state
	sb $zero , end_flag
	move $t2 , $zero
	
cont3:
	move $t4 , $zero    ## t4 is si
	add $t4 , $t2 , $zero
	lb $t3 , arr($t4)
	bne $t3 , 0 , cont4
	
	addi $t2 , $t2 , 1
	lb $t3 , n
	bne $t2 , $t3 , cont3
	move $t2 , $zero

cont4:
	lb $t3 , end_flag
	bne $t3 , 1 , cont5
	move $t4 , $zero  ## t4 is zero
	add $t4 , $t2 , $zero
	
	lb $t0 , arr($t4)
	
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	li	$v0, 10		# system call code for exit = 10
	syscall	
	
cont5:
	lb $t3 , state
	bne $t3 , 1 , cont6
	sb $zero , state
	addi $t2 , $t2 , 1
	lb $t3 , n
	bne $t2 , $t3 , cont3
	move $t2 , $zero
	j cont3

 cont6:
 	 li $t3 , 1
 	 sb $t3 , state
 	 lb $t3 , counter
 	 addi $t3 , $t3 , -1
 	 sb $t3 , counter
 	 bne $t3 , 1 , cont7
 	 li $t3 , 1
 	 sb $t3 , end_flag
 	 

cont7:
	move $t3 , $zero
	add $t3 , $t2 , $zero
	
	sb $zero , arr($t3)
	
	addi $t2 , $t2 , 1
	lb $t3 , n

	bne $t2 , $t3 , cont3
	move $t2 , $zero
	j cont3
	
		
	.data
arr:
	.space 400
n:
	.byte 0  
n_plus:
	.byte 0
n_minus:
	.byte 0
state:
	.byte 1
counter:
	.byte 0
end_flag:
	.byte 0
