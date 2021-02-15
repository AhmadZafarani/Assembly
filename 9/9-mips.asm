	.text	
main:	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb  $t0 , n
	move $s0 , $t0  ## s0 is bl
	
	
	addi $v0 , $zero , 8
	la $a0 , str
	addi $a1 , $zero , 100
	syscall 
	###########
	###########
	###########
	#la $a0 , str
	#addi $v0, $zero, 4 #selecting the corresponding service
	#syscall

	sb $s0 , len
	sb $zero , start
	li $t0 , 1
	sb $t0 , max_length
	li $s0 , 1
	
cont1:
	lb $t0 , len
	beq $s0 , $t0 , exit
	
	move $t0 , $s0
	addi $t0 , $t0 , -1
	sb $t0 , low
	sb $s0 , high
	
cont2:
	lb $t0 , low
	blt $t0 , 0 , cont3
	
	lb $t1 , len
	lb $t2 , high
	bge $t2 , $t1 , cont3
	
	lb $t1 , low 
	lb $t2 , high
	lb $t3 , str($t1)
	lb $t4 , str($t2)
	bne $t3 , $t4 , cont3
	
	
	lb $t1 , high
	lb $t2 , low 
	sub $t1 , $t1 , $t2
	addi $t1 , $t1 , 1
	lb $t2 , max_length
	ble $t1 ,  $t2 , cont2_1
	lb $t2 , low
	sb $t2 , start
	sb $t1 , max_length
	
cont2_1:
	lb $t0 , low
	addi $t0 , $t0 , -1
	sb $t0 , low
	lb $t0 , high
	addi $t0 , $t0 , 1
	sb $t0 , high
	j cont2
cont3:
	sb $s0 , low
	lb $t0 , low
	addi $t0 , $t0 , -1
	sb $t0 , low
	sb $s0 , high
	lb $t0 , high
	addi $t0 , $t0 , 1
	sb $t0 , high
	
cont5:
	
	lb $t0 , low
	blt $t0 , 0 , cont4
	
	lb $t1 , len
	lb $t2 , high
	bge $t2 , $t1 , cont4
	
	lb $t1 , low 
	lb $t2 , high
	lb $t3 , str($t1)
	lb $t4 , str($t2)
	bne $t3 , $t4 , cont4
	
	
	lb $t1 , high
	lb $t2 , low 
	sub $t1 , $t1 , $t2
	addi $t1 , $t1 , 1
	lb $t2 , max_length
	ble $t1 ,  $t2 , cont3_1
	lb $t2 , low
	sb $t2 , start
	sb $t1 , max_length
	
cont3_1:
	lb $t0 , low
	addi $t0 , $t0 , -1
	sb $t0 , low
	lb $t0 , high
	addi $t0 , $t0 , 1
	sb $t0 , high
	j cont5

cont4:
	addi $s0 , $s0 , 1
	j cont1

	
		
exit:
	
	lb $t0 , start
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	li $v0, 10
    	syscall
	
	
		
		
	.data
n:
	.byte 0  
str:
	.space 400
max_length:
	.byte 0
start:
	.byte 0
len:
	.byte 0
low:
	.byte 0
high:
	.byte 0
