; display current time on screen

assume cs:code

data segment
    db 16 dup (0)
    db 16 dup (0)
data ends

stack segment
    db 0
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,10h

    mov ax,data
    mov ds,ax
    mov bx,0

    mov al,9
    call putdata
    mov byte ptr ds:[bx],'/'
    inc bx

    mov al,8
    call putdata
    mov byte ptr ds:[bx],'/'
    inc bx

    mov al,7
    call putdata
    mov byte ptr ds:[bx],' '
    inc bx

    mov al,4
    call putdata
    mov byte ptr ds:[bx],':'
    inc bx

    mov al,2
    call putdata
    mov byte ptr ds:[bx],':'
    inc bx

    mov al,0
    call putdata
    mov byte ptr ds:[bx],0

    mov dh,5
    mov dl,50
    mov cl,01110000b
    mov ax,data
    mov ds,ax
    mov si,0 
    call show_str
        
    mov ax,4c00h
    int 21h


putdata:
    out 70h,al
    in al,71h
    call bcd2ascii
    mov ds:[bx],ah
    inc bx
    mov ds:[bx],al
    inc bx
    ret

bcd2ascii:   ; al -> (ah+30 al+30)
    push cx
    mov ah,al
    mov cl,4
    shr ah,cl
    and al,00001111b

    add ah,30h
    add al,30h
    pop cx
    ret

    

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

code ends
end start