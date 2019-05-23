assume cs:code, ds:data, ss:stack

data segment
	db 'Welcome to masm!', 0
data ends

stack segment
    db 0
stack ends

code segment
start:	mov dh,8
		mov dl,3
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0
		mov ax,stack
		mov ss,ax
		mov sp,10h
		
		call show_str
		
		mov ax,4c00h
		int 21h

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
			add bx,ax ; bx = offset
			mov ah,cl ; ah = color
			
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
			