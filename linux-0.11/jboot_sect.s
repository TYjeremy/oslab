BOOTSEG = 0x07c0
INITSEG = 0x9000

entry _start

_start:
#1 设置ds:si - > es->di   mov 0x7c00 -512->  0x90000
 	mov ax, #BOOTSEG
	mov ds, ax
	mov ax, #INITSEG
	mov es, ax

#
	xor di, di
	xor si, si
	mov cs, $0x200
	rep
	mov w
	jmpi go,INITSEG

go:
	halt

times (512 - ($ - $$)) .btye 0
