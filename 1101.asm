assume cs:codesg

datasg segment
    db "Beginners All-purpose Symbolic Instruction Code.",0
datasg ends

codesg segment
begin:
    mov ax,datasg
    mov ds,ax
    mov si,0
    call letterc

    mov ax,4c00h
    int 21h

letterc:
    push cx
    push ds
    push si

    mov ch,0

loop_s: 
    mov cl,ds:[si]
    cmp cl,61h
    jna larger
    cmp cl,7ah
    jnb larger

    and cl,11011111b
    mov ds:[si],cl

larger:
    inc si
    jcxz ok
    jmp short loop_s

ok:
    pop si
    pop ds
    pop cx
    ret

codesg ends
end begin