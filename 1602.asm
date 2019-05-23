; 1601.exe test

assume cs:code

code segment
start:
    mov al, 7   ; al = 0-7
    mov ah, 0   ; ah : 0 - cls
                ;      1 - f color
                ;      2 - b color
                ;      3 - roll
    int 7ch

    mov ax, 4c00h
    int 21h
code ends
end start