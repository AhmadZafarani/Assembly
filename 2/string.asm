; YA REZA
 
include "emu8086.inc"
\n equ 10
r equ 114
c equ 99 
 
data segment
    snf db "substring not found!",0
    en dw ?
    command db 0, 0
    ei dw ?
    bi dw ?
    delta dw ?
    ei_address dw ?
    bi_address dw ?
    output_address dw ?
    input db 0
ends

stack segment
    dw   128  dup(0)
ends

print_new_line macro
    PUTC \n
    PUTC 13
endm print_new_line

;================================================

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    call SCAN_NUM
    print_new_line      ;get n
    inc cx
    mov [en], cx
    mov dx, cx
    lea di, input
    call GET_STRING
    print_new_line
    mov dx, 2
    lea di, command      ;get r or c
    call GET_STRING
    print_new_line
    lea di, input 
    
    call SCAN_NUM
    print_new_line 
    inc cx
    mov word ptr[ei], cx      ;get a 
    
    mov bx, word ptr[en]
    cmp word ptr[ei], bx      ; if substring length greater than string length: return!
    jg return
    
    cmp byte ptr[command], r
    jne cont
    
    call SCAN_NUM             ;get b 
    inc cx
    print_new_line
    mov word ptr[bi], cx
    
    add di, word ptr[en]                    ;get a string
    mov word ptr[ei_address], di
    mov dx, word ptr[ei]
    call GET_STRING
    print_new_line
    
    add di, [ei]                 ;get b string
    mov word ptr[bi_address], di
    mov dx, word ptr[bi]
    call GET_STRING
    print_new_line
    
    call replace
    jmp return 
                         
    cont:                ;count
    add di, word ptr[en]                    ;get a string
    mov word ptr[ei_address], di
    mov dx, word ptr[ei]
    call GET_STRING
    print_new_line
    
    call count
    
    return:
    mov ax, 4c00h ; exit to operating system.
    int 21h
    
;================================================        

    replace proc near
        mov bx, -1      ;bx = index
        mov ax, 0       ;ax = i
        mov cx, [ei]
        sub [en], cx    ;[en] -= [ei]   ***
        big_for:
        
            mov si, word ptr[ei_address]        
            push bx
            mov bx, ax
            mov dl, byte ptr[si] 
            cmp byte ptr[input+bx], dl          ;cmp [input+ax], [[ei_address]]
            pop bx
            jne next_if
            
            
            mov dx, 1                   ;dx = flag
            mov cx, 1                   ;cx = j
            for1:
            
                
                push si
                add si, cx                                 
                push bx
                lea bx, input
                add bx, ax
                add bx, cx
                push dx
                mov dh, 0
                mov dl, byte ptr[si]                     ;cmp byte ptr[input+ax+cx], byte ptr[[ei_address]+cx]
                sub dl, byte ptr[bx]
                mov bp, dx
                pop dx
                pop bx
                pop si
                
                cmp bp, 0
                jne not_fully_equal    
            
            inc cx
            mov bp, cx
            inc bp
            cmp bp, [ei]
            jl for1
            jmp next_if1
            
                     not_fully_equal:
                     mov dx, 0
                     jmp next_if1
               
            next_if1:
            cmp dx, 1
            jne next_if
                mov bx, ax
            
            
            next_if:
            cmp bx, -1
            je cont_for
            
                mov ax, bx                                ;ax = index
                mov di, word ptr[en]
                add di, word ptr[bi]        
                mov word ptr[delta], di                   ;di = delta
                mov di, word ptr[bi_address]              ; store...
                add di, word ptr[bi]
                mov word ptr[output_address], di
                
                mov bx, 0                                 ;bx = j
                mov si, word ptr[output_address]
                lea di, input
                mov cx, 0
                for2:
                                                          ;output[j] = input[j]
                    mov cl, byte ptr[di+bx]
                    mov byte ptr[si+bx], cl            
                    
                inc bx
                cmp bx, ax
                jl for2
                
                mov bx, ax                                  ;bx = k
                mov bp, ax
                add bp, word ptr[bi]
                dec bp
                mov di, word ptr[bi_address]
                for3:
                
                    push bx
                    sub bx, ax                              
                    mov cl, byte ptr[di+bx]                 
                    pop bx                                 
                    mov byte ptr[si+bx], cl    
                
                inc bx
                cmp bx, bp
                jl for3
                
                
                lea di, input                            
                add di, word ptr[ei]                         ;bx = l
                sub di, word ptr[bi]
                for4:
                
                    mov cl, byte ptr[di+bx]       ;output[l] = input[ l - [bi] + [ei] ]
                    mov byte ptr[si+bx], cl
                
                inc bx
                cmp bx, word ptr[delta]
                jl for4
                
                mov si, [output_address]
                call PRINT_STRING
                jmp return
        
        cont_for:
        inc ax
        cmp ax, [en]
        jle big_for
        
        lea si, snf
        call PRINT_STRING
        jmp return   
    endp
    
;----------------------------------------------
    
    count proc near
        mov cx, 0               ;cx = counter
        
        mov ax, word ptr[ei]
        sub word ptr[en], ax
        mov bx, 0               ;bx = i
        
        lea si, input
        mov di, word ptr[ei_address]
        for:
            mov al, byte ptr[di]
            cmp byte ptr[si+bx], al
            jne continue
            
            mov dx, 1               ;dx = flag
            mov ax, 1               ;ax = j
            inner:
            
                ;-
                push ax                        
                push bx
                push dx
                
                xchg ax, bx
                mov dl, byte ptr[di+bx]
                add bx, ax                        ;cmp byte ptr[si+bx+ax], byte ptr[di+ax]
                mov al, byte ptr[si+bx]
                sub al, dl
                mov ah, 0
                mov bp, ax
                
                pop dx
                pop bx
                pop ax 
                ;-
                
                cmp bp, 0
                je continue1
                mov dx, 0
                jmp continue
                
                continue1:
                inc ax
                mov bp, ax
                inc bp
                cmp bp, word ptr[ei]
                jl inner
            
            cmp dx, 1
            jne continue            ;if flag == 1: counter++ 
            inc cx
            
            continue:
            inc bx
            cmp bx, word ptr[en]
            jle for
        
        mov ax, cx
        call PRINT_NUM_UNS
        jmp return    
    endp
        
ends
DEFINE_GET_STRING
DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM_UNS
end start ; set entry point and stop the assembler.
