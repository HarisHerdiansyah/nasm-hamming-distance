org 0x100

section .text
start:
    mov dx, prompt_str1
    call output_str
    mov dx, buffer_str1
    call read_str

    mov dx, prompt_str2
    call output_str
    mov dx, buffer_str2
    call read_str

    mov al, [buffer_str1 + 1]
    mov bl, [buffer_str2 + 1]
    cmp al, bl
    jne length_not_same

    call new_line
    mov cl, [buffer_str1 + 1]
    xor bx, bx
    lea si, [buffer_str1 + 2]
    lea di, [buffer_str2 + 2]

cmp_loop:
    mov al, [si]
    cmp al, [di]
    jne skip_inc
    inc bx

skip_inc:
    inc si
    inc di
    loop cmp_loop

    mov ax, bx
    call num_to_ascii
    mov dx, similarity_msg
    call output_str
    mov dx, similarity_val
    call output_str
	mov dx, separator
	call output_str

    mov al, [buffer_str1 + 1]
    xor ah, ah
    call num_to_ascii
    mov dx, total_char_val
    call output_str
    call new_line

    mov ah, 4Ch
    xor al, al
    int 21h

; --------------------------------------

length_not_same:
    mov dx, len_mismatch_msg
    call output_str
    call new_line
    mov ah, 4Ch
    mov al, 1
    int 21h

; --------------------------------------

output_str:
    push dx
    mov ah, 09h
    int 21h
    pop dx
    ret

read_str:
    push dx
    mov ah, 0Ah
    int 21h
    call new_line
    mov si, dx
    mov bl, [si + 1]
    mov byte [si + 2 + bx], '$'
    pop dx
    ret

new_line:
    push ax
    push dx
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    pop dx
    pop ax
    ret

num_to_ascii:
    mov cx, 10
    xor dx, dx
    div cx
    add al, '0'
    mov [similarity_val], al
    add dl, '0'
    mov [similarity_val + 1], dl
    mov [total_char_val], al
    mov [total_char_val + 1], dl
    ret

; --------------------------------------

section .data
    prompt_str1: db 'Masukkan Jawaban Benar: $'
    buffer_str1: db 80, 0
                 times 80 db 0

    prompt_str2: db 'Masukkan Jawaban yang Akan Diperiksa: $'
    buffer_str2: db 80, 0
                 times 80 db 0

    len_mismatch_msg: db 'Panjang input tidak sama. Program dihentikan.$'
    similarity_msg: db 'Jawaban Benar: $'
    similarity_val: db '00$'
    total_char_val: db '00$'
	
    separator: db '/$'
