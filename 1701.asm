assume cs:code

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset rwdisc

    mov ax, 0
    mov es, ax
    mov di, 200h
    mov cx, offset rwdiscend - rwdisc
    cld
    rep movsb

    mov ax, 0
    mov es, ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax, 4c00h
    int 21h

rwdisc:
    push di
    push cx

    mov di, ax  ; save ax
    
    mov ax, dx
    mov dx, 0
    mov cx, 1440
    div cx      ; ax = int dx = rem ---- ax = 面号
    push ax     ; 面号
    mov ax, dx
    mov dx, 0
    mov cx, 18
    div cx      ; ax = int dx = rem
    push ax     ; 磁道号
    inc dx
    push dx     ; 扇区号

    pop cx      ; 扇区号
    pop ax
    mov ch, al  ; 磁道号
    pop ax
    mov dh, al  ; 面号
    mov dl, 0   ; 驱动器号

    mov ax, di
    cmp ah, 2
    jnb rwret

    cmp ah, 0   ; read
    je rset

    cmp ah, 1   ; write
    je wset

rset:
    mov ah, 2   ; read
    jmp setok

wset:
    mov ah, 3   ; write
    jmp setok

setok:
    mov al, 1
    int 13h

rwret:
    pop cx
    pop di
    iret

rwdiscend:
    nop

code ends
end start


