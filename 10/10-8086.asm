include 'emu8086.inc'


.MODEL SMALL
.STACK 100H
.DATA                 
    n Db ?
    m Db ?
    n_plus Db ?
    m_plus Db ?
    o db ?
    arr db 1000 dup (?)
    n_of_e_in_row db ?
    a Db ?
    b Db ?
    c Db ?
    x Db ?
    y Db ?
    temp Db ?
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
    
 
    call scan_num  ; scan the 4 digit decimal number
    
 
    ; new line
    mov ah, 09
    mov dx, offset linefeed
    int 21h    
    
    mov m , cl
   
     
    mov al , n
    inc al
    mov n_plus , al    ;initial n_plus
    
    mov al , m
    inc al
    mov m_plus , al    ;initial m_plus
    
    
    
    
    mov bl , m         ;prepare array

cont1:
    cmp bl , 0ffh
    je exit_from_for1
    
    mov cl , 0
cont2:
    cmp cl , n
    ja cont1_1
    
    mov al , n_plus
    mul bl
    mov ch , 00h
    add ax , cx
    mov si , ax
    mov arr[si] , 00h 
    
    inc cl
    jmp cont2
    
    
cont1_1:
    dec bl
    jmp cont1
    
    
    
    
exit_from_for1:    
        

    call scan_num
    ; new line
    mov ah, 09
    mov dx, offset linefeed
    int 21h
    mov o , cl

    mov bl , 0
    
get_obstacle:               ;set obstacles in arr with 1
    cmp bl , o
    je cont3
    
    call scan_num  
    
    ; new line
    mov ah, 09
    mov dx, offset linefeed
    int 21h    
   
    
    mov x , cl
    
    call scan_num
    ; new line
    mov ah, 09
    mov dx, offset linefeed
    int 21h
    
    mov y , cl
    
    mov al , n_plus
    mul y
    
    mov cl , x
    mov ch , 00h
    
    add ax , cx
    mov si , ax
    
    mov arr[si] , 01h
    
    inc bl
    jmp get_obstacle
    

cont3:

    mov a , 0
    mov b , 0
    

main_while:

    mov dl , n
    cmp a , dl
    jne cont4
    mov dl , m
    cmp b , dl
    jne cont4
    jmp final
    
    
    
cont4:
    
    MOV AH, 01H 
    INT 21H
    mov c , al 
    
    cmp c , 'u'
    jne cond2
    inc b
    
    mov al , n_plus
    mul b
    mov bl , a
    mov bh , 00h
    add ax , bx
    mov si , ax
    mov bl , arr[si]
    cmp bl , 01h
    jne cond1_1
    dec b
    call pthis
    db 13 , 10 , 'cant move, obstacle ahead' , 0
    ;new line
    call pthis
    db 13 , 10 , 0
    jmp main_while
    


cond1_1: 
    ;new line
    call pthis
    db 13 , 10 , 0
    mov al , a
    mov ah , 00h
    call print_num
    call printSpace
    mov al , b
    mov ah , 00h
    call print_num
    ;new line
    call pthis
    db 13 , 10 , 0   
    
        
cond2: 

    cmp c , 'd'
    jne cond3
    dec b
    
    mov al , n_plus
    mul b
    mov bl , a
    mov bh , 00h
    add ax , bx
    mov si , ax
    mov bl , arr[si]
    cmp bl , 01h
    jne cond2_1
    inc b
    call pthis
    db 13 , 10 , 'cant move, obstacle ahead' , 0
    ;new line
    call pthis
    db 13 , 10 , 0
    jmp main_while
    
    
cond2_1: 
    ;new line
    call pthis
    db 13 , 10 , 0
    mov al , a
    mov ah , 00h
    call print_num
    call printSpace
    mov al , b
    mov ah , 00h
    call print_num
    ;new line
    call pthis
    db 13 , 10 , 0
    
    
cond3: 

    cmp c , 'r'
    jne cond4
    inc a
    
    mov al , n_plus
    mul b
    mov bl , a
    mov bh , 00h
    add ax , bx
    mov si , ax
    mov bl , arr[si]
    cmp bl , 01h
    jne cond3_1
    dec a
    call pthis
    db 13 , 10 , 'cant move, obstacle ahead' , 0
    ;new line
    call pthis
    db 13 , 10 , 0
    jmp main_while
    
    
cond3_1: 
    ;new line
    call pthis
    db 13 , 10 , 0
    mov al , a
    mov ah , 00h
    call print_num
    call printSpace
    mov al , b
    mov ah , 00h
    call print_num
    ;new line
    call pthis
    db 13 , 10 , 0 
    
    
cond4: 

    cmp c , 'l'
    jne main_while
    dec a
    
    mov al , n_plus
    mul b
    mov bl , a
    mov bh , 00h
    add ax , bx
    mov si , ax
    mov bl , arr[si]
    cmp bl , 01h
    jne cond4_1
    inc a
    call pthis
    db 13 , 10 , 'cant move, obstacle ahead' , 0
    ;new line
    call pthis
    db 13 , 10 , 0
    jmp main_while
    
    
cond4_1: 
    ;new line
    call pthis
    db 13 , 10 , 0
    mov al , a
    mov ah , 00h
    call print_num
    call printSpace
    mov al , b
    mov ah , 00h
    call print_num
    ;new line
    call pthis
    db 13 , 10 , 0

    jmp main_while
       

final:      

    call pthis
    db 13 , 10 ,'reached treasure!'  , 0
    ;new line
    call pthis
    db 13 , 10 , 0
       
    
  
    hlt
  
  
 
    
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
