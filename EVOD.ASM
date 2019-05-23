assume cs:code

code segment
    mov ax,2222h
    mov bx,0b810h
    mov ds,bx
    and ax,1b

    mov bx,0230h
    add bx,ax

    mov ds:[0],bx

    mov ax,4c00h
    int 21h

code ends

end

    