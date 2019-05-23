assume cs:code, ds:data, ss:stack

data segment
    db 'welcome to masm!'
    db 02h,24h,71h
data ends

stack segment
    db 0
stack ends

code segment
start:
    ; ds - bx - data
    mov ax,data
    mov ds,ax
    mov bx,0
    
    ; es - bp - display
    mov ax,0b800h
    mov es,ax
    mov bp,0a0h

    ; si - color
    mov si,10h

    mov cx,3h

    s:
        push cx
        mov cx,10h
        s0:
            mov al,ds:[bx]
            mov es:[bp],al
            inc bp
            mov al,ds:[si]
            mov es:[bp],al
            inc bx
            inc bp
        loop s0
        inc si
        mov bx,0
        add bp,80h
        pop cx
    loop s

    mov ax,4c00h
    int 21h

code ends

end start