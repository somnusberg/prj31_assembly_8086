; set tf to 1

assume cs:code

stack segment
    db 0
stack ends

code segment
start:    
    mov ax,stack
    mov ss,ax
    mov sp,10h

    pushf
    pop ax
    or ah,1
    push ax
    popf
    mov ax,4c00h
    int 21h

code ends
end start