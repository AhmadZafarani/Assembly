include 'emu8086.inc'


.MODEL SMALL
.STACK 100H
.DATA
    arr db 100 dup(?)
    n Db ?
    n_plus Db ?
    n_minus Db ?
    state Db 1
    counter Db 0 
    end_flag db 0
    
    
    
.CODE
            
        
    call scan_num  ; scan the 4 digit decimal number
    
    ; to jump a line in screen
    mov ah,2
    mov bh ,00
    mov dh , 1
    int 10h  
        
    ;set n_plus and m_minus
    mov n  , cl
    inc cl
    mov n_plus , cl
    dec cl
    dec cl
    mov n_minus , cl
    inc cl
    xor bl , bl
    
    
    cmp n , 1           ; if n == 1 then print 1 and end program
    jne cont1
 
 
    mov ah , 00h   
    mov al , n
 
    call PRINT_NUM
    
    hlt  
 
            
cont1:
    
    cmp bl , n        ;prepare arr for program
    
    je  cont2
    
 
    inc bl     
    xor di , di
    mov bh , 00h
    add di , bx
    dec di  
    mov arr[di] , bl 
    jmp cont1
    
 
               
cont2:
         
    mov bl , n              ;initialize
    mov counter , bl
    mov state , 1
    mov end_flag , 0
    mov bl , 00h                       
    
    
    
    
cont3:

    xor si , si
    mov bh , 00h
    add si , bx
    cmp arr[si] , 00h
    jne cont4
    
    
    inc bl
    cmp bl , n
    jne cont3
    mov bl , 00h
    jmp cont3
      
      
    
cont4:
    
    cmp end_flag , 1       ; check if one element remains
    jne cont5 
        
    xor si , si
    mov bh , 00h
    add si , bx
    
    mov ah , 00h
    mov al , arr[si]
    call PRINT_NUM         ;print result and exit
    
    hlt  
         
    
    
    
cont5: 

    cmp state , 1
    jne cont6
    
    mov state , 0
    inc bl   
    cmp bl , n
    jne cont3
    mov bl , 00h
    jmp cont3
    
          
          
        
cont6:
    
    mov state , 1
    dec counter
    cmp counter , 1
    jne cont7
    mov end_flag , 1
    
    
    
    
cont7:
    xor si , si
    mov bh , 00h
    add si , bx
    
    mov arr[si] , 00h
    
    inc bl
    cmp bl , n
    jne cont3
    mov bl , 00h
    jmp cont3
    
    

    hlt
       
    
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM 
    DEFINE_PRINT_NUM_UNS
    
              
END      
