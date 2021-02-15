include 'emu8086.inc'

.MODEL SMALL
.STACK 100H
.DATA                 
    n Db ?
    matrix Db 100 dup ?
    linefeed db 13, 10, "$" 
    c Db ?
    r Db ?
    s Db ?
    s_minus Db ?
    r_minus Db ?
    
    
    
.CODE
  
    MOV AX , @DATA  
    MOV DS , AX
    

     
    call scan_num  ; scan the 4 digit decimal number
    
   ; new line
    mov ah, 09
    mov dx, offset linefeed
    int 21h    
        
    
    mov n , cl   
    
    
    
    mov bl , 0         ;prepare array ---> get numbers and make array

cont1:
    cmp bl , n
    je exit_from_for1
    mov dl , 0       
    
cont2:
    cmp dl , n
    je cont1_1
    
    mov al , n
    mul bl
    mov dh , 00h
    add ax , dx
    mov si , ax
    call scan_num
    mov matrix[si] , cl 
    
    inc dl
    jmp cont2
    
    
cont1_1:
    inc bl
    jmp cont1
    
    
    
    
exit_from_for1:    
    ;using function1    
    call scan_num
    mov s , cl
    
    call scan_num
    mov r , cl
    
    call scan_num
    mov c , cl
    
    call function1
    
    
    ;using function2
    call scan_num
    mov r , cl
    
    call scan_num
    mov c , cl
    
    call function2       
    

       
    hlt
  
  


function1 proc
    mov bl , s             ;set s_minus and r_minus
    mov s_minus , bl              
    mov bl , r                    
    mov r_minus , bl
    dec s_minus
    dec r_minus   
           
    mov bl , 0
    
f1_for1:                   ;loop
    cmp bl , n
    je f1_cont1
    
    mov al , n
    mul bl
    add al , s_minus
    mov si , ax
    mov dl , matrix[si]
    
    mov al , dl
    mul c
    
    mov dl , al
 
    mov al , n
    mul bl
    add al , r_minus
    mov si , ax
    add matrix[si] , dl 
    
    inc bl
    jmp f1_for1
    
    
    
    
f1_cont1:       
    call print_matrix
    ret                   
     
    
function1 endp    


         
         
         
         
function2 proc
    mov bl , r            ;set r_minus
    mov r_minus , bl
    dec r_minus   
    
    mov bl , 0

f2_for1:                  ;loop
    cmp bl , n
    je f2_cont1
    
    mov al , n
    mul bl
    add al , r_minus
    mov si , ax
    mov dl , matrix[si]
    
    mov al , dl
    mul c
    
    mov dl , al
    
    mov matrix[si] , dl 
    
    inc bl
    jmp f2_for1
    
    
    
    
f2_cont1:    
         
    call print_matrix
    ret
        
     
    
function2 endp    




print_matrix proc 
    
    ;new line
    call pthis
    db 13 , 10 , 0
    
    mov bl , 0 

pm_cont2:
    cmp bl , n
    je pm_exit_from_for1
    mov cl , 0
    
pm_cont3:                        ;print matrix
    cmp cl , n
    je pm_cont2_1
    
    mov al , n
    mul bl
    mov ch , 00h
    add ax , cx
    mov si , ax
    
    mov al , matrix[si]
    mov ah , 00h
    call print_num
    call printSpace      
    
    inc cl
    jmp pm_cont3
    
    
pm_cont2_1:
    ;new line
    call pthis
    db 13 , 10 , 0
     
    inc bl
    jmp pm_cont2
    
    

pm_exit_from_for1:
    ret
    
print_matrix endp

    
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM 
    DEFINE_PRINT_NUM_UNS
    DEFINE_PRINT_STRING
    DEFINE_PTHIS

printSpace:
    mov dl, ' '
    mov ah, 2
    int 21h
    ret    
    
    
          
END 
