; int 7ch : set screen
; ah : function num 
; 0 - cls
; 1 - set text color
; 2 - set background color
; 3 - roll back
; al(0-7) : color

assume cs:code

code segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset setscreen

    mov ax, 0
    mov es, ax
    mov di, 200h
    mov cx, offset setscreen_end - setscreen
    cld
    rep movsb

    mov ax, 0
    mov es, ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0

    mov ax, 4c00h
    int 21h

setscreen:
    cmp ah, 0
    je do1
    cmp ah, 1
    je do2
    cmp ah, 2
    je do3
    cmp ah, 3
    je do4
    jmp short sret

do1:
    call sub1
    jmp short sret

do2:
    call sub2
    jmp short sret

do3:
    call sub3
    jmp short sret

do4:
    call sub4
    jmp short sret

sret:
    iret

sub1:
    push bx
    push cx
    push es
    mov bx, 0b800h
    mov es, bx
    mov bx, 0
    mov cx, 2000

sub1s:
    mov byte ptr es:[bx], ' '
    add bx, 2
    loop sub1s

    pop es
    pop cx
    pop bx
    ret

sub2:
    push bx
    push cx
    push es
    mov bx, 0b800h
    mov es, bx
    mov bx, 1
    mov cx, 2000

sub2s:
    and byte ptr es:[bx], 11111000b
    or es:[bx], al
    add bx, 2
    loop sub2s

    pop es 
    pop cx
    pop bx
    ret

sub3:
    push bx
    push cx
    push es
    mov cl, 4
    shl al, cl
    mov bx, 0b800h
    mov es, bx
    mov bx, 1
    mov cx, 2000

sub3s:
    and byte ptr es:[bx], 10001111b
    or es:[bx], al
    add bx, 2
    loop sub3s

    pop es
    pop cx
    pop bx
    ret

sub4:
    push cx
    push si
    push di
    push es
    push ds

    mov si, 0b800h
    mov es, si
    mov ds, si
    mov si, 160
    mov di, 0
    cld 
    mov cx, 24

sub4s:
    push cx
    mov cx, 160
    rep movsb
    pop cx
    loop sub4s

sub4s1:
    mov byte ptr [160*24+si], ' '
    add si, 2
    loop sub4s1

    pop ds 
    pop es
    pop di
    ret

setscreen_end:
    nop

code ends
end start