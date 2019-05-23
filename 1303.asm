; int 7ch
; show string

assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset show
    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset show_end - show
    cld
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[7ch*4],200h
    mov word ptr es:[7ch*4+2],0
    mov ax,4c00h
    int 21h

show:
    call show_str
    iret

show_str:   
    push es
    push dx
    push bx
    push si
    push cx
            
    mov ax,0b800h
    mov es,ax
    mov al,0a0h
    mul dh
    mov bx,ax
    mov al,2
    mul dl
    add bx,ax ; bx = offset
    mov ah,cl ; ah = color
            
s:  
    mov cl,ds:[si]
    mov ch,0
    jcxz ok
    mov al,ds:[si]
    mov es:[bx],al
    mov es:[bx+1],ah
    add bx,2
    inc si
    jmp short s

ok: 
    pop cx
    pop si
    pop bx
    pop dx
    pop es
    ret    

show_end:
    nop

code ends
end start