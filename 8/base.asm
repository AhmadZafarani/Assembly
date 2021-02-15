; YA DALIL AL MOTAHAIYERIN

include "emu8086.inc"
\n equ 10
zero equ 48
space equ 32
A equ 65
nine equ 57

print_new_line macro
    PUTC \n
    PUTC 13
endm

data segment
    firstBase dw ?
    secondBase dw ?
    input db 20 dup(0)
    output db 20 dup(0)
    power dw 1
    num dw 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    call SCAN_NUM
    cmp cx, 16
    jg return
    mov [firstBase], cx
    print_new_line
    
    call SCAN_NUM
    cmp cx, 16
    jg return
    mov [secondBase], cx
    print_new_line
    
    lea di, input
    mov dx, 20
    call GET_STRING
    print_new_line
    
    call toDeci
    call fromDeci       ;[num] = input to decimal
    
    call PRINT_STRING
    return:
    mov ax, 4c00h       ; exit to operating system.
    int 21h
    
    ;======================================================
    
    toDeci proc near
        mov bx, 20
        for:
        dec bx
        cmp byte ptr[di+bx], 0
        je for
        
        mov ah, 0                   ;ah = 0 & al = ascii code of char => ax goes to ascii code of char 
        mov al, byte ptr[di+bx]
        call val
        mul word ptr[power]
        add word ptr[num], ax
        
        mov ax, [power]
        mul [firstBase]         ;[power] *= [firstBase]
        mov [power], ax
        
        cmp bx, 0
        jg for
        ret    
    endp
    
    
    val proc near           ;return value of char in ax .  get the val in ax
        cmp ax, nine
        jg else
        cmp ax, zero
        jl else
        sub ax, zero
        jmp back
        
        else:
        sub ax, A
        add ax, 10
        
        back:
        cmp ax, [firstBase]
        jge return
        
        ret              
    endp
      
      
    fromDeci proc near
        lea si, output
        mov bx, 0       ;index = bx
        while:
        mov dx, 0
        mov ax, [num]
        div [secondBase]    ;dx = [num] % [secondBase]
        call reVal          ; dx = char value of dx
        mov [si+bx], dx
        
        mov [num], ax     ;[num] /= [secondBase]
        
        inc bx
        
        cmp [num], 0
        jg while
        
        call strev
        ret    
    endp
    
    
    reVal proc near
        cmp dx, 9
        jg else1
        cmp dx, 0
        jl else1
        add dx, zero
        ret
        
        else1:
        add dx, A
        sub dx, 10
        ret    
    endp
    
    
    strev proc near
        mov word ptr[power], bx
        sar bx, 1      
        mov ax, 0       
        xchg ax, bx                                 ;bx = i      ax = output length / 2
        foor:
        mov cl, byte ptr[si+bx]                     ;si=output offset
        
        mov bp, word ptr[power]
        sub bp, bx
        add bp, si
        mov [num], bx
        mov bx, bp
        mov dl, byte ptr[bx-1]                       ;mov byte ptr[si+bx], byte ptr[si+[power]-bx-1]
        mov bx, word ptr[num]
        mov byte ptr[si+bx], dl                  
        
        mov [num], bx
        mov bx, bp                   ;mov byte ptr[si+[power]-bx-1], cl
        mov byte ptr[bx-1], cl
        mov bx, word ptr[num]
        
        inc bx
        cmp bx, ax
        jl foor
        
        ret  
    endp
        
ends     
DEFINE_GET_STRING
DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
end start ; set entry point and stop the assembler.
