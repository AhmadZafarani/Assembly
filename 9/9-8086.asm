include 'emu8086.inc'


.MODEL SMALL
.STACK 100H
.DATA                 
    n Db ?
    str db 1000 dup (?)
    max_length db 1
    start db 0
    len db ?
    low db ?
    high db 0

    
.CODE
  
    MOV AX , @DATA  
    MOV DS , AX
    
    
    call scan_num
    mov bl , cl

   
    
    ;new line
    call pthis
    db 13 , 10 , 0   


    mov     cx, 100
    mov     dx, offset str        ;get string from input with procedure
    call    getstr
 
     
    ;new line
    call pthis
    db 13 , 10 , 0
    
    mov len , bl                   ;initialize
    mov start , 00h                 
    mov max_length , 01h
    mov bl , 01h                       
 
    
cont1:              ;first while
    
    cmp bl , len
    je exit
    
    
    mov low , bl    
    dec low
    mov high , bl  
    
    
cont2:              ;while (low >= 0 && high < len && str[low] == str[high])
                    ;first while in first while. Find longest palindrome string with even length and center point as bl and bl-1
    cmp low , 0     ;1
    jb cont3
                    ;2
    mov cl , len
    cmp high , cl
    jae cont3
    
    lea di , str    ;3
    mov si , di
    mov al , high
    mov ah , 00h
    dec ax
    add si , ax 
    mov cl , str[si]
    mov si , di
    mov al , low
    mov ah , 00h
    dec ax
    add si , ax
    mov ch , str[si]
    cmp ch , cl
    jne cont3
    
 
    
                      ;first if in second while
    mov al , high
    sub al , low
    inc al
    cmp al , max_length
    jbe cont2_1
    mov ah , low
    mov start , ah     ;set start index   
    mov max_length , al
    
    
cont2_1:
    
    dec low
    inc high   
    jmp cont2
    
cont3:

    mov low , bl
    dec low
    mov high , bl
    inc high
    
    
cont5:
    cmp low , 0        ;second while in first while 
    jb cont4           ;same as first while in first while. Find longest palindrome string with odd length and center point as bl-1 and bl+1 
    
    mov cl , len
    cmp high , cl
    jae cont4
    
    lea di , str
    mov si , di
    mov al , high
    mov ah , 00h
    dec ax
    add si , ax
    mov cl , str[si]
    mov si , di
    mov al , low
    mov ah , 00h
    dec ax
    add si , ax
    mov ch , str[si]
    cmp ch , cl
    jne cont4
    
    
    
                          ;first if in third while
    mov al , high
    sub al , low
    inc al
    cmp al , max_length
    jbe cont3_1
    mov ah , low
    mov start , ah         ;set start index
    mov max_length , al
      

    
cont3_1:
    
    dec low
    inc high
    jmp cont5
    
    
    
cont4:
    
    inc bl
    jmp cont1    
    
    
    
    
    
  
exit:

    mov al , start
    mov ah , 00h
    call print_num 
    
    hlt
      
        
  
    
    
getstr      proc                 ; get string from input

    ; preserve used register
    push    ax
    push    bx
    push    si

    ; si used as base address
    mov     si, dx

    ; bx used as index to the base address
    mov     bx, 0
             

    ; It is a loop                      
L11:        
    ; read next character
    mov     ah, 1
    int     21h

    cmp     al, 13 ; return character
    jz      L12

    ; save the read character in buffer.
    mov     [si][bx], al

    ; next index of buffer
    inc     bx

L12:
    loopnz  L11

    ; bx contains the length of string.
    ; save it in cx                          
    mov     cx, bx

    ; append a sequence of return, 
    inc     bx
    mov     [si][bx], 13                                                                  

    ; new-line and                               
    inc     bx
    mov     [si][bx], 10                                                                  

    ; '$' character to the string          
    inc     bx
    mov     [si][bx], '$'                                                                  

    ; recover used register          
    pop     si
    pop     bx
    pop     ax
    ret
getstr endp
    
    
    
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM 
    DEFINE_PRINT_NUM_UNS
    DEFINE_PRINT_STRING
    DEFINE_PTHIS
    
    
    
    
    
          
END 
