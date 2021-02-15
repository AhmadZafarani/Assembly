; YA ZAHRA

include emu8086.inc
space equ 32
open_par equ 40
close_par equ 41
zero equ 48
nine equ 57
jame equ 43
tafriq equ 45
zarb equ 42
taqsim equ 47

data segment
    oe db "OVERFLOW ERROR!",0
    wpe db "WRONG PRANTHISES ERROR!",0
    dbze db "DIVIDE BY ZERO ERROR!",0
    numbers_sp dw offset numbers
    ops_sp dw offset ops
    numbers dw 128 dup(0)
    ops db 128 dup(0)
    input db 100 dup(0)
    num_last_char_met_address dw offset num
    num db 100 dup(0)
    first dw ?
    second dw ?
    operand db ?
    iHP_op1 db ?
    iHP_op2 db ?
    iHP_res db ?
    temp dw ?
    ten dw 10
    opened_pars dw 0
ends

stack segment
    dw   128  dup(0)
ends

;=================================================

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    mov word ptr[numbers_sp], offset numbers
    mov word ptr[ops_sp], offset ops
    
    lea di, input
    mov dx, 100
    call GET_STRING
    PUTC 10
    PUTC 13
    call calculate

    return:
    mov ax, 4c00h ; exit to operating system.
    int 21h
    
;=======================================

    calculate proc near             
        
        mov bx, 0                   ;bx = i
        lea si, input               ;si = input
        for1:
        
            mov al, byte ptr[si+bx]  ;al = c
            cmp al, space            ;if c == ' ': continue
            je cont_for1             
            
            cmp al, zero
            jl else1
            cmp al, nine             ;if c isDigit
            jg else1
                
                mov di, word ptr[num_last_char_met_address]  
                mov byte ptr[di], al                            ;num = num + c
                
                cmp byte ptr[si+bx+1], 0
                je if1
                cmp byte ptr[si+bx+1], zero             ;i == s.length - 1 || !isDigit(s.charAt(i + 1))
                jl if1
                cmp byte ptr[si+bx+1], nine            
                jg if1
                
                inc di        
                mov word ptr[num_last_char_met_address], di    
                jmp cont_for1:
                    
                    
                    if1:
                    mov word ptr[num_last_char_met_address], offset num
                    mov ah, 0
                    push ax                 ;parseInt the num
                    mov cx, 0               ;result
                    mov word ptr[temp], 1               ;power
                    
                        my_for1:
                        mov ah, 0    num
                        mov al, byte ptr[di]
                        sub al, zero
                        mul word ptr[temp]
                        add cx, ax
                        mov ax, word ptr[temp]
                        mul word ptr[ten]
                        mov word ptr[temp], ax
                        
                        mov byte ptr[di], 0             ;simultaniuosly make num = ""
                        dec di
                        cmp di, offset num
                        jge my_for1
                        
                    pop ax
                    
                    mov di, word ptr[numbers_sp]
                    mov word ptr[di], cx
                    add word ptr[numbers_sp], 2         ;numbers.push(cx)
                    
            
                jmp cont_for1
            else1:
            cmp al, open_par
            jne else2
                inc word ptr[opened_pars]
                
                mov di, word ptr[ops_sp]
                mov byte ptr[di], al                    ;ops.push(al)
                add word ptr[ops_sp], 1
                
                jmp cont_for1
            else2:
            cmp al, close_par                        
            jne else3
                dec word ptr[opened_pars]
                cmp word ptr[opened_pars], 0
                jl err_par
                
                while2:
                    sub word ptr[numbers_sp], 2
                    mov di, word ptr[numbers_sp]
                    mov cx, word ptr[di]
                    mov word ptr[second], cx             ;second = numbers.pop()
                    mov word ptr[di], 0
                    
                
                    sub word ptr[numbers_sp], 2
                    mov di, word ptr[numbers_sp]
                    mov cx, word ptr[di]
                    mov word ptr[first], cx              ;first = numbers.pop()
                    mov word ptr[di], 0
                    
                    
                    dec word ptr[ops_sp]
                    mov di, word ptr[ops_sp]             ;operand = ops.pop()
                    mov cl, byte ptr[di]
                    mov byte ptr[operand], cl
                    mov byte ptr[di], 0          
                  
                             
                    call operation
                    
                    mov di, word ptr[ops_sp]        
                    cmp byte ptr[di-1], open_par
                    jne while2
               
                dec word ptr[ops_sp]
                mov di, word ptr[ops_sp]           ;ops.pop()
                mov byte ptr[di], 0
                                    
                
                jmp cont_for1
            else3:
                                                   ;if...
                    
            cmp word ptr[ops_sp], offset ops 
            je then1                               ;ops not empty
         
            
            ;and... 
            mov di, word ptr[ops_sp]
            mov byte ptr[iHP_op1], al
            mov cl, byte ptr[di-1]
            mov byte ptr[iHP_op2], cl
            call isHigherPriority                  ;isHigherPriority
            cmp iHP_res, 0
            je then1
                   
                ;while3:
                sub word ptr[numbers_sp], 2
                mov di, word ptr[numbers_sp]
                mov cx, word ptr[di]
                mov word ptr[second], cx            ;second = numbers.pop()
                mov word ptr[di], 0
                
            
                sub word ptr[numbers_sp], 2
                mov di, word ptr[numbers_sp]
                mov cx, word ptr[di]
                mov word ptr[first], cx             ;first = numbers.pop()
                mov word ptr[di], 0
                
                
                dec word ptr[ops_sp]
                mov di, word ptr[ops_sp]
                mov cl, byte ptr[di]                 ;operand = ops.pop()
                mov byte ptr[operand], cl
                mov byte ptr[di], 0
                                
                         
                call operation
                jmp else3    
                
            then1:
            mov di, word ptr[ops_sp]
            mov byte ptr[di], al                    ;ops.push(al)
            add word ptr[ops_sp], 1
            
        cont_for1:
        inc bx
        cmp byte ptr[si+bx], 0      
        jne for1
        
        cmp word ptr[opened_pars], 0
        jne err_par
        
        
        cmp word ptr[ops_sp], offset ops 
        je end_while1
        while1:
        sub word ptr[numbers_sp], 2
        mov di, word ptr[numbers_sp]
        mov cx, word ptr[di]
        mov word ptr[second], cx             ;second = numbers.pop()
        mov word ptr[di], 0
        
    
        sub word ptr[numbers_sp], 2
        mov di, word ptr[numbers_sp]
        mov cx, word ptr[di]
        mov word ptr[first], cx              ;first = numbers.pop()
        mov word ptr[di], 0
        
        
        dec word ptr[ops_sp]
        mov di, word ptr[ops_sp]             ;operand = ops.pop()
        mov cl, byte ptr[di]
        mov byte ptr[operand], cl
        mov byte ptr[di], 0
                        
                 
        call operation
            
        
        cmp word ptr[ops_sp], offset ops 
        jne while1
        
        end_while1:
        mov di, word ptr[numbers_sp]
        mov ax, word ptr[di-2]
        call PRINT_NUM
        ret
        
        err_par:
        lea si, wpe
        call PRINT_STRING
        ret    
    endp
    
    operation proc near
        push cx
        
        cmp byte ptr[operand], jame
        jne case1
        mov cx, word ptr[second]
        add word ptr[first], cx              ;+
        pushf
        mov di, word ptr[numbers_sp]
        mov cx, word ptr[first]
        mov word ptr[di], cx 
        add word ptr[numbers_sp], 2          ;numbers.push()
        popf
        jmp last_check
         
         
        case1:
        cmp byte ptr[operand], tafriq
        jne case2
        mov cx, word ptr[second]             ;-
        sub word ptr[first], cx
        pushf
        mov di, word ptr[numbers_sp]
        mov cx, word ptr[first]
        mov word ptr[di], cx
        add word ptr[numbers_sp], 2          ;numbers.push()
        popf
        jmp last_check
        
        
        case2:
        cmp byte ptr[operand], zarb
        jne case3
        
        push ax
        push dx
        
        mov cx, word ptr[second]            ;* 
        mov ax, word ptr[first]
        mul cx 
        pushf
        mov di, word ptr[numbers_sp]
        mov word ptr[di], ax
        add word ptr[numbers_sp], 2         ;numbers.push()
        popf 
        
        pop dx
        pop ax
        
        jmp last_check
        
        
        case3:
        cmp word ptr[second], 0
        je dz
        push ax
        push dx
        
        mov dx, 0
        mov cx, word ptr[second]
        mov ax, word ptr[first]
        div cx
        pushf
        
        mov di, word ptr[numbers_sp]        ;/
        mov cx, word ptr[first]
        mov word ptr[di], ax
        add word ptr[numbers_sp], 2         ;numbers.push()
        popf
        
        pop dx
        pop ax
       
        
        last_check:
        jo ofe
        pop cx
        ret
        ofe:
        lea si, oe
        call PRINT_STRING
        jmp return
        dz:
        lea si, dbze
        call PRINT_STRING
        jmp return    
    endp
    
    isHigherPriority proc near
        cmp byte ptr[iHP_op2], open_par
        je false
        cmp byte ptr[iHP_op2], close_par
        je false
        
             
        cmp byte ptr[iHP_op1], zarb
        je next_condition
        cmp byte ptr[iHP_op1], taqsim
        jne true
        
        next_condition:
        cmp byte ptr[iHP_op2], jame
        je false
        cmp byte ptr[iHP_op2], tafriq
        jne true 
        
        
        false:
        mov byte ptr[iHP_res], 0
        ret
        
        true:
        mov byte ptr[iHP_res], 1
        ret    
    endp
    
;=======================================    
    
ends
DEFINE_GET_STRING
DEFINE_PRINT_NUM_UNS
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
end start ; set entry point and stop the assembler.
