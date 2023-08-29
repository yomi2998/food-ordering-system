MEMBERREGISTRATION PROC    
    call cls

    LEA DX, memberreg
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
    jne membernamecheckcontinues
    CMP username + 3, '1'
    jne membernamecheckcontinues
    CMP username + 1, 2
    jne membernamecheckcontinues

    ret

membernamecheckcontinues:
    ; Check if username is too long or too short
    MOV CL, [username + 1]
    CMP CL, 8
    JA membernametooLong
    CMP CL, 2
    JB membernametooShort
    JMP memberusernameOk

    MOV DL, 10
    MOV AH, 2
    INT 21H

membernametooShort:
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
memberresetShortNameLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP memberresetShortNameLoop

    JMP MEMBERREGISTRATION

membernametooLong:
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
memberresetLongNameLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP memberresetLongNameLoop

    JMP MEMBERREGISTRATION
memberusernameOk:
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
memberfinalizeFilePath:
    mov al, [username + bx + 2]
    cmp al, '$'
    je memberdoneFinalize
    mov [membersearchFile + bx + 7], al
    inc bx
    jmp memberfinalizeFilePath
memberdoneFinalize:
    mov ah, 2
    mov dl, 10
    int 21h

    ; check if file exists
    mov ah, 43h
    mov al, 00h
    lea dx, membersearchFile
    int 21h
    jc memberfileNotFound
    
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
memberresetExistNameLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP memberresetExistNameLoop

    jmp MEMBERREGISTRATION
memberfileNotFound:
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
    jne memberpasscheckcontinues
    CMP password + 3, '1'
    jne memberpasscheckcontinues
    CMP password + 1, 2
    jne memberpasscheckcontinues

    ret

memberpasscheckcontinues:
    mov cl, [password + 1]
    cmp cl, 16
    ja memberpasstooLong
    cmp cl, 4
    jb memberpasstooShort
    jmp memberpasswordOk

memberpasstooShort:
    lea dx, passwordTooShort
    mov ah, 9
    int 21h

    mov dl, 10
    mov ah, 2
    int 21h

    call pause

    LEA DI, password
    MOV CX, 30
memberresetShortPassLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP memberresetShortPassLoop

    jmp memberfileNotFound
memberpasstooLong:
    lea dx, passwordTooLong
    mov ah, 9
    int 21h

    mov dl, 10
    mov ah, 2
    int 21h
    
    call pause

    LEA DI, password
    MOV CX, 30
memberresetLongPassLoop:
    MOV BYTE PTR [DI], '$'
    INC DI
    LOOP memberresetLongPassLoop

    jmp memberfileNotFound

memberpasswordOk:
    mov ah, 3ch
    mov cx, 0
    lea dx, membersearchFile
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
MEMBERREGISTRATION ENDP
