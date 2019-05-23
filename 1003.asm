assume cs:code

data segment
	db 8 dup (0)
	db 8 dup (0)
data ends

stack segment
	db 0
stack ends
 
code segment
start:	mov ax,0
		mov bx,data
        mov ds,bx
        mov si,0
		mov bx,stack
		mov ss,bx
		mov sp,10h
		
        call dtoc
        
		mov dh,8
        mov dl,3
        mov cl,2
        call show_str
		
        mov ax,4c00h
        int 21h
		
dtoc:	push cx
		push ax
		push bx
		push si
		push di
		
		mov ch,0
		mov bx,10
		mov si,10h
		
		s0:	mov dx,0
			div bx		; ax = int dx = rem
			add dx,30h
			mov ds:[si],dl
			inc si
			mov cx,ax
			jcxz s1
			jmp short s0
			
		s1:	mov byte ptr ds:[si],0h
			dec si
			mov di,0
			s2:	mov cx,si
				sub cx,0fh
				jcxz okk
				mov bl,ds:[si]
				mov ds:[di],bl
				inc di
				dec si
				jmp short s2
				
			okk:	mov byte ptr ds:[di],0h
					pop di
					pop si
					pop bx
					pop ax
					pop cx
					ret
			
show_str:	push es
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
			add bx,ax	; bx = offset
			mov ah,cl	; ah = color
			
			s:	mov cl,ds:[si]
				mov ch,0
				jcxz ok
				mov al,ds:[si]
				mov es:[bx],al
				mov es:[bx+1],ah
				add bx,2
				inc si
				jmp short s
				
			ok:	pop cx
				pop si
				pop bx
				pop dx
				pop es
				ret
				
code ends
end start