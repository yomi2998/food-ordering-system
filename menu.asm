membermenu proc
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, membermenuopt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    jb membermenu
    je membermenuview
    cmp al, '2'
    je membermenuorder
    cmp al, '3'
    ja membermenu
    je memberlogout
membermenuview:
    call viewmenu
    mov ah, 1
    int 21h
    jmp membermenu
membermenuorder:
    call ordermenu
    jmp membermenu
memberlogout:
    mov isLogin, 0
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, logoutSuccess
    int 21h

    mov ah, 1
    int 21h

    jmp main
membermenu endp
viewmenu proc
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 4eh
    mov al, 0
    lea dx, menuFile
    int 21h
    jnc viewmenufilefound

    mov ah, 9
    lea dx, menunotfound
    int 21h

    ret
viewmenufilefound:
    mov ah, 3dh
    mov al, 0
    lea dx, menuFile
    int 21h

    mov handler, ax

    mov menuCounter, 1
    lea si, menuContent + 11
    mov dx, menuCounter
    call numberMemoryWritterDX
    inc si
    mov byte ptr [si], "."
    inc si
    mov byte ptr [si], " " 
    inc si
loopreadmenufile:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    mov dx, si
    int 21h
    
    mov si, dx
    cmp byte ptr [si], 0ah
    je newCounter
    jne noNewCounter
newCounter:
    inc menuCounter
    inc si
    mov dx, menuCounter
    call numberMemoryWritterDX
    inc si
    mov byte ptr [si], "."
    inc si
    mov byte ptr [si], " "
noNewCounter:
    inc si
    test ax, ax
    jnz loopreadmenufile
    mov byte ptr [si - 1], "$"

    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 9
    lea dx ,menuContent
    int 21h
    ret
viewmenu endp
ordermenu proc
    call viewmenu

    mov ah, 9
    lea dx, orderMenuPrompt
    int 21h 

    mov ah, 0ah
    lea dx, orderMenuNumber
    int 21h

    cmp orderMenuNumber + 2, '0'
    je ordermenu
    cmp orderMenuNumber + 2, '-'
    jne ordermenucontinue
    cmp orderMenuNumber + 3, '1'
    jne ordermenucontinue
    cmp orderMenuNumber + 1, 2
    jne ordermenucontinue
    ret
ordermenucontinue:
    mov ah, 3dh
    mov al, 0
    lea dx, menuFile
    int 21h
    mov handler, ax

    mov menuCounter, 1

loopreadmenufile2:
    lea di, orderMenuNumber + 2
    call convertStringNumToPlainNum
    cmp menuCounter, bx
    je ordermenufound
    mov cx, 1
    mov ah, 3fh
    mov bx, handler
    lea dx, emptyBuffer
    int 21h

    cmp emptyBuffer, 0ah
    je newCounter2
    jne noNewCounter2
newCounter2:
    inc menuCounter
    lea di, orderMenuNumber + 2
    call convertStringNumToPlainNum
    cmp menuCounter, bx
    je ordermenufound
noNewCounter2:
    test ax, ax
    jnz loopreadmenufile2
    jmp ordermenu
ordermenufound:
    lea si, foodOrdered + 14
loopreadtargetmenu:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp emptyBuffer, '@'
    je ordermenunamescanend
    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    jmp loopreadtargetmenu
ordermenunamescanend:
    mov cx, 3
    mov ah, 3fh
    mov bx, handler
    lea dx, emptyBuffer
    int 21h
    mov byte ptr [si], '$'
    lea si, price
loopreadtargetmenuprice:
    mov cx, 1
    mov ah, 3fh
    mov bx, handler
    lea dx, emptyBuffer
    int 21h
    cmp cx, ax
    jne loopreadtargetmenupriceend
    cmp emptyBuffer, 13
    je loopreadtargetmenupriceend
    cmp emptyBuffer, 10
    je loopreadtargetmenupriceend
    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    test ax, ax
    jz loopreadtargetmenupriceend
    jmp loopreadtargetmenuprice
loopreadtargetmenupriceend:
    mov byte ptr [si], '$'
    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

confirmMemberOrder:
    mov ah, 0
    mov al, 3
    int 10h
    
    lea dx, foodOrdered
    mov ah, 9
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

    mov ah, 9
    lea dx, rmtag
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

    mov ah, 9
    lea dx, orderMenuAmountPrompt
    int 21h

    mov ah, 0ah
    lea dx, orderMenuAmount
    int 21h

    cmp orderMenuAmount + 2, '0'
    je confirmMemberOrder
    cmp orderMenuAmount + 2, '-'
    jne afterOrderMenuAmount
    cmp orderMenuAmount + 3, '1'
    jne confirmMemberOrder
    cmp orderMenuAmount + 1, 2
    jne confirmMemberOrder
    ret

afterOrderMenuAmount:
    mov ah, 0
    mov al, 3
    int 10h

    lea di, orderMenuAmount + 2
    call convertStringNumToPlainNum
    mov fmultemp, bx
    lea si, price
    call fMulCalc

    mov ah, 9
    lea dx, totalpriceprint
    int 21h

    mov ah, 9
    lea dx, orderTableNumPrompt
    int 21h

    mov ah, 0ah
    lea dx, orderTableNum
    int 21h

    cmp orderTableNum + 2, '0'
    je afterOrderMenuAmount
    cmp orderTableNum + 2, '-'
    jne proceedConfirmOrderPrompt
    cmp orderTableNum + 3, '1'
    jne afterOrderMenuAmount
    cmp orderTableNum + 1, 2
    jne afterOrderMenuAmount
    ret
proceedConfirmOrderPrompt:
    mov ah, 9
    lea dx, confirmOrderPrompt
    int 21h

    mov ah, 1
    int 21h

    cmp al, 'Y'
    je ordermenuconfirm
    cmp al, 'y'
    je ordermenuconfirm
    jmp ordermenu
ordermenuconfirm:
    lea si, orderFile + 6
    mov bx, 2
loopCopyOrderFileTableNum:
    cmp orderTableNum[bx], 13
    je loopCopyOrderFileTableNumEnd
    mov al, orderTableNum[bx]
    mov byte ptr [si], al
    inc si
    inc bx
    jmp loopCopyOrderFileTableNum
loopCopyOrderFileTableNumEnd:
    mov byte ptr [si], '.'
    inc si
    mov byte ptr [si], 't'
    inc si
    mov byte ptr [si], 'x'
    inc si
    mov byte ptr [si], 't'
    inc si
    mov byte ptr [si], 0

    mov ah, 4eh
    mov cx, 0
    lea dx, orderFile
    int 21h

    jc orderMenuCreateNewFile

    mov ah, 3dh
    mov al, 2
    lea dx, orderFile
    int 21h

    mov handler, ax

    mov ah, 42h
    mov bx, handler
    mov al, 2
    mov cx, 0
    mov dx, 0
    int 21h

    mov ah, 40h
    mov bx, handler
    mov cx, 2
    lea dx, newlineforfilewrite
    int 21h

orderMenuFileCheckPoint:
    lea si, foodOrdered + 14
loopCopyOrderFileFoodName:
    cmp byte ptr [si], '$'
    je afterLoopCopyFileFoodName
    mov ah, 40h
    mov bx, handler
    mov cx, 1
    mov dx, si
    int 21h
    inc si
    jmp loopCopyOrderFileFoodName
afterLoopCopyFileFoodName:
    mov ah, 40h
    mov bx, handler
    mov cx, 2
    lea dx, aliasspace
    int 21h
    
    lea si, supertemp
loopCopyOrderFileFoodPrice:
    cmp byte ptr [si], '$'
    je afterLoopCopyFileFoodPrice
    mov ah, 40h
    mov bx, handler
    mov cx, 1
    mov dx, si
    int 21h
    inc si
    jmp loopCopyOrderFileFoodPrice
orderMenuCreateNewFile:
    mov ah, 3ch
    mov cx, 0
    lea dx, orderFile
    int 21h
    mov handler, ax

    jmp orderMenuFileCheckPoint
afterLoopCopyFileFoodPrice:
    xor cx, cx
    mov cl, 3
    mov ah, 40h
    mov bx, handler
    lea dx, spacealiasspace
    int 21h
    mov cl, orderMenuAmount + 1
    mov ah, 40h
    mov bx, handler
    lea dx, orderMenuAmount + 2
    int 21h
    
    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 9
    lea dx, thankyou
    int 21h

    mov ah, 1
    int 21h
    ret
ordermenu endp
staffmenu proc
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, staffmenuopt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    jb staffmenu
    je staffmenuview
    cmp al, '7'
    ja staffmenu
    je stafflogout
    cmp al, '2'
    je staffmenuadd
    cmp al, '3'
    je staffmenuedit
    cmp al, '4'
    je staffmenudelete
    cmp al, '5'
    je staffmenucheckout
    cmp al, '6'
    je staffmenusummary
staffmenuview:
    call viewmenu
    mov ah, 1
    int 21h
    jmp staffmenu
staffmenuadd:
    call addmenu
    jmp staffmenu
staffmenuedit:
    call editmenu
    jmp staffmenu
staffmenudelete:
    call deletemenu
    jmp staffmenu
staffmenucheckout:
    call checkout
    jmp staffmenu
staffmenusummary:
    call summary
    jmp staffmenu
stafflogout:
    mov isLogin, 0
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, logoutSuccess
    int 21h

    mov ah, 1
    int 21h

    ret
staffmenu endp
addmenu proc
    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, menuNamePrompt
    int 21h

    mov ah, 0ah
    lea dx, menuName
    int 21h

    cmp menuName + 2, '-'
    jne addmenucontinue
    cmp menuName + 3, '1'
    jne addmenucontinue
    cmp menuName + 1, 2
    jne addmenucontinue
    ret
addmenucontinue:
    mov ah, 9
    lea dx, menuPricePrompt
    int 21h

    mov ah, 0ah
    lea dx, menuPrice
    int 21h

    cmp menuPrice + 2, '-'
    jne addmenucontinue2
    cmp menuPrice + 3, '1'
    jne addmenucontinue2
    cmp menuPrice + 1, 2
    jne addmenucontinue2
    ret
addmenucontinue2:
    mov ah, 9
    lea dx, menuConfirmPrompt
    int 21h

    mov ah, 1
    int 21h

    cmp al, 'Y'
    je addmenuconfirm
    cmp al, 'y'
    je addmenuconfirm
    jmp staffmenu
addmenuconfirm:
    mov ah, 4eh
    mov al, 0
    lea dx, menuFile
    int 21h

    jc addMenuCreateNewFile

    mov ah, 3dh
    mov al, 2
    lea dx, menuFile
    int 21h

    mov handler, ax

    mov ah, 42h
    mov bx, handler
    mov al, 2
    mov cx, 0
    mov dx, 0
    int 21h

    mov ah, 40h
    mov bx, handler
    mov cx, 2
    lea dx, newlineforfilewrite
    int 21h

addMenuFileCheckPoint:
    xor cx, cx
    mov cl, menuName + 1
    mov ah, 40h
    mov bx, handler
    lea dx, menuName + 2
    int 21h

    xor cx, cx
    mov cl, 5
    mov ah, 40h
    mov bx, handler
    lea dx, spacealiasspacerm
    int 21h

    xor cx, cx
    mov cl, menuPrice + 1
    mov ah, 40h
    mov bx, handler
    lea dx, menuPrice + 2
    int 21h

    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 9
    lea dx, menuSuccess
    int 21h
    
    mov ah, 1
    int 21h
    ret

addMenuCreateNewFile:
    mov ah, 3ch
    mov cx, 0
    lea dx, menuFile
    int 21h
    mov handler, ax

    jmp addMenuFileCheckPoint
    ret
addmenu endp
editmenu proc
    mov ah, 0
    mov al, 3
    int 10h

    call viewmenu

    mov ah, 4eh
    mov al, 0
    lea dx, menuFile
    int 21h
    jnc editmenufilefound
    ret
editmenufilefound:
    mov ah, 9
    lea dx, editMenuPrompt
    int 21h

    mov ah, 0ah
    lea dx, editMenuNumber
    int 21h

    cmp editMenuNumber + 2, '-'
    jne editmenucontinue
    cmp editMenuNumber + 3, '1'
    jne editmenucontinue
    cmp editMenuNumber + 1, 2
    jne editmenucontinue
    ret

editmenucontinue:
    lea di, editMenuNumber + 2
    call convertStringNumToPlainNum
    cmp bx, menuCounter
    ja editmenu

    mov ah, 9
    lea dx, editMenuNamePrompt
    int 21h

    mov ah, 0ah
    lea dx, editMenuName
    int 21h

    cmp editMenuName + 2, '-'
    jne editmenucontinue2
    cmp editMenuName + 3, '1'
    jne editmenucontinue2
    cmp editMenuName + 1, 2
    jne editmenucontinue2
    ret

editmenucontinue2:
    mov ah, 9
    lea dx, editMenuPricePrompt
    int 21h

    mov ah, 0ah
    lea dx, editMenuPrice
    int 21h

    cmp editMenuPrice + 2, '-'
    jne editmenucontinue3
    cmp editMenuPrice + 3, '1'
    jne editmenucontinue3
    cmp editMenuPrice + 1, 2
    jne editmenucontinue3
    ret

editmenucontinue3:
    mov ah, 9
    lea dx, editMenuConfirmPrompt
    int 21h

    mov ah, 1
    int 21h

    cmp al, 'Y'
    je editmenuconfirm
    cmp al, 'y'
    je editmenuconfirm
    ret

editmenuconfirm:
    mov ah, 3dh
    mov al, 0
    lea dx, menuFile
    int 21h

    mov handler, ax

    mov ah, 3ch
    mov cx, 0
    lea dx, tempFile
    int 21h

    mov handler2, ax

    mov menuCounter, 1
    lea di, editMenuNumber + 2
    call convertStringNumToPlainNum
    cmp bx, menuCounter
    je loopreadandwritemenufileend
loopreadandwritemenufile:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp emptyBuffer, 0ah
    je newCounter3
    jne noNewCounter3
newCounter3:
    inc menuCounter
    lea di, editMenuNumber + 2
    call convertStringNumToPlainNum
    cmp menuCounter, bx
    je loopreadandwritemenufileend
noNewCounter3:
    jmp loopreadandwritemenufile
    ret
loopreadandwritemenufileend:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    mov scanResult, ax
    cmp cx, ax
    jne loopreadandwritemenufileend2

    cmp emptyBuffer, 0ah
    jne loopreadandwritemenufileend
loopreadandwritemenufileend2:
    mov ah, 40h
    mov bx, handler2
    xor cx, cx
    mov cl, editMenuName + 1
    lea dx, editMenuName + 2
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 5
    lea dx, spacealiasspacerm
    int 21h

    mov ah, 40h
    mov bx, handler2
    xor cx, cx
    mov cl, editMenuPrice + 1
    lea dx, editMenuPrice + 2
    int 21h

    mov cx, 1
    cmp scanResult, cx
    jne loopreadandwritemenufile2

    mov ah, 40h
    mov bx, handler2
    mov cx, 2
    lea dx, newlineforfilewrite
    int 21h
loopreadandwritemenufile2:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp cx, ax
    jne loopreadandwritemenufileend3

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    jmp loopreadandwritemenufile2

loopreadandwritemenufileend3:
    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 3eh
    mov bx, handler2
    int 21h

    mov ah, 41h
    lea dx, menuFile
    int 21h

    mov ah, 3ch
    mov cx, 0
    lea dx, menuFile
    int 21h

    mov handler, ax

    mov ah, 3dh
    mov al, 0
    lea dx, tempFile
    int 21h

    mov handler2, ax

superrwedit:
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp cx, ax
    jne superrweditend

    mov ah, 40h
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    jmp superrwedit

superrweditend:
    mov ah, 3eh
    mov bx, handler2
    int 21h

    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 41h
    lea dx, tempFile
    int 21h
    
    mov ah, 9
    lea dx, editMenuSuccess
    int 21h

    mov ah, 1
    int 21h

    ret
editmenu endp
deletemenu proc
    mov ah, 0
    mov al, 3
    int 10h

    call viewmenu

    mov ah, 9
    lea dx, deleteMenuPrompt
    int 21h

    mov ah, 0ah
    lea dx, deleteMenuNumber
    int 21h

    cmp deleteMenuNumber + 2, '-'
    jne deletemenucontinue
    cmp deleteMenuNumber + 3, '1'
    jne deletemenucontinue
    cmp deleteMenuNumber + 1, 2
    jne deletemenucontinue
    ret

deletemenucontinue:
    lea di, deleteMenuNumber + 2
    call convertStringNumToPlainNum
    cmp bx, menuCounter
    ja deletemenu

    mov ah, 9
    lea dx, deleteMenuConfirmPrompt
    int 21h

    mov ah, 1
    int 21h

    cmp al, 'Y'
    je deletemenuconfirm
    cmp al, 'y'
    je deletemenuconfirm
    ret
deletemenuconfirm:
    mov ah, 3dh
    mov al, 0
    lea dx, menuFile
    int 21h

    mov handler, ax

    mov ah, 3ch
    mov cx, 0
    lea dx, tempFile
    int 21h

    mov handler2, ax

    mov menuCounter, 1
    lea di, deleteMenuNumber + 2
    call convertStringNumToPlainNum
    cmp bx, menuCounter
    je loopreadandwritemenufileend4
loopreadandwritemenufile4:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp emptyBuffer, 13
    je newCounter4

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    jne noNewCounter4
newCounter4:
    inc menuCounter
    lea di, deleteMenuNumber + 2
    call convertStringNumToPlainNum
    cmp menuCounter, bx
    je ploopreadandwritemenufileend4

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
noNewCounter4:
    jmp loopreadandwritemenufile4
    ret
ploopreadandwritemenufileend4:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
loopreadandwritemenufileend4:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp cx, ax
    jne loopreadandwritemenufileend5
    cmp emptyBuffer, 0ah
    jne loopreadandwritemenufileend4
    je loopreadandwritemenufileend5ex
loopreadandwritemenufileend5ex:
    mov bx, 1
    cmp bx, menuCounter
    je loopreadandwritemenufileend5
    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
loopreadandwritemenufileend5:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp ax, cx
    jne loopreadandwritemenufileend6
    
    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    jmp loopreadandwritemenufileend5

loopreadandwritemenufileend6:
    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 3eh
    mov bx, handler2
    int 21h

    mov ah, 41h
    lea dx, menuFile
    int 21h

    mov ah, 3ch
    mov cx, 0
    lea dx, menuFile
    int 21h

    mov handler, ax

    mov ah, 3dh
    mov al, 0
    lea dx, tempFile
    int 21h

    mov handler2, ax

superrwdelete:
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp cx, ax
    jne superrwdeleteend

    mov ah, 40h
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    jmp superrwdelete

superrwdeleteend:
    mov ah, 3eh
    mov bx, handler2
    int 21h

    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 41h
    lea dx, tempFile
    int 21h
    
    mov ah, 9
    lea dx, deleteMenuSuccess
    int 21h

    mov ah, 1
    int 21h

    ret
deletemenu endp
checkout proc
    mov ah, 0
    mov al, 3
    int 10h

    lea si, subtotal
    mov byte ptr [si], '0'
    mov byte ptr [si + 1], '.'
    mov byte ptr [si + 2], '0'
    mov byte ptr [si + 3], '0'
    mov byte ptr [si + 4], '$'

    lea si, supertemp
    mov byte ptr [si], '0'
    mov byte ptr [si + 1], '.'
    mov byte ptr [si + 2], '0'
    mov byte ptr [si + 3], '0'
    mov byte ptr [si + 4], '$'

    mov ah, 9
    lea dx, checkoutPrompt
    int 21h

    mov ah, 0ah
    lea dx, checkoutTableNumber
    int 21h

    cmp checkoutTableNumber + 2, '-'
    jne checkoutcontinue
    cmp checkoutTableNumber + 3, '1'
    jne checkoutcontinue
    cmp checkoutTableNumber + 1, 2
    jne checkoutcontinue
    ret

checkoutcontinue:
    lea si, orderFile + 6
    mov bx, 2
loopCopyOrderFileTableNum2:
    cmp checkoutTableNumber[bx], 13
    je loopCopyOrderFileTableNumEnd2
    mov al, checkoutTableNumber[bx]
    mov byte ptr [si], al
    inc si
    inc bx
    jmp loopCopyOrderFileTableNum2
loopCopyOrderFileTableNumEnd2:
    mov byte ptr [si], '.'
    inc si
    mov byte ptr [si], 't'
    inc si
    mov byte ptr [si], 'x'
    inc si
    mov byte ptr [si], 't'
    inc si
    mov byte ptr [si], 0

    mov ah, 3dh
    mov al, 0
    lea dx, orderFile
    int 21h

    mov handler, ax

    jc erroropenfile

    mov ah, 3dh
    mov al, 2
    lea dx, summaryFile
    int 21h
    jnc updatesummaryfile

    mov ah, 3ch
    mov cx, 0
    lea dx, summaryFile
    int 21h
updatesummaryfile:
    mov handler2, ax

    mov ah, 42h
    mov bx, handler2
    mov al, 2
    mov cx, 0
    mov dx, 0
    int 21h
    
    jmp begincheckoutreadfile

erroropenfile:
    lea dx, orderFileNotFound
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h
    jmp checkout

begincheckoutreadfile:
    call checkoutreader

    cmp emptyBuffer, 10
    je begincheckoutreadfile

    mov ah, 9
    lea dx, subtotalprint
    int 21h

    lea dx, supertemp
    int 21h

    lea si, supertemp
    lea di, subtotal
    mov cx, 15
loopcopytosubtotal:
    mov al, byte ptr [si]
    mov byte ptr [di], al
    inc si
    inc di
    loop loopcopytosubtotal
    lea si, subtotal
    call discountCalc
    
    mov ah, 9
    lea dx, discountprint
    int 21h

    lea dx, supertemp
    int 21h

    lea si, subtotal
    lea di, supertemp
    call fSubCalc

    lea si, supertemp
    lea di, subtotal
    mov cx, 15
loopcopytosubtotal2:
    mov al, byte ptr [si]
    mov byte ptr [di], al
    inc si
    inc di
    loop loopcopytosubtotal2

    lea si, supertemp
    call taxCalc
    
    mov ah, 9
    lea dx, taxprint
    int 21h
    lea dx, supertemp
    int 21h

    lea si, subtotal
    lea di, supertemp
    call fAddCalc

    mov ah, 9
    lea dx, totalpriceprint
    int 21h

    lea si, supertemp
    lea di, subtotal
    mov cx, 15
loopcopytosubtotal3:
    mov al, byte ptr [si]
    mov byte ptr [di], al
    inc si
    inc di
    loop loopcopytosubtotal3

ensureenoughmoney:
    lea si, subtotal
    lea di, supertemp
    mov cx, 15
loopcopytosubtotal4:
    mov al, byte ptr [si]
    mov byte ptr [di], al
    inc si
    inc di
    loop loopcopytosubtotal4

    mov ah, 9
    lea dx, membercash
    int 21h

    mov ah, 0ah
    lea dx, membercashstr
    int 21h

    cmp membercashstr + 2, '0'
    jb ensureenoughmoney
    cmp membercashstr + 2, '9'
    ja ensureenoughmoney
    cmp membercashstr + 1, 1
    je ensureenoughmoney

    lea si, membercashstr + 2
    lea di, supertemp
    call fSubCalc

    cmp notEnoughMoney, 1
    jne checkoutcontinue2

    mov ah, 9
    lea dx, notEnoughMoneyPrint
    int 21h

    jmp ensureenoughmoney
checkoutcontinue2:
    mov ah, 9
    lea dx, changeprint
    int 21h

    lea dx, supertemp
    int 21h

    lea dx, thankyoucheckout
    int 21h
    
    mov ah, 1
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 2
    lea dx, newlineforfilewrite
    int 21h
    
    mov ah, 3eh
    mov bx, handler
    int 21h

    mov ah, 3eh
    mov bx, handler2
    int 21h

    mov ah, 41h
    lea dx, orderFile
    int 21h
    ret
    
checkout endp
checkoutreader proc
    lea si, foodBuffer
checkoutfilefound:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    
    cmp emptyBuffer, '@'
    je checkoutpricescan
    
    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    jmp checkoutfilefound

checkoutpricescan:
    mov byte ptr [si - 1], '$'
    lea si, foodPrice

    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
checkoutpricescanloop:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp emptyBuffer, 32
    je checkoutpricescanend

    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    jmp checkoutpricescanloop
checkoutpricescanend:
    mov byte ptr [si], '$'

    lea si, foodAmount
    mov ah, 3fh
    mov bx, handler
    mov cx, 2
    lea dx, emptyBuffer
    int 21h

    mov ah, 40h
    mov bx, handler2
    mov cx, 2
    lea dx, emptyBuffer
    int 21h
checkoutamountscanloop:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    cmp cx, ax
    jne donereadalineforcheckout

    cmp emptyBuffer, 10
    je donereadalineforcheckout
    
    mov ah, 40h
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h

    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    jmp checkoutamountscanloop

donereadalineforcheckout:
    mov byte ptr [si], '$'
    mov ah, 9
    lea dx, printFoodCheckout
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

    mov ah, 9
    lea dx, printAmountCheckout
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

    mov ah, 9
    lea dx, printPriceCheckout
    int 21h

    mov ah, 1
    int 21h

    mov ah, 2
    mov dl, 10
    int 21h

    lea si, supertemp
    lea di, foodPrice
    call fAddCalc
    ret
checkoutreader endp
