STAFFLOGIN PROC
    call cls
    lea dx, stafflog
    mov ah, 9
    int 21h

    lea dx, usernameLoginPrompt
    mov ah, 9
    int 21h

    lea dx, username
    mov ah, 0Ah
    int 21h

    call newline

    CMP username + 2, '-'
    jne staffproceedPasswordPrompt
    CMP username + 3, '1'
    jne staffproceedPasswordPrompt
    CMP username + 1, 2
    jne staffproceedPasswordPrompt
    ret

staffproceedPasswordPrompt:
    lea dx, passwordLoginPrompt
    mov ah, 9
    int 21h

    lea dx, password
    mov ah, 0Ah
    int 21h

    call newline

    CMP password + 2, '-'
    jne staffproceedCheckAccount
    CMP password + 3, '1'
    jne staffproceedCheckAccount
    CMP password + 1, 2
    jne staffproceedCheckAccount
    ret

staffproceedCheckAccount:
    ; get the length of the filename
    mov cl, [username + 1]
    xor ch, ch

    ; add the .txt extension to the filename
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
stafffinalizeFilePath2:
    mov al, [username + bx + 2]
    cmp al, '$'
    je staffdoneFinalize2
    mov [staffsearchFile + bx + 6], al
    inc bx
    jmp stafffinalizeFilePath2
staffdoneFinalize2:
    mov ah,3dh
    mov al, 0
    lea dx, staffsearchFile
    int 21h
    jc stafffileNotFound2
    jmp stafffound
stafffileNotFound2:
    lea dx, invalidLogin
    mov ah, 9
    int 21h
    call pause
    jmp STAFFLOGIN
stafffound:
    mov handler, ax
    mov bp, 0
loopscan2:
    mov cx, 1
    lea dx, passwordBuffer[bp]
    mov bx, handler
    mov ah, 3fh
    int 21h

    inc bp

    test ax, ax
    jnz loopscan2

    mov passwordBuffer[bp], '$'

    mov bx, handler
    mov ah, 3eh
    int 21h

    lea si, password + 2
    lea di, passwordBuffer
compareLoop2:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne staffloginFail2
    inc si
    inc di
    loop compareLoop2

    lea si, passwordBuffer
    mov cl, 0
    mov al, '$'
checkStrlenLoop2:
    cmp al, [si]
    je checkStrlenDone2
    inc cl
    inc si
    jmp checkStrlenLoop2
checkStrlenDone2:
    cmp cl, [password + 1]
    jne staffloginFail2
    
    lea dx, loginSuccess
    mov ah, 9
    int 21h

    mov isLogin, 1

    mov cl, [username + 1]
    lea si, [username + 2]
    add si, cx
    mov byte ptr [si], '$'

    lea di, currentAccount
    lea si, [username + 2]
loopCopy2:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop loopCopy2

    call pause
    ret

staffloginFail2:
    call newline
    lea dx, invalidLogin
    mov ah, 9
    int 21h

    call pause
    jmp STAFFLOGIN

STAFFLOGIN ENDP