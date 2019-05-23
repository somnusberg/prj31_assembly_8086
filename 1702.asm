assume cs:code

code segment
start:
        mov ax, 0
        mov dx, 1
        mov bx, 0
        mov es, bx
        mov bx, 200h
        int 7ch
        mov ax, 4c00h
        int 21h
code ends
end start
