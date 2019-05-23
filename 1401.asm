; read CMOS RAM - 2nd unit
; write 0 to CMOS RAM

assume cs:code

code segment
start:
    ; read
    mov al,2
    out 70h,al
    in al,71h

    ; write
    mov al,2
    out 70h,al
    mov al,0
    out 71h,al
    in al,71h

    mov ax,4c00h
    int 21h

code ends
end start