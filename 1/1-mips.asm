	.text	
main:	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb $t0 , n
	
	move $s0 , $zero    ## s0 is bl
	
cont1:
	lb $t0 , n
	beq $s0 , $t0 , exit_from_for1
	
	li $s1 , 0     ## s1 is dl

cont2:
	lb $t0 , n
	beq $s1 , $t0 , cont1_1
	
	lb $t0 , n
	mul $t0 , $s0 , $t0
	add $t0 , $t0 , $s1
	move $s2 , $t0
	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	 
	sb $t0 , matrix($s2)
	
	addi $s1 , $s1 , 1
	j cont2

cont1_1:
	addi $s0 , $s0 , 1
	j cont1

exit_from_for1:
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb $t0 , s
	 	 	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb $t0 , r
		
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
		
	sb $t0 , c
	
	# call function 1
	j function1
	
	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb $t0 , r
		
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
		
	sb $t0 , c
	
	#call function 2
	j function2
	
exit:
		
	li $v0, 10
    	syscall
	


function1:
	lb $t0 , s
	addi $t0 , $t0 , -1
	sb $t0 , s_minus     
	lb $t0 , r
	addi $t0 , $t0 , -1
	sb $t0 , r_minus
	
	li $s0 , 0   # s0 is bl
f1_for1:
	lb $t0 , n
	beq $s0 , $t0 , f1_cont1
	
	lb $t0 , n
	mul $t0 , $s0 , $t0
	
	lb $t1 , s_minus
	add $t0 , $t1 , $t0
	
	lb $s1 , matrix($t0)   # s1 is dl
	move $t0 , $s1
	lb $t1 , c
	mul $s1 , $t0 , $t1
	
	lb $t0 , n
	mul $t0 , $t0 , $s0
	lb $t1 , r_minus
	add $t0 , $t0 , $t1
	lb $t2 , matrix($t0)
	add $t2 , $s1 , $t2
	sb $t2 , matrix($t0)
	
	addi $s0 , $s0 , 1
	j f1_for1
	
f1_cont1:
	
	#call print_matrix
	j print_matrix
	
	li $v0, 10
    	syscall
	
########################################### end of function1

function2:     
	lb $t0 , r
	addi $t0 , $t0 , -1
	sb $t0 , r_minus
	
	li $s0 , 0   # s0 is bl
f2_for1:
	lb $t0 , n
	beq $s0 , $t0 , f2_cont1
	
	lb $t0 , n
	mul $t0 , $s0 , $t0
	
	lb $t1 , s_minus
	add $t0 , $t1 , $t0
	
	lb $s1 , matrix($t0)   # s1 is dl
	move $t1 , $t0
	move $t0 , $s1
	lb $t1 , c
	mul $s1 , $t0 , $t1
	
	sb $s1 , matrix($t1)

	addi $s0 , $s0 , 1
	j f2_for1
	
f2_cont1:
	
	#call print_matrix
	j print_matrix
	
	li $v0, 10
    	syscall	

##################################### end of function2


print_matrix:
	
	li $s0 , 0    ## s0 is bl
pm_cont2:
	lb $t0 , n
	beq $s0 , $t0 , pm_exit_from_for1
	
	li $s1 , 0    ## s1 is cl
	
pm_cont3:
	lb $t0 , n
	beq $t0 , $s1 , pm_cont2_1
	
	mul $t0 , $t0 , $s0
	add $t0 , $t0 , $s1
	lb $t0 , matrix($t0)
	
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	# print a space
	
	addi $s1 , $s1 , 1
	j pm_cont3
pm_cont2_1:
	#print a new line
	
	addi $s0 , $s0 , 1
	j pm_cont2

pm_exit_from_for1:
	
	li $v0, 10
    	syscall	
	
################################# end of print_matrix	
	.data
n:
	.byte 0  
matrix:
	.space 1000
c:
	.byte 0
r:
	.byte 0
s:
	.byte 0
r_minus:
	.byte 0
s_minus:
	.byte 0
