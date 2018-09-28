org 0x500
jmp 0x0000:start

data:
	string db 'Loading structures for the kernel...', 0
	string2 db 'Loading kernel address...', 0
	string3 db 'Running kernel...', 0

putchar: 	; o char tem que estar em al
	mov ah, 0x0e
	int 10h
	ret

delay:
	mov bp, 20000
	.loop1:
		mov si, 20000
		.loop2:
			dec si
			cmp si, 0
			jnz .loop2
		dec bp
		cmp bp, 0
		jnz .loop1
	ret

delay2:
	mov bp, 5000
	.loop1:
		mov si, 5000
		.loop2:
			dec si
			cmp si, 0
			jnz .loop2
		dec bp
		cmp bp, 0
		jnz .loop1
	ret

prints:
	.loop:
		pusha
		call delay2
		popa
		lodsb
		cmp al, 0
		je .endloop
		call putchar
		jmp .loop
	.endloop:
	ret

endl:
	mov al, 10
	call putchar
	mov al, 13
	call putchar
	ret

limpaTela:
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10

  
    mov cx, 2000 
    mov bh, 0
    mov al, 0x20
    mov ah, 0x9
    int 0x10
    

    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
	ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

	mov bl, 10
	call limpaTela

    mov si, string
    call prints
    call endl
	call delay
	mov si, string2
    call prints
    call endl
	call delay
	call delay
	mov si, string3
    call prints
    call endl

	call delay

    mov ax, 0x7e0 ;0x7e0<<1 = 0x7e00 (início de kernel.asm)
    mov es, ax
    xor bx, bx    ;posição es<<1+bx

    jmp reset

reset:
    mov ah, 00h ;reseta o controlador de disco
    mov dl, 0   ;floppy disk
    int 13h
jc reset    ;se o acesso falhar, tenta novamente
    jmp load

load:
    mov ah, 02h ;lê um setor do disco
    mov al, 310  ;quantidade de setores ocupados pelo kernel
    mov ch, 0   ;track 0
    mov cl, 3   ;sector 3
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h

    jc load     ;se o acesso falhar, tenta novamente

    jmp 0x7e00  ;pula para o setor de endereco 0x7e00 (start do boot2)


