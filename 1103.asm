; PSP to 安全内存空间 ( 0:200 - 0:2ff )

assume cs:code, ss:stack

stack segment
    db 0
stack ends

code segment
start:              ; ds = add of psp
        mov ax,20h
        mov es,ax
        mov si,0
        mov di,0
        mov cx,256
        cld
        s: 
            movsb
            loop s

        mov ax,4c00h
        int 21h
        
code ends
end start
