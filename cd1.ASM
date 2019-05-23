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
    db 8 dup (0)
stack ends

tmpdata segment
    dw 8 dup (0)
    dw 8 dup (0)
tmpdata ends

code segment
start:
    ; put data into table

    mov ax,data
    mov ds,ax
    mov bx,0

    mov ax,table
    mov es,ax
    mov bp,0

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
        mov byte ptr es:[bp].0h[si],0

        mov si,0
        mov cx,4
        sb:
            mov al,ds:[bx].54h[si]
            mov byte ptr es:[bp].5h[si],al
            inc si
        loop sb
        mov byte ptr es:[bp].5h[si],0
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
        add si,2
        mov byte ptr es:[bp].5h[si],0
        inc si

        add bx,bx

        mov ax,es:[bp+5h]
        mov dx,es:[bp+7h]
        div word ptr es:[bp+0ah]
        mov word ptr es:[bp].5h[si],ax
        add si,2
        mov word ptr es:[bp].5h[si],0

        add bx,4h
        add bp,10h
        pop cx
    loop s

    ; put table unto screen

    mov ax,table
    mov ds,ax
    mov si,0

    mov ax,stack
    mov ss,ax
    mov sp,10h

    mov cx,21
    mov dh,1    ; row
    mov dl,0    ; column

    sss:    push cx
            mov cx,7        ; color

            call show_str   ; ds:si = first address
            add dx,10
            add si,5

            mov bx,dx
            mov ax,ds:[si]
            mov dx,ds:[si+2]
            call show
            add si,5

            mov bx,dx
            mov ax,ds:[si]
            mov dx,0
            call show
            add si,3

            mov bx,dx
            mov ax,ds:[si]
            mov dx,0
            call show
            add si,3 

            add dh,1
            mov dl,0
            mov ax,ds
            add ax,1
            mov ds,ax
            mov si,0
            pop cx

            loop sss

    mov ax,4c00h
    int 21h


    show:   push ds
            mov di,tmpdata
            mov ds,di
            push si
            mov si,0
            call dtoc
            mov dx,bx
            call show_str
            pop si
            pop ds
            add dx,10
            ret

    dtoc:   push cx
            push ax
            push bx
            push si
            push di
            push dx
        
            mov si,10h
        
        s0: mov cx,10
            call divdw      ; (dx ax) = int cx = rem
            add cx,30h
            mov ds:[si],cl
            inc si
            mov cx,ax
            or cx,dx
            jcxz s1
            jmp short s0
            
        s1: ; mov byte ptr ds:[si],0h
            dec si
            mov di,0
            s2: mov cx,si
                sub cx,0fh
                jcxz okk
                mov bl,ds:[si]
                mov ds:[di],bl
                inc di
                dec si
                jmp short s2
                
            okk:    mov byte ptr ds:[di],0h
                    pop dx
                    pop di
                    pop si
                    pop bx
                    pop ax
                    pop cx
                    ret
           
show_str:   push es
            push dx
            push bx
            push si
            push cx
            push di
            
            mov ax,0b800h
            mov es,ax
            mov al,0a0h
            mul dh
            mov bx,ax
            mov al,2
            mul dl
            add bx,ax   ; bx = offset
            mov ah,cl   ; ah = color
            mov di,10
            
            s3: mov cl,ds:[si]
                mov ch,0
                jcxz ok
                mov al,ds:[si]
                mov es:[bx],al
                mov es:[bx+1],ah
                add bx,2
                inc si
                inc di
                jmp short s3
                
            ok: sub di,si
                mov cx,di
                space:  mov byte ptr es:[bx],' '
                        mov es:[bx+1],ah
                        add bx,2
                        loop space
                pop di
                pop cx
                pop si
                pop bx
                pop dx
                pop es
                ret

divdw:  push bx
        push ax
        mov ax,dx
        mov dx,0        ; (dx ax) = H
        div cx
        mov bx,ax       ; bx = int(H/N) = H(new)
                        ; dx = rem(H/N)
        pop ax          ; ax = L
                        ; ax = rem(H/N)*65536+L = L(new)
        div cx
        mov cx,dx       ; cx = rem(new)
        mov dx,bx       ; dx = H(new)
        pop bx
        ret

code ends
end start