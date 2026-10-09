section .data
    init_term    db 27, '[?1049h', 27, '[2J', 27, '[H', 0
    len_init     equ $ - init_term

    exit_term    db 27, '[?1049l', 0
    len_exit     equ $ - exit_term

    ; --- Top Scrapbook Title Banner ---
    title_t1 db ' _    _                                       _     _', 0
    title_t2 db '/ \  |_) _       |_   |\/| _   (  _  _ _  _  |_) _ / \ |/ ', 0
    title_t3 db '\_/  |_) (_) |_| |_   |  |(/_  _) (_ | (_||_) |_) (_)\_)|  \', 0
    title_t4 db '                                          |                  ', 0

    ; --- Top Right Bunny Card ---
    card_01  db '+-----------------------+', 0
    card_02  db '| *                   * |', 0
    card_03  db '|      (\         /)    |', 0
    card_04  db '|     (  \       /  ) * |', 0
    card_05  db '|  *   (  \_---_/  )    |', 0
    card_06  db '|       /  o   o  \   * |', 0
    card_07  db '|      |     ^     |    |', 0
    card_08  db '|  *    \   ---   /     |', 0
    card_09  db '|      ( (")---(") )  * |', 0
    card_10  db '+-----------------------+', 0

    ; --- About Me Section ---
    abt_t1   db '+--[ ABOUT ME ]-----------------------------------------+', 0
    abt_name db '| Name:                                                 |', 0
    abt_mail db '| Email:                                                |', 0
    abt_web  db '| Blog/Web:                                             |', 0
    abt_b1   db '+-------------------------------------------------------+', 0

    ; --- My First Section with Trophies ---
    fst_t1   db '+--[ MY FIRST ]---------------------------------------------------------------+', 0
    fst_ach  db '| First big achievement:                                            \_/  \_/  |', 0
    fst_rsk  db '| First risk I ever took:                                           \ /  \ /  |', 0
    fst_hap  db '| First time I felt completely happy:                              (o-~)(o-~) |', 0
    fst_b1   db '+-----------------------------------------------------------------------------+', 0

    ; --- Widened My Faves Column ---
    fav_t1   db '+--[ MY FAVES ]-----------------------+', 0
    fav_c1   db '| * Color/s:                          |', 0
    fav_c2   db '| * Perfume:                          |', 0
    fav_c3   db '| * Music:                      [STAR]|', 0
    fav_c4   db '| * Singer/s:                         |', 0
    fav_c5   db '| * Song:                             |', 0
    fav_c6   db '| * Food:                         d b |', 0
    fav_b1   db '+-------------------------------------+', 0

    ; --- Widened Hobbies Column ---
    hob_t1   db '+--[ HOBBIES ]------------------------+', 0
    hob_c1   db '| Weekend:                            |', 0
    hob_c2   db '| TV Show:                            |', 0
    hob_c3   db '| Movie:                         -[=]-|', 0
    hob_c4   db '| Book:                          |(o)||', 0
    hob_c5   db '| Celebs:                         - - |', 0
    hob_c6   db '| Role model:                         |', 0
    hob_b1   db '+-------------------------------------+', 0

    ; --- Ambition & Motto Section ---
    amb_t1   db '+--[ AMBITION & MOTTO ]-------------------------------------------------------+', 0
    amb_row1 db '| AMBITION:                                                                   |', 0
    amb_row2 db '| MOTTO:                                                                      |', 0
    amb_b1   db '+-----------------------------------------------------------------------------+', 0

    ; --- Footer Bar ---
    ftr_bar  db '(^.^)======== Type info & press Enter per field. Last field exits ========(^.^)', 0

    backspace_seq db 8, ' ', 8

section .bss
    char_in       resb 1
    cursor_seq    resb 16
    orig_termios  resb 64
    raw_termios   resb 64

section .text
    global _start

%macro print_at 3
    mov eax, %1
    mov ebx, %2
    call move_cursor

    mov esi, %3
    call print_string
%endmacro

%macro read_at 3
    mov eax, %1
    mov ebx, %2
    call move_cursor

    mov ecx, %3
    call read_line
%endmacro

_start:
    ; 1. Enter non-canonical raw mode (disable ICANON and ECHO)
    mov eax, 54          ; sys_ioctl
    mov ebx, 0           ; stdin
    mov ecx, 0x5401      ; TCGETS
    mov edx, orig_termios
    int 0x80

    mov esi, orig_termios
    mov edi, raw_termios
    mov ecx, 16
    rep movsd

    and dword [raw_termios + 12], ~(0x0002 | 0x0008)
    mov byte [raw_termios + 23], 1
    mov byte [raw_termios + 22], 0

    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5402      ; TCSETS
    mov edx, raw_termios
    int 0x80

    ; 2. Switch to alternate screen buffer
    mov eax, 4
    mov ebx, 1
    mov ecx, init_term
    mov edx, len_init
    int 0x80

    ; 3. Draw Title Banner
    print_at 1, 3, title_t1
    print_at 2, 3, title_t2
    print_at 3, 3, title_t3
    print_at 4, 3, title_t4

    ; 4. Draw Bunny Card
    print_at 1, 56, card_01
    print_at 2, 56, card_02
    print_at 3, 56, card_03
    print_at 4, 56, card_04
    print_at 5, 56, card_05
    print_at 6, 56, card_06
    print_at 7, 56, card_07
    print_at 8, 56, card_08
    print_at 9, 56, card_09
    print_at 10, 56, card_10

    ; 5. Draw About Me Box
    print_at 6, 2, abt_t1
    print_at 7, 2, abt_name
    print_at 8, 2, abt_mail
    print_at 9, 2, abt_web
    print_at 10, 2, abt_b1

    ; 6. Draw My First Box
    print_at 11, 2, fst_t1
    print_at 12, 2, fst_ach
    print_at 13, 2, fst_rsk
    print_at 14, 2, fst_hap
    print_at 15, 2, fst_b1

    ; 7. Draw Faves & Hobbies
    print_at 16, 2, fav_t1
    print_at 17, 2, fav_c1
    print_at 18, 2, fav_c2
    print_at 19, 2, fav_c3
    print_at 20, 2, fav_c4
    print_at 21, 2, fav_c5
    print_at 22, 2, fav_c6
    print_at 23, 2, fav_b1

    print_at 16, 41, hob_t1
    print_at 17, 41, hob_c1
    print_at 18, 41, hob_c2
    print_at 19, 41, hob_c3
    print_at 20, 41, hob_c4
    print_at 21, 41, hob_c5
    print_at 22, 41, hob_c6
    print_at 23, 41, hob_b1

    ; 8. Draw Ambition & Motto
    print_at 24, 2, amb_t1
    print_at 25, 2, amb_row1
    print_at 26, 2, amb_row2
    print_at 27, 2, amb_b1

    ; 9. Draw Footer
    print_at 28, 2, ftr_bar

    ; --- Expanded Field Inputs (row, col, max_len) ---
    read_at 7, 10, 46     ; Name (was 30)
    read_at 8, 11, 45     ; Email (was 26)
    read_at 9, 14, 42     ; Blog/Web (was 22)

    read_at 12, 27, 40    ; First achievement (was 30)
    read_at 13, 28, 39    ; First risk (was 29)
    read_at 14, 39, 28    ; First happy (was 18)

    read_at 17, 15, 23    ; Color (was 14)
    read_at 18, 15, 23    ; Perfume (was 14)
    read_at 19, 15, 17    ; Music (was 14)
    read_at 20, 16, 22    ; Singer (was 15)
    read_at 21, 12, 26    ; Song (was 20)
    read_at 22, 12, 22    ; Food (was 20)

    read_at 17, 52, 26    ; Weekend (was 18)
    read_at 18, 52, 26    ; TV Show (was 18)
    read_at 19, 50, 21    ; Movie (was 16)
    read_at 20, 49, 22    ; Book (was 17)
    read_at 21, 51, 20    ; Celebs (was 15)
    read_at 22, 55, 23    ; Role model (was 16)

    read_at 25, 14, 64    ; Ambition (was 60)
    read_at 26, 14, 64    ; Motto (was 60)

    ; Restore terminal modes & exit
    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5402
    mov edx, orig_termios
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, exit_term
    mov edx, len_exit
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

move_cursor:
    push edi
    push edx
    push ecx
    push ebx
    push eax

    mov byte [cursor_seq], 27
    mov byte [cursor_seq+1], '['
    mov edi, cursor_seq + 2

    call append_num

    mov byte [edi], ';'
    inc edi

    mov eax, [esp + 4]
    call append_num

    mov byte [edi], 'H'
    inc edi

    mov edx, edi
    sub edx, cursor_seq
    mov ecx, cursor_seq
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop eax
    pop ebx
    pop ecx
    pop edx
    pop edi
    ret

read_line:
    push ebp
    mov ebp, esp
    push edi
    push ebx
    push ecx

    xor edi, edi

.read_char:
    push ecx
    mov eax, 3
    mov ebx, 0
    mov ecx, char_in
    mov edx, 1
    int 0x80
    pop ecx

    cmp eax, 0
    jle .done

    mov al, [char_in]
    cmp al, 10
    je .done
    cmp al, 13
    je .done

    cmp al, 8
    je .handle_backspace
    cmp al, 127
    je .handle_backspace

    cmp al, 32
    jl .read_char

    cmp edi, ecx
    jge .read_char

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, char_in
    mov edx, 1
    int 0x80
    pop ecx

    inc edi
    jmp .read_char

.handle_backspace:
    test edi, edi
    jz .read_char

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, backspace_seq
    mov edx, 3
    int 0x80
    pop ecx

    dec edi
    jmp .read_char

.done:
    pop ecx
    pop ebx
    pop edi
    mov esp, ebp
    pop ebp
    ret

append_num:
    cmp eax, 10
    jl .single_digit
    mov dl, 10
    div dl
    add al, '0'
    mov [edi], al
    inc edi
    mov al, ah
.single_digit:
    add al, '0'
    mov [edi], al
    inc edi
    ret

print_string:
    push esi
    mov ecx, esi
    xor edx, edx
.scan:
    cmp byte [esi + edx], 0
    je .done
    inc edx
    jmp .scan
.done:
    pop ecx
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret