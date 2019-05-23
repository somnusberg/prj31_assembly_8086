; countdown

assume cs:code

data segment
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
    mov si,0
    mov dx,0

    mov al,0
    out 70h,al
    in al,71h
    call bcd2num
    mov di,ax

    mov cx,5    ; num of secs
s:
    mov al,0
    out 70h,al
    in al,71h
    call bcd2num
    cmp di,ax
    jne print
    jmp next

print:
    add cx,30h
    mov byte ptr ds:[si],cl
    mov byte ptr ds:[si+1],'$'
    sub cx,30h
    mov di,ax
    mov ah,9
    int 21h
    dec cx

next:
    jcxz ending
    jmp s

ending:
    mov ax,4c00h
    int 21h

bcd2num:   ; al(bcd) -> ax(h)
    push cx
    push bx
    mov ah,al
    mov cl,4
    shr ah,cl
    and al,00001111b
    mov bl,al   ; bx = low num
    mov bh,0
    mov al,ah
    mov ah,10
    mul ah      
    mov ah,0    ; ax = high num * 10
    add ax,bx
    pop bx
    pop cx
    ret

code ends
end start