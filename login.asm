plogin proc
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, loginopt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    jb plogin
    cmp al, '3'
    ja plogin
    je loginexit
    
    mov usertype, al
    jmp gologin
loginexit:
    ret
    
gologin:
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, usernameLoginPrompt
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
    jne logincontinue
    cmp username + 3, '1'
    jne logincontinue
    cmp username + 1, 2
    jne logincontinue
    ret
logincontinue:
    mov ah, 9
    lea dx, passwordLoginPrompt
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
    jne logincontinue2
    cmp password + 3, '1'
    jne logincontinue2
    cmp password + 1, 2
    jne logincontinue2
    ret
logincontinue2:
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
linkfilepath:
    mov al, [username + bx + 2]
    cmp al, '$'
    je linkfilepathexit
    cmp usertype, '1'
    je ismemberloginlink
    cmp usertype, '2'
    je isstaffloginlink

ismemberloginlink:
    mov [membersearchFile + bx + 7], al
    inc bx
    jmp linkfilepath
isstaffloginlink:
    mov [staffsearchFile + bx + 6], al
    inc bx
    jmp linkfilepath
linkfilepathexit:
    mov ah,3dh
    mov al, 0
    cmp usertype, '1'
    je ismemberloginfile
    cmp usertype, '2'
    je isstaffloginfile
ismemberloginfile:
    mov [membersearchFile + bx + 7], 0
    lea dx, membersearchFile
    jmp aftercmpfile
isstaffloginfile:
    mov [staffsearchFile + bx + 6], 0
    lea dx, staffsearchFile
aftercmpfile:
    int 21h
    jnc loginfilefound

    mov dl, 10
    mov ah, 2
    int 21h

    lea dx, invalidLogin
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h

    mov ah, 0
    mov al, 3
    int 10h

    jmp gologin
loginfilefound:
    mov handler, ax
    mov bp, 0
loginloopscan:
    mov cx, 1
    lea dx, passwordBuffer[bp]
    mov bx, handler
    mov ah, 3fh
    int 21h

    inc bp

    test ax, ax
    jnz loginloopscan

    mov passwordBuffer[bp], '$'

    mov bx, handler
    mov ah, 3eh
    int 21h

    lea si, password + 2
    lea di, passwordBuffer
    xor cx, cx
    mov cl, [password + 1]
    mov bx, cx
    cmp passwordBuffer[bx], '$'
    jne notmatchlogin
loginCompareLoop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne notmatchlogin
    inc si
    inc di
    cmp al, '$'
    jne loginCompareLoop
    jmp afterloginCompareLoop
notmatchlogin:
    mov dl, 10
    mov ah, 2
    int 21h

    lea dx, invalidLogin
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h

    mov ah, 0
    mov al, 3
    int 10h

    jmp gologin

afterloginCompareLoop:
    lea si, passwordBuffer
    mov cl, 0
    mov al, '$'
loginCheckStrlenLoop:
    cmp al, [si]
    je loginCheckStrlenDone
    inc cl
    inc si
    jmp loginCheckStrlenLoop
loginCheckStrlenDone:
    cmp cl, [password + 1]
    je strlenloginmatch

    mov dl, 10
    mov ah, 2
    int 21h

    lea dx, invalidLogin
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h

    mov ah, 0
    mov al, 3
    int 10h

    jmp gologin

strlenloginmatch:
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
loginLoopCopy:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop loginLoopCopy

    mov ah, 1
    int 21h

    call menudistribution
    ret
plogin endp