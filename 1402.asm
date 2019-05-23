; (dx ax) = (ax) * 10

assume cs:code

stack segment
    db 0
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,10h

    mov ax,0ffffh
    shl ax,1
    call readcf
    mov dl,bl ; (dx ax) = (ax) * 2
    push dx
    push ax

    mov ch,bl
    mov cl,2
    shl ch,cl
    mov dl,ch

    shl ax,1
    call readcf
    mov ch,bl
    shl ch,1 
    add dl,ch ; (dx ax) = (ax) * 4

    shl ax,1
    call readcf
    add dl,bl ; (dx ax) = (ax) * 8

    pop cx ; cx = ax
    pop bx ; bx = dx
    add ax,cx
    adc dx,bx

    mov ax,4c00h
    int 21h

readcf: ; bx = cf
    pushf
    pop bx
    and bx,1
    ret

code ends
end start