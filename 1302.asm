; int 7ch
; = jmp short

assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset jmp_short
    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset jmp_short_end - jmp_short
    cld
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0
    mov ax,4c00h
    int 21h

jmp_short:
    push bp
    mov bp,sp
    add [bp+2],bx
    pop bp
    iret
jmp_short_end:
    nop

code ends
end start