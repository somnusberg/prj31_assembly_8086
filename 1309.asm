; calculate 2 ^ 8 
; while printing IP for each step

assume cs:code

stack segment
    db 0
stack ends

code segment
start:
    int 1

    mov ax,2
    mov cx,8
    mov bx,2
s:
    mul bx
    loop s
    
    mov ax,4c00h
    int 21h
code ends
end start