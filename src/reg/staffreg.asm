STAFFREGISTRATION PROC    
    call cls

    LEA DX, staffreg
    MOV AH, 9
    INT 21H

    ; Prompt for username
    MOV AH, 9
    LEA DX, usernamePrompt
    INT 21H

    ; Get username
    MOV AH, 0AH
    LEA DX, username
    INT 21H

    CMP username + 2, '-'
    jne staffnamecheckcontinues
    CMP username + 3, '1'
    jne staffnamecheckcontinues
    CMP username + 1, 2
    jne staffnamecheckcontinues

    ret

staffnamecheckcontinues:
    ; Check if username is too long or too short
    MOV CL, [username + 1]
    CMP CL, 8
    JA staffnametooLong
    CMP CL, 2
    JB staffnametooShort
    JMP staffusernameOk

    MOV DL, 10
    MOV AH, 2
    INT 21H

staffnametooShort:
    ; Username is too short
    MOV AH, 9
    LEA DX, usernameTooShort
    INT 21H

    MOV DL, 10
    MOV AH, 2
    INT 21H

    call pause

    LEA DI, username
    MOV CX, 30
staffresetShortNameLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP staffresetShortNameLoop

    JMP STAFFREGISTRATION

staffnametooLong:
    ; Username is too long
    MOV AH, 9
    LEA DX, usernameTooLong
    INT 21H

    MOV DL, 10
    MOV AH, 2
    INT 21H

    call pause

    LEA DI, username
    MOV CX, 30
staffresetLongNameLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP staffresetLongNameLoop

    JMP STAFFREGISTRATION
staffusernameOk:
    ; get the length of the filename
    mov cl, [username + 1]
    mov ch, 0

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
stafffinalizeFilePath:
    mov al, [username + bx + 2]
    cmp al, '$'
    je staffdoneFinalize
    mov [staffsearchFile + bx + 6], al
    inc bx
    jmp stafffinalizeFilePath
staffdoneFinalize:
    mov ah, 2
    mov dl, 10
    int 21h

    ; check if file exists
    mov ah, 43h
    mov al, 00h
    lea dx, staffsearchFile
    int 21h
    jc stafffileNotFound
    
    ; file found
    mov ah, 9
    lea dx, usernameExist
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

    call pause

    LEA DI, username
    MOV CX, 30
staffresetExistNameLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP staffresetExistNameLoop

    jmp STAFFREGISTRATION
stafffileNotFound:
    CALL cls
    ; file not found
    lea dx, passwordPrompt
    mov ah, 9
    int 21h

    lea dx, password
    mov ah, 0Ah
    int 21h

    mov dl, 10
    mov ah, 2
    int 21h

    CMP password + 2, '-'
    jne staffpasscheckcontinues
    CMP password + 3, '1'
    jne staffpasscheckcontinues
    CMP password + 1, 2
    jne staffpasscheckcontinues

    ret

staffpasscheckcontinues:
    mov cl, [password + 1]
    cmp cl, 16
    ja staffpasstooLong
    cmp cl, 4
    jb staffpasstooShort
    jmp staffpasswordOk

staffpasstooShort:
    lea dx, passwordTooShort
    mov ah, 9
    int 21h

    mov dl, 10
    mov ah, 2
    int 21h

    call pause

    LEA DI, password
    MOV CX, 30
staffresetShortPassLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP staffresetShortPassLoop

    jmp stafffileNotFound
staffpasstooLong:
    lea dx, passwordTooLong
    mov ah, 9
    int 21h

    mov dl, 10
    mov ah, 2
    int 21h

    call pause

    LEA DI, password
    MOV CX, 30
staffresetLongPassLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP staffresetLongPassLoop

    jmp stafffileNotFound

staffpasswordOk:
    mov ah, 3ch
    mov cx, 0
    lea dx, staffsearchFile
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
    lea dx, regSuccess
    int 21h

    call pause
    
    RET
STAFFREGISTRATION ENDP
