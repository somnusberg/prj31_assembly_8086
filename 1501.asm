; display A for all screen
; if press A and leave

assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 128

    push cs
    pop ds

    mov ax, 0
    mov es, ax

    mov si, offset int9
    mov di, 204h
    mov cx, offset int9end - offset int9
    cld
    rep movsb

    push es:[9*4]
    pop es:[200h]
    push es:[9*4+2]
    pop es:[202h]

    cli
    mov word ptr es:[9*4], 204h
    mov word ptr es:[9*4+2], 0
    sti

    mov ax, 4c00h
    int 21h

int9:
    push ax
    push bx
    push cx
    push es

    mov dx, 0
    mov bx, 1

read:
    in al, 60h

    pushf
    call dword ptr cs:[200h]

    cmp al, 1
    je uninstall

    cmp dx, bx
    je aleave

apress:
    cmp al, 1eh
    jne read
    mov dx, 1

aleave:
    cmp al, 1eh + 80h
    jne read

    mov ax, 0b800h
    mov es, ax
    mov bx, 0
    mov cx, 2000
    mov al, 'A'
    mov ah, 00001100b

s:
    mov byte ptr es:[bx], al
    mov byte ptr es:[bx+1], ah
    add bx, 2
    loop s
    jmp int9ret

uninstall:
    mov ax, 0
    mov es, ax
    push es:[200h]
    pop es:[9*4]
    push es:[202h]
    pop es:[9*4+2]

int9ret:
    pop es
    pop cx
    pop bx
    pop ax
    iret

int9end:
    nop

code ends
end start