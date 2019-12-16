SYSSIZE = 0x3000

SETUPLEN = 4
BOOTSEG = 0x07c0
INITSEG = 0x9000
SETUPSEG = 0x9020
SYSSEG = 0x1000
ENDSEG = SYSSEG + SYSSIZE


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
	mov cx, #0x100
	rep
	movw
	jmpi go,INITSEG

go:
	mov ax, cs
	mov ds, ax
	mov es, ax

	mov sp, ax
	mov sp, #0xFF00


load_setup:
//功能描述：读扇区 
//入口参数：AH＝02H 
//AL＝扇区数 
//CH＝柱面 
//CL＝扇区 
//DH＝磁头 
//DL＝驱动器，00H~7FH：软盘；80H~0FFH：硬盘 
//ES:BX＝缓冲区的地址 
//出口参数：CF＝0——操作成功，AH＝00H，AL＝传输的扇区数，否则，AH＝状态代码，参见功能号01H中的说明 
//若出错cf置位

//当前es: 0x9000  bx:
	mov ax, #0x200 + SETUPLEN
	mov cx, #0x02
	mov dx, #0x0
	mov bx, #0x200
	int 0x13
	jnc ok_load_setup
	mov ax, #0x0
	mov dx, #0x0
	int 0x13
	j load_setup

ok_load_setup:
//功能08H  
//功能描述：读取驱动器参数 
//入口参数：AH＝08H 
//DL＝驱动器，00H~7FH：软盘；80H~0FFH：硬盘 
//出口参数：CF＝1——操作失败，AH＝状态代码，参见功能号01H中的说明，否则， BL＝01H — 360K 
//＝02H — 1.2M 
//＝03H — 720K 
//＝04H — 1.44M 
//CH＝柱面数的低8位 
//CL的位7-6＝柱面数的该2位 
//CL的位5-0＝扇区数 
//DH＝磁头数 
//DL＝驱动器数 
//ES:DI＝磁盘驱动器参数表地址 
	mov ax, #0x800
	sub dx, dx
	int 0x13

	mov ch, #0x00
	mov sectors, cx
	mov ax, #INITSEG
	mov es, ax



//print some message
//功能描述：在Teletype模式下显示字符串 
//入口参数：AH＝13H 
//BH＝页码 
//BL＝属性(若AL=00H或01H) 
//CX＝显示字符串长度 
//(DH、DL)＝坐标(行、列) 
//ES:BP＝显示字符串的地址 AL＝显示输出方式 
//0——字符串中只含显示字符，其显示属性在BL中。显示后，光标位置不变 
//1——字符串中只含显示字符，其显示属性在BL中。显示后，光标位置改变 
//2——字符串中含显示字符和显示属性。显示后，光标位置不变 
//3——字符串中含显示字符和显示属性。显示后，光标位置改变 
//出口参数：无 
	mov ah, #0x3
	xor bh, bh
	int 0x10

	mov cx, #27
	mov bx, #0x07
	mov bp, #msg1
	mov ax, #0x1301
	int 0x10


//load system image
	mov ax, #SYSSEG
	mov es,ax
	
	
	
exit:
	jmp exit


msg1:
	.byte 13,10
	.ascii "Loading jeremy System"
	.byte 13,10,13,10

sectors:
	.word 0

.org	510
boot_flag:
	.word 0xAA55
