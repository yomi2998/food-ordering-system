pregister proc
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, registeropt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    jb pregister
    cmp al, '3'
    ja pregister
    je registerexit
    mov usertype, al
    jmp goregister
registerexit:
    ret
goregister:
    mov ah, 0
    mov al, 3
    int 10h

    lea si, username
    lea di, password
    mov cx, 30
loopresetusernameandpassword:
    mov al, '$'
    mov byte ptr [si], al
    mov byte ptr [di], al
    inc si
    inc di
    loop loopresetusernameandpassword

    mov ah, 9
    lea dx, usernameRegisterPrompt
    int 21h

    mov ah, 0ah
    lea dx, username
    int 21h

    xor bx, bx
    mov bl, [username + 1]
    mov username[bx + 2], '$'

    mov ah, 2
    mov dl, 10
    int 21h

    cmp username + 2, '-'
    jne registercontinue
    cmp username + 3, '1'
    jne registercontinue
    cmp username + 1, 2
    jne registercontinue
    ret
registercontinue:
    mov ah, 9
    lea dx, passwordRegisterPrompt
    int 21h

    mov ah, 0ah
    lea dx, password
    int 21h

    xor bx, bx
    mov bl, [password + 1]
    mov password[bx + 2], '$'

    mov ah, 2
    mov dl, 10
    int 21h

    cmp password + 2, '-'
    jne registercontinue2
    cmp password + 3, '1'
    jne registercontinue2 
    cmp password + 1, 2
    jne registercontinue2
    ret
registercontinue2:
    mov cl, [username + 1]
    xor ch, ch

    lea si, [username + 2]
    add si, cx
    mov byte ptr [si], '.'
    inc si
    mov byte ptr [si], 't'
    inc si
    mov byte ptr [si], 'x'
    inc si
    mov byte ptr [si], 't'
    inc si
    mov byte ptr [si], '$'

    xor bx, bx
linkfilepath2:
    mov al, [username + bx + 2]
    cmp al, '$'
    je linkfilepathexit2
    cmp usertype, '1'
    je ismemberregisterlink
    cmp usertype, '2'
    je isstaffregisterlink
ismemberregisterlink:
    mov [membersearchFile + bx + 7], al
    inc bx
    jmp linkfilepath2
isstaffregisterlink:
    mov [staffsearchFile + bx + 6], al
    inc bx
    jmp linkfilepath2
linkfilepathexit2:
    mov ah, 3dh
    mov al, 0
    cmp usertype, '1'
    je ismemberregisterfile
    cmp usertype, '2'
    je isstaffregisterfile
ismemberregisterfile:
    lea dx, membersearchFile
    jmp aftercmpfile2
isstaffregisterfile:
    lea dx, staffsearchFile
aftercmpfile2:
    int 21h
    jc canBeRegistered

    mov ah, 9
    lea dx, usernameTaken
    int 21h

    mov ah, 1
    int 21h

    mov ah, 0
    mov al, 3
    int 10h

    jmp goregister
canBeRegistered:
    mov ah, 3ch
    mov cx, 0
    cmp usertype, '1'
    je ismemberregisterfile2
    cmp usertype, '2'
    je isstaffregisterfile2
ismemberregisterfile2:
    lea dx, membersearchFile
    jmp aftercmpfile3
isstaffregisterfile2:
    lea dx, staffsearchFile
aftercmpfile3:
    int 21h

    mov handler, AX
    mov ah, 40h
    mov bx, handler
    mov cl, [password + 1]
    lea dx, [password + 2]
    int 21h

    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 9
    lea dx, registerSuccess
    int 21h

    mov ah, 1
    int 21h

    ret

pregister endp