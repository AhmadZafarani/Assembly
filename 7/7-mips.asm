	.text	
main:	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb  $t0 , n
	move $s1 , $t0  ## s1 is cl
	
cont1:
	move $a0 , $s1
	jal is_prime # call procedure 
		     #result is in $v0
	
	bne $v0 , 1 , cont2
	
	la $a0 , lose_msg
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall
	
	li $v0, 10  # exit
	syscall
	
	
cont2:
	#add 3 to $t1
	addi $s1 , $s1 , 3
	move $a0 , $s1
	jal is_prime # call procedure 
		     #result is in $v0
	bne $v0 , 1 , cont3
	
	la $a0 , hop_msg
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall
		
	j cont4


cont3:
	move $t0 , $s1
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall


cont4:
	move $t2 , $s1
	
	#print a newline
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall
        
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
		
	move $s1 , $t0
	addi $t0 , $t0 , -3
	beq $t2 , $t0 , cont1
	
	la $a0 , lose_msg
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall
				
	
	
	li $v0, 10  # exit
	syscall



is_prime:	 #the main register is t1
	addi	$t0, $zero, 2				# int x = 2
	
is_prime_test:
	slt	$t1, $t0, $a0				# if (x > num)
	bne	$t1, $zero, is_prime_loop		
	addi	$v0, $zero, 1				# It's prime!
	jr	$ra						# return 1

is_prime_loop:						# else
	div	$a0, $t0					
	mfhi	$t3						# c = (num % x)
	slti	$t4, $t3, 1				
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	add	$v0, $zero, $zero				# its not a prime
	jr	$ra							# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1				# x++
	j	is_prime_test		
	

	li $t0, 3
	jr $ra # return
	
	
		
		
	.data
arr:
	.space 400
n:
	.byte 0  
previous_n:
	.byte 0
lose_msg:
	.asciiz "You Lose :P"
hop_msg:
	.asciiz "hop"
number_of_line:
	.byte 0