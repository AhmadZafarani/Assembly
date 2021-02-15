include 'emu8086.inc'


.MODEL SMALL
.STACK 100H
.DATA                 
    n Db ?
    previous_n  Db ?
    number_of_line db 0
    linefeed db 13, 10, "$"
    
    
    
.CODE
  
    MOV AX , @DATA  
    MOV DS , AX
    

     
    call scan_num  ; scan the 4 digit decimal number
    
    ;new line
    mov ah, 09
    mov dx, offset linefeed
    int 21h    
    
    mov n , cl
 
    
cont1:
     
    call check_prime   ; if al == 1 : number is prime , else if al == 0 : number is not prime
    cmp al , 01h
    
    jne cont2
    
    call pthis
    db 13 , 10 , 'You Lose :P', 0
    hlt
    
    
cont2:

    ;add 3 to n
    mov al , 03h
    add cl , al
    
    call check_prime
    cmp al , 01h
    jne cont3
    
    ;print "hop"
    call pthis
    db 13 , 10 , 'hop' , 0 
    
    ;new line
    call pthis
    db 13 , 10 , 0

    jmp cont4
    

cont3:
    
    mov al , cl
    mov ah , 00h
    
    ;new line
    call pthis
    db 13 , 10 , 0
    
    call PRINT_NUM
    
    ;new line
    call pthis
    db 13 , 10 , 0
 
    
cont4:
    
    mov bl , cl
    
    call scan_num
           
    mov al , cl
    sub al , 03h
    
    cmp al , bl
    je cont1
    
    ;print "You Lose"
    call pthis
    db 13 , 10 , 'You Lose :P' , 0
    hlt 
       
    
check_prime PROC
    
   
    mov DS,AX

    mov al , cl 
    mov bl , 02h      ; The Dividing starts from 2 ---> BH is compare to 02H
    mov dx , 0        
    mov ah , 0        
    mov bh , 0

l1: 
    div bl
    cmp ah , 0      
    
    jne next
    
    inc bh      
    
    
    next:cmp bh , 01h  ;It is not a Prime
    
    je false        
    inc bl          
    mov ax , 0    
    mov dx , 0    
    mov al , cl      
    cmp bl , cl      
    jne l1          
    
true:
    mov al , 01h
    jmp exit
    
    
false: 
    
    mov al , 00h
    
 
exit:
    
    ret
    
    
check_prime ENDP
  
    hlt
  
  
 
    
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM 
    DEFINE_PRINT_NUM_UNS
    DEFINE_PRINT_STRING
    DEFINE_PTHIS
    
    
    
    
    
          
END 
