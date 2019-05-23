; 1.exe
; int 1 setup : print IP on screen

assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset printIP

    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset printIP_end - printIP
    cld
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[1*4],200h
    mov word ptr es:[1*4+2],0
    mov ax,4c00h
    int 21h

printIP:
    push ax
    push dx
    push cx
    jmp short prtstart
dat:
    db 16 dup (0)

prtstart:
    mov ax,cs
    mov ds,ax
    mov si,207h
    mov bp,sp

    mov ax,ss:[bp+6]  ; (ah al) = IP
    mov cx,4
bit2ascii:
    mov dx,ax
    push cx
    add cx,cx
    add cx,cx
    sub cx,4
    jcxz lastbit
    shr dx,cl
lastbit:
    and dl,00001111b

    cmp dl,9
    jna lownum

    add dl,37h
    mov ds:[si],dl
    jmp short bitok

lownum:
    add dl,30h
    mov ds:[si],dl

bitok:
    pop cx
    inc si
    loop bit2ascii


printer:
    mov byte ptr ds:[si],' '
    inc si
    mov byte ptr ds:[si],'$'
    

    or byte ptr ss:[bp+11],1b ; TF = 1
    pop cx
    pop dx
    pop ax
    iret
mov dx,207h
    mov ah,9
    int 21h ; print IP
printIP_end:
    nop

code ends
end start