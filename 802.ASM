assume cs:code

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

stack segment
    dw 0,0,0,0,0,0,0,0
stack ends

code segment
start:
    ; ds - bx - data
    mov ax,data
    mov ds,ax
    mov bx,0

    ; es - bp - table
    mov ax,table
    mov es,ax
    mov bp,0

    ; ss - sp - stack for saving cx
    mov ax,stack
    mov ss,ax
    mov sp,10h

    mov cx,21

    s:
        push cx
        mov si,0
        mov cx,4
        sa:
            mov al,[bx].0h[si]
            mov byte ptr es:[bp].0h[si],al
            inc si
        loop sa

        mov si,0
        mov cx,4
        sb:
            mov al,ds:[bx].54h[si]
            mov byte ptr es:[bp].5h[si],al
            inc si
        loop sb
        inc si

        push ds
        mov ax,0h
        mov ds,ax
        mov ax,bx
        mov byte ptr ds:[200h],2
        div byte ptr ds:[200h]
        pop ds
        mov bh,0
        mov bl,al

        mov ax,ds:[bx].0a8h
        mov word ptr es:[bp].5h[si],ax
        add si,3

        add bx,bx

        mov ax,es:[bp+5h]
        mov dx,es:[bp+7h]
        div word ptr es:[bp+0ah]
        mov word ptr es:[bp].5h[si],ax

        add bx,4h
        add bp,10h
        pop cx
    loop s
    
    mov ax,4c00h
    int 21h
code ends

end start