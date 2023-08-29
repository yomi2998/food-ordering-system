MEMBERLOGIN PROC
    call cls
    lea dx, memberlog
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
    jne mbrproceedPasswordPrompt
    CMP username + 3, '1'
    jne mbrproceedPasswordPrompt
    CMP username + 1, 2
    jne mbrproceedPasswordPrompt
    ret

mbrproceedPasswordPrompt:
    lea dx, passwordLoginPrompt
    mov ah, 9
    int 21h

    lea dx, password
    mov ah, 0Ah
    int 21h

    call newline

    CMP password + 2, '-'
    jne mbrproceedCheckAccount
    CMP password + 3, '1'
    jne mbrproceedCheckAccount
    CMP password + 1, 2
    jne mbrproceedCheckAccount
    ret
    
mbrproceedCheckAccount:
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
memberfinalizeFilePath2:
    mov al, [username + bx + 2]
    cmp al, '$'
    je memberdoneFinalize2
    mov [membersearchFile + bx + 7], al
    inc bx
    jmp memberfinalizeFilePath2
memberdoneFinalize2:
    mov ah,3dh
    mov al, 0
    lea dx, membersearchFile
    int 21h
    jc memberfileNotFound2
    jmp memberfound
memberfileNotFound2:
    lea dx, invalidLogin
    mov ah, 9
    int 21h
    call pause
    jmp MEMBERLOGIN
memberfound:
    mov handler, ax
    mov bp, 0
loopscan:
    mov cx, 1
    lea dx, passwordBuffer[bp]
    mov bx, handler
    mov ah, 3fh
    int 21h

    inc bp

    test ax, ax
    jnz loopscan

    mov passwordBuffer[bp], '$'

    mov bx, handler
    mov ah, 3eh
    int 21h

    lea si, password + 2
    lea di, passwordBuffer
compareLoop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne memberloginFail
    inc si
    inc di
    loop compareLoop

    lea si, passwordBuffer
    mov cl, 0
    mov al, '$'
checkStrlenLoop:
    cmp al, [si]
    je checkStrlenDone
    inc cl
    inc si
    jmp checkStrlenLoop
checkStrlenDone:
    cmp cl, [password + 1]
    jne memberloginFail
    
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
loopCopy:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop loopCopy

    call pause
    ret

memberloginFail:
    call newline
    lea dx, invalidLogin
    mov ah, 9
    int 21h

    call pause
    jmp MEMBERLOGIN

MEMBERLOGIN ENDP