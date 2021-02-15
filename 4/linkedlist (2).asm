;YA KAZEM    

include "emu8086.inc"
\n equ 10
minus equ 45
six equ 54
one equ 49
two equ 50
three equ 51
four equ 52
five equ 53
space equ 32
    
data segment
    vnf db "value not found!",0
    wc db "wrong command!",0
    buffer dd ?
    input dd ?
    dw ?
    last dw ?
    first dw ?
    strt dd ?
    dw ?        ;start of memory allocation to linkedList nodes---nodes are consisted of a double word & a word: value, next
                                          
ends                                                        

stack segment
    dw   128  dup(0)
ends

print_new_line macro
    PUTC \n
    PUTC 13
endm

creat_new_node macro label
    mov ax, word ptr[di] 
    mov bx, word ptr[last]
    mov [bx], ax     
                            ;two cycles to copy a double word from input([di] & [di+2]) to node.value    
    mov ax, word ptr[di+2]
    mov bx, word ptr[last]
    add bx, 2
    mov word ptr[bx], ax
    
    mov ax, word ptr[label]
    mov bx, word ptr[last]  ;mov [[last]+4], [label]
    add bx, 4
    mov word ptr[bx], ax    
endm

switch_case macro case, labl, function
    cmp bl, case
    jne labl     
    add di, 2
    call function
    jmp main_loop
endm

;=========================================

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    
    lea dx, strt        
    mov word ptr[first], dx     ;init first to address of first element(strt)
    mov word ptr[last], dx      ;init last to address of last node which memory allocated to it(strt)
    
    main_loop:
    lea di, input
    mov dx, 6           ;input string length
    call GET_STRING
    print_new_line     
    
    mov bl, byte ptr[di]
    cmp bl, minus       ;if == -1 jump to finish
    je finish 
    
    switch_case six, no6, printList
    
    no6:
    switch_case five, no5, findIndex
    
    no5:
    switch_case four, no4, delete
    
    no4:
    cmp bl, three
    jne no3  
    lea di, buffer
    mov dx, 4
    call GET_STRING
    print_new_line
    call insertAfter
    jmp main_loop
    
    no3:
    switch_case two, no2, insertLast
    
    no2:
    switch_case one, no1, insertFirst
                                                                                               
    no1:
    lea si, wc
    call PRINT_STRING      ;wrong command
    print_new_line                                                      
    jmp main_loop
    
    finish:
    mov ax, 4c00h ; exit to operating system                                                           
    int 21h                                        
    

;=========================================================    
 
    printList proc near
        mov bx, word ptr[first]
        
        continue:
        mov si, bx
        call PRINT_STRING
        PUTC space
        mov ax, bx
        add bx, 4
         
        cmp word ptr[bx], 0     ;if list is empty jump to out_
        je out_
        
        mov bx, word ptr[bx]
        cmp bx, ax     
        jne continue
        
        out_:
        print_new_line
        ret            
    endp 

   
    findIndex proc near
        mov cx, 0       ;cl := index
        mov bx, word ptr[first]
        continue2:
    
        mov dx, [bx]
        cmp [di], dx
        jne super_continue           ;two cycles of comparision to check if the value exists in the list
        mov dx, [bx+2]
        cmp [di+2], dx
        je break
        
        super_continue:
        mov ax, bx
        add bx, 4
        
        cmp word ptr[bx], 0     ;if list is empty jump to out__
        je out__
         
        mov bx, word ptr[bx]
        inc cx
        cmp bx, ax     
        jne continue2
        
        out__:
        lea si, vnf
        call PRINT_STRING   ;got to end of list and value not found
        print_new_line
        ret
        
        break:
        mov ax, cx
        call PRINT_NUM_UNS
        print_new_line      ;value found, print the index
        ret
        
    endp 


    delete proc near
                                                              
        mov si, word ptr[first]
        mov bx, [si]
        cmp [di], bx             
        jne lop           ;check if you want to delete first value of the list
        mov bx, [si+2]
        cmp [di+2], bx
        jne lop                 ;mov [first], [[first]+4]
        mov si, [si+4]
        mov [first], si
        ret
         
        lop: 
        mov bx, word ptr[first]
        continue3:
        mov cx, ax
        mov ax, bx              ;cx = node
        add bx, 4 
        
        cmp word ptr[bx], 0     ;if list is empty jump to out___
        je out___
        
        mov bx, word ptr[bx]     ;bx = node.next  ,  ax = node
        
        mov dx, [bx]
        cmp [di], dx
        jne super_continue1      ;node.next.value == input
        mov dx, [bx+2]
        cmp [di+2], dx
        je deletion
        
        super_continue1:
        mov ax, bx
        add bx, 4 
        mov bx, word ptr[bx]     ;bx = node.next.next  ,  ax = node.next
        cmp bx, ax     
        jne continue3
        
        out___:
        lea si, vnf
        call PRINT_STRING        ;got to end of list and value not found
        print_new_line
        ret
                                  
        deletion:                   ;delete
        cmp ax, bx
        je delete_last_node
        mov si, ax
        mov dx, [bx+4]              ;mov [ax+4], [bx+4]
        mov [si+4], dx  
        ret
        
        delete_last_node: 
        mov si, cx
        mov [si+4], cx              ;mov [cx+4], cx
        ret
        
    endp


    insertAfter proc near
        
        lea di, input+2
        mov bx, word ptr[first]          ;di = input+2
        continue5:                       ;bx = [first]
    
        mov dx, [bx]
        cmp [di], dx
        jne super_continue5              ;two cycles of comparision to check if the value exists in the list
        mov dx, [bx+2]
        cmp [di+2], dx
        je break5
        
        super_continue5:
        mov ax, bx
        add bx, 4
        
        cmp word ptr[bx], 0              ;if list is empty jump to out5
        je out5
         
        mov bx, word ptr[bx]
        cmp bx, ax     
        jne continue5
        
        out5:
        lea si, vnf
        call PRINT_STRING                ;got to end of list and value not found
        print_new_line
        ret
        
        break5:                          ;value found, insret after
        
        lea di, buffer
        mov si, bx                       ; si = address of target node
        
        mov ax, word ptr[di] 
        mov bx, word ptr[last]
        mov [bx], ax     
                                         ;two cycles to copy a double word from buffer([di] & [di+2]) to node.value    
        mov ax, word ptr[di+2]
        mov bx, word ptr[last]
        add bx, 2
        mov word ptr[bx], ax
        
        mov ax, word ptr[si+4]
        mov bx, word ptr[last]           ;mov [[last]+4], [si+4]
        add bx, 4
        
        mov word ptr[bx], ax
        
        mov bx, [last]                   ;[bx].next = new node
        mov [si+4], bx
        
        
        mov bx, [last]
        mov bx, [bx+4]
        mov bx, [bx+4]
        cmp bx, [last]
        je insert_after_last_node
        
        
        add word ptr[last], 6            
        ret
        
        insert_after_last_node:
        mov [bx+4], bx
        add word ptr[last], 6            
        ret
        
    endp 
    
                  
    insertLast proc near
        creat_new_node last
          
        mov bx, word ptr[first]
        continue1:
        mov ax, bx
        add bx, 4 
        mov bx, word ptr[bx]    ;bx contains the address of last node in the list
        cmp bx, ax     
        jne continue1
        
        mov ax, word ptr[last]      ;mov word ptr[bx], word ptr[last]
        mov word ptr[bx+4], ax
        
        add word ptr[last], 6
        ret
    endp
    
    
    insertFirst proc near
        creat_new_node first
        
        mov ax, word ptr[last]
        mov word ptr[first], ax 
        
        add word ptr[last], 6   ;[last] is address of 6 bytes, which are always free and next node to be created, will placed there
        ret        
    endp        
   
ends      
DEFINE_GET_STRING
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM_UNS
end start ; set entry point and stop the assembler.
