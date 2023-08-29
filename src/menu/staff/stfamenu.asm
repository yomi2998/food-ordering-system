STAFFADDMENU PROC
    ;add menu
    call cls

    lea dx, addMenuPrompt
    mov ah, 9
    int 21h

    lea dx, addMenuName
    mov ah, 0Ah
    int 21h

    call newline

    cmp addMenuName + 1, 2
    jb invalidMenuName
    cmp addMenuName + 1, 15
    ja invalidMenuName
    cmp addMenuName + 2, '-'
    jne noproblem
    cmp addMenuName + 3, '1'
    jne noproblem
    cmp addMenuName + 1, 2
    jne noproblem
    ret
invalidMenuName:
    lea dx, invalidMenuName
    mov ah, 9
    int 21h

    call pause

    jmp STAFFADDMENU
noproblem:
    lea dx, addMenuPricePrompt
    mov ah, 9
    int 21h

    lea dx, addMenuPrice
    mov ah, 0Ah
    int 21h

    call newline

    cmp addMenuPrice + 2, '-'
    jne proceed2ndcheck
    cmp addMenuPrice + 3, '1'
    jne proceed2ndcheck
    cmp addMenuPrice + 1, 2
    jne proceed2ndcheck
    ret

proceed2ndcheck:
    cmp addMenuPrice + 2, '-'
    je invalidMenuPrice

    mov cl, addMenuPrice + 1
    mov bx, 0
    mov di, addMenuPrice + 1
repeatpricecheck:
    inc di
    cmp di, '.'
    je incrementbx
    jne continuepricecheck
incrementbx:
    inc bx
    loop repeatpricecheck
continuepricecheck:
    cmp di, '0'
    jb invalidMenuPrice
    cmp di, '9'
    ja invalidMenuPrice
    loop repeatpricecheck
    cmp bx, 1
    ja invalidMenuPrice
    jmp noproblem2
invalidMenuPrice:
    lea dx, invalidValue
    mov ah, 9
    int 21h
    mov cx, 30
    mov di, addMenuPrice
priceresetloop:
    mov [di], '$'
    inc di
    loop priceresetloop
    jmp noproblem
noproblem2:
    ; SEEM CONVERSION
    RET
STAFFADDMENU ENDP