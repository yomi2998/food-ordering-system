STAFFMENU PROC
;STAFF MENU
    jmp procbegins
stflogout:
    mov isLogin, 0
    lea di, currentAccount
    mov cx, 30
clearstaffaccount:
    mov byte ptr [di], '$'
    inc di
    loop clearstaffaccount
    ret
procbegins:
    call cls
    ;staffmenuopt db "Welcome to PandaFood", 10, "1. Add new menu", 10, "2. Edit menu", 10, "3. Delete menu", 10, "4. Search menu", 10, "5. View all menu", 10, "6. Print summary", 10, "7. Logout", 10, "Enter your choice: $"
    lea dx, staffmenuopt
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h
    
    cmp al, '1'
    je stfaddmenu
    cmp al, '2'
    je stfeditmenu
    cmp al, '3'
    je stfdeletemenu
    cmp al, '4'
    je stfsearchmenu
    cmp al, '5'
    je stfviewmenu
    cmp al, '6'
    je stfprintsummary
    cmp al, '7'
    je stflogout
    jmp STAFFMENU
    RET
stfaddmenu:
    call STAFFADDMENU
    ret
stfeditmenu:
    call STAFFEDITMENU
    ret
stfdeletemenu:
    call STAFFDELETEMENU
    ret
stfsearchmenu:
    call STAFFSEARCHMENU
    ret
stfviewmenu:
    call STAFFVIEWMENU
    ret
stfprintsummary:
    call STAFFPRINTSUMMARY
    ret
STAFFMENU ENDP