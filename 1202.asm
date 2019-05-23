assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset do1
    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset do1_end - offset do1
    cld
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[1*4],200h
    mov word ptr es:[1*4+2],0

    mov ax,4c00h
    int 21h

do1:
    push ax
    mov ax,0b800h
    mov ds,ax
    mov si,0
    call cg_color
    pop ax
    iret

cg_color:
    push cx
    push ds
    push si
    push ax

    mov cx,80*25

loop_s: 
    mov al,ds:[si]

    cmp al,41h
    jb none
    cmp al,7ah
    ja none


    cmp al,5ah
    jna lower

    cmp al,61h
    jnb upper

    mov al,0
    mov ds:[si+1],al
    jmp short done

none:
    mov al,0h
    mov ds:[si+1],al
    jmp short done

lower:
    mov al,00001010b
    mov ds:[si+1],al
    jmp short done

upper:
    mov al,00001001b
    mov ds:[si+1],al

done:
    add si,2
    loop loop_s

ok:
    pop ax
    pop si
    pop ds
    pop cx
    ret

do1_end:
    nop

code ends
end start