	.text	
main:	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb  $t0 , n
	
		
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb  $t0 , m
	
	
	lb $t0 , n
	addi $t0 , $t0 , 1
	sb $t0 , n_plus
	
	lb $t0 , m
	addi $t0 , $t0 , 1
	sb $t0 , m_plus
	
	
	lb $t0 , m  # t0 is bl
		    # t1 is cl
	
cont1:
	########
	beq $t0 , -1 , exit_from_for1
	li $t1 , 0
	
cont2:
	lb $t2 , n
	bgt $t1 , $t2 , cont1_1
	
	lb $t2 , n_plus
	mult $t0 , $t2
	mflo $t3
	add $t3 , $t3 , $t1
	sb $zero , arr($t3)
	
	addi $t1 , $t1 , 1
	j cont2

cont1_1:
	addi $t0 , $t0 , -1
	j cont1

exit_from_for1:
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	
	sb $t0 , o
	
	li $s0 , 0  # s0 is bl
	
get_obstacle:
	lb $s1 , o
	beq $s0 , $s1 , cont3
	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	sb $t0 , x
	
	addi $v0, $zero, 5 #selecting the corresponding service
	syscall
	add $t0, $zero, $v0 #moving the integer number to $t0
	sb $t0 , y
	
	lb $t0 , y
	lb $t1 , n_plus
	mult $t0 , $t1
	mflo $t0
	lb $t1 , x
	add $t0 , $t0 , $t1
	li $t1 , 1
	sb $t1 , arr($t0)
	
	addi $s0 , $s0 , 1
	j get_obstacle

cont3:
	sb $zero , a
	sb $zero , b
	
main_while:

	#print a newline
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall
        
	lb $t0 , n
	lb $t1 , a
	bne $t0 , $t1 , cont4
	lb $t0 , m
	lb $t1 , b
	bne $t0 , $t1 , cont4
	
	
	
	j final
	
	
	
	#
cont4:
	addi $v0, $zero, 12 #selecting the corresponding service
	syscall
	
	move $s0 , $v0
	sb $s0 , c
	
	lb $t0 , u_byte
	bne $s0 , $t0 , cond2
	
	lb $t0 , b
	addi $t0 , $t0 ,1
	sb $t0 , b
	
	lb $t0 , n_plus
	lb $t1 , b
	mul $t2 , $t0 , $t1
	lb $t0 , a
	add $t2 , $t2 , $t0
	lb $t1 , arr($t2)
	bne $t1 , 1 , cond1_1
	
	lb $t0 , b
	addi $t0 , $t0 , -1
	sb $t0 , b
	
	la $a0 , obstacle_msg 
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall
	
	

	j main_while
	
	
cond1_1:
	#print a newline
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall

	lb $t0 , a
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	la  $a0, space      # print space
    	li  $v0, 4          
    	syscall
	
	
	lb $t0 , b
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	j main_while
	


cond2:

	lb $t0 , d_byte
	bne $s0 , $t0 , cond3
	
	lb $t0 , b
	addi $t0 , $t0 ,-1
	sb $t0 , b
	
	lb $t0 , n_plus
	lb $t1 , b
	mul $t2 , $t0 , $t1
	lb $t0 , a
	add $t2 , $t2 , $t0
	lb $t1 , arr($t2)
	bne $t1 , 1 , cond2_1
	
	lb $t0 , b
	addi $t0 , $t0 , 1
	sb $t0 , b
	
	la $a0 , obstacle_msg 
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall

	j main_while
	
	
cond2_1:
	#print a newline
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall


	lb $t0 , a
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	la  $a0, space      # print space
    	li  $v0, 4          
    	syscall
	
	
	lb $t0 , b
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	j main_while
	

cond3:
	lb $t0 , r_byte
	bne $s0 , $t0 , cond4
	
	lb $t0 , a
	addi $t0 , $t0 ,1
	sb $t0 , a
	
	lb $t0 , n_plus
	lb $t1 , b
	mul $t2 , $t0 , $t1
	lb $t0 , a
	add $t2 , $t2 , $t0
	lb $t1 , arr($t2)
	bne $t1 , 1 , cond3_1
	
	lb $t0 , a
	addi $t0 , $t0 , -1
	sb $t0 , a
	
	la $a0 , obstacle_msg 
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall

	j main_while
	
	
cond3_1:
	#print a newline
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall
	
	lb $t0 , a
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	la  $a0, space      # print space
    	li  $v0, 4          
    	syscall
	
	
	lb $t0 , b
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	
	j main_while
	

cond4:
	lb $t0 , l_byte
	bne $s0 , $t0 , cond2
	
	lb $t0 , a
	addi $t0 , $t0 , -1
	sb $t0 , a
	
	lb $t0 , n_plus
	lb $t1 , b
	mul $t2 , $t0 , $t1
	lb $t0 , a
	add $t2 , $t2 , $t0
	lb $t1 , arr($t2)
	bne $t1 , 1 , cond4_1
	
	lb $t0 , a
	addi $t0 , $t0 , 1
	sb $t0 , a
	
	la $a0 , obstacle_msg 
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall

	j main_while
	
	
cond4_1:
	#print a newline
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall

	lb $t0 , a
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	la  $a0, space      # print space
    	li  $v0, 4          
    	syscall
	
	lb $t0 , b
	addi $v0, $zero, 1 #selecting the corresponding service
	add $a0, $zero, $t0 #moving the integer number to $a0
	syscall
	
	j main_while
	









final:
	la $a0 , final_msg 
	addi $v0, $zero, 4 #selecting the corresponding service
	syscall
	
	li $v0, 10
    	syscall
	
	
		
		
	.data
n:
	.byte 0  
m:
	.byte 0
n_plus:
	.byte 0
m_plus:
	.byte 0
obstacle_msg:
	.asciiz "cant move, obstacle ahead"
final_msg:
	.asciiz "reached treasure!"
o:
	.byte 0
arr:
	.space 400
n_of_e_in_row:
	.byte 0
a:
	.byte 0
b:
	.byte 0
c:
	.byte 0
x:
	.byte 0
y:
	.byte 0
temp:
	.byte 0
u_byte:
	.byte 'u'
d_byte:
	.byte 'd'
r_byte:
	.byte 'r'
l_byte:
	.byte 'l'
space:  
	.asciiz " "