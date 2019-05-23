assume cs:code, ss:stack

stack segment
    db 0
stack ends

code segment
start:	mov ax,4240h
		mov dx,000fh
		mov cx,0ah
		call divdw
		
		mov ax,4c00h
		int 21h

divdw:	push ax
		mov ax,dx
		mov dx,0		; (dx ax) = H
		div cx
		mov bx,ax		; bx = int(H/N) = H(new)
						; dx = rem(H/N)
		pop ax			; ax = L
						; ax = rem(H/N)*65536+L = L(new)
		div cx
		mov cx,dx		; cx = rem(new)
		mov dx,bx   	; dx = H(new)
		ret
		
code ends
end start