summary proc
    mov ah, 0
    mov al, 3
    int 10h
    mov eof, 0
    mov priceAccumulator[2], "0"
    mov priceAccumulator[3], "."
    mov priceAccumulator[4], "0"
    mov priceAccumulator[5], "$"
    mov ah, 4eh
    lea dx, menuFile
    mov al, 0
    int 21h
    jc openfilenotok
    mov ah, 4eh
    lea dx, summaryFile
    mov al, 0
    int 21h
    jc openfilenotok
    jnc openfileok
openfilenotok:
    mov ah, 9
    lea dx, menuFileNotFound
    int 21h
    ret
openfileok:
    mov ah, 9
    lea dx, summaryReportPrint
    int 21h
    lea dx, summaryHeader
    int 21h
    lea dx, summaryColumn
    int 21h
    lea dx, summaryMidline
    int 21h

    call openMenuFile

repeatPrintSummary:
    lea si, supertemp
    lea di, totalPrice
    mov byte ptr [si], "0"
    mov byte ptr [di], "0"
    inc si
    inc di
    mov byte ptr [si], "."
    mov byte ptr [di], "."
    inc si
    inc di
    mov byte ptr [si], "0"
    mov byte ptr [di], "0"
    inc si
    inc di
    mov byte ptr [si], "$"
    mov byte ptr [di], "$"
    mov si, 0
    mov di, 0
    mov totalUnits_int, 0
    mov units_int, 0
    call readMenuName
    call readPricePerUnit
    call compareMenuFile

    cmp eof, 1
    je menuEOF

    cmp totalUnits_int, 0
    je repeatPrintSummary

    mov ah, 9
    lea dx, summaryTemplate
    int 21h
    jmp repeatPrintSummary
menuEOF:
    call compareMenuFile

    cmp totalUnits_int, 0
    je goToFinal

    mov ah, 9
    lea dx, summaryTemplate
    int 21h

goToFinal:
    mov ah, 3eh
    mov bx, handler
    int 21h
    mov ah, 3eh
    mov bx, handler2
    int 21h
    mov ah, 9
    lea dx, summaryMidline
    int 21h

    mov bx, 64
    lea si, priceAccumulator
copyToFinalTemplate:
    mov al, byte ptr [si]
    mov byte ptr [finalTemplate + bx], al
    inc si
    inc bx
    cmp byte ptr [si], '$'
    jne copyToFinalTemplate
copySpaceToFinalTemplate:
    cmp bx, 79
    je endcopySpaceToFinalTemplate
    mov byte ptr [finalTemplate + bx], ' '
    inc bx
    jmp copySpaceToFinalTemplate
endcopySpaceToFinalTemplate:
    mov ah, 9
    lea dx, finalTemplate
    int 21h
    lea dx, summaryHeader
    int 21h
    
    mov ah, 1
    int 21h
    ret
summary endp
openSummaryFile proc
    mov ah, 3dh
    mov al, 0
    lea dx, summaryFile
    int 21h
    mov handler2, ax
    ret
openSummaryFile endp
openMenuFile proc
    mov ah, 3dh
    mov al, 0
    lea dx, menuFile
    int 21h
    mov handler, ax
    ret
openMenuFile endp
formatSummary proc
    mov ah, 3eh
    mov bx, handler2
    int 21h

    mov ax, totalUnits_int
    mov fmultemp, ax
    lea si, totalUnits
    call numberMemoryWritter
    mov byte ptr [si], '$'
    lea si, pricePerUnit + 2
    call fMulCalc

    lea si, priceAccumulator
    lea di, totalPrice
    mov byte ptr [si], "R"
    mov byte ptr [di], "R"
    inc di
    inc si
    mov byte ptr [di], "M"
    mov byte ptr [si], "M"
    inc di
    lea si, supertemp
copySuperTempToTotalPrice:
    mov al, byte ptr [si]
    mov byte ptr [di], al
    inc si
    inc di
    cmp byte ptr [si], '$'
    jne copySuperTempToTotalPrice
    mov byte ptr [di], '$'

    lea si, totalPrice + 2
    lea di, priceAccumulator + 2
    call fAddCalc
    lea si, supertemp
    lea di, priceAccumulator + 2
copySuperTempToAccumulator:
    mov al, byte ptr [si]
    mov byte ptr [di], al
    inc si
    inc di
    cmp byte ptr [si], '$'
    jne copySuperTempToAccumulator
    mov byte ptr [di], '$'

    lea si, totalUnits
    mov bx, 32
copyToSummaryTemplate3:
    mov al, byte ptr [si]
    mov byte ptr [summaryTemplate + bx], al
    inc si
    inc bx
    cmp byte ptr [si], '$'
    jne copyToSummaryTemplate3
copySpaceToSummaryTemplate3:
    cmp bx, 44
    je endcopySpaceToSummaryTemplate3
    mov byte ptr [summaryTemplate + bx], ' '
    inc bx
    jmp copySpaceToSummaryTemplate3
endcopySpaceToSummaryTemplate3:
    mov bx, 64
    lea si, totalPrice
copyToSummaryTemplate4:
    mov al, byte ptr [si]
    mov byte ptr [summaryTemplate + bx], al
    inc si
    inc bx
    cmp byte ptr [si], '$'
    jne copyToSummaryTemplate4
copySpaceToSummaryTemplate4:
    cmp bx, 79
    je endcopySpaceToSummaryTemplate4
    mov byte ptr [summaryTemplate + bx], ' '
    inc bx
    jmp copySpaceToSummaryTemplate4
endcopySpaceToSummaryTemplate4:
    ret
formatSummary endp
compareMenuFile proc
    call openSummaryFile
prepareCheckMenuName:
    lea si, actualSummaryMenu
    jmp checkMenuName
summaryEOF:
    call formatSummary
    ret
checkMenuName:
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp cx, ax
    jne summaryEOF
    mov al, emptyBuffer
    cmp al, '@'
    je endCheckMenuName
    mov byte ptr [si], al
    inc si
    jmp checkMenuName
endCheckMenuName:
    mov byte ptr [si], '$'
    lea si, targetSummaryMenu
    lea di, actualSummaryMenu
repeatCompareSummaryMenu:
    mov al, byte ptr [si]
    mov bl, byte ptr [di]
    cmp al, bl
    jne summaryMenuNotMatch
    inc si
    inc di
    cmp byte ptr [si], '$'
    je summaryMenuMatch
    jmp repeatCompareSummaryMenu
summaryMenuNotMatch:
    call summaryNewLine
    jmp prepareCheckMenuName
summaryMenuMatch:
    call readTotalUnits
    jmp prepareCheckMenuName
compareMenuFile endp
readTotalUnits proc
repeatReadTillAlias:
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp byte ptr [emptyBuffer], '@'
    je endReadTillAlias
    jmp repeatReadTillAlias
endReadTillAlias:
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    lea si, units
repeatReadTotalUnits:
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp byte ptr [emptyBuffer], 13
    je endReadTotalUnits
    cmp byte ptr [emptyBuffer], 10
    je endReadTotalUnits
    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    jmp repeatReadTotalUnits
endReadTotalUnits:
    mov byte ptr [si], '$'
    lea di, units
    call convertStringNumToPlainNum
    mov units_int, bx
    mov ax, totalUnits_int
    add ax, units_int
    mov totalUnits_int, ax
    ret
readTotalUnits endp
summaryNewLine proc
    mov ah, 3fh
    mov bx, handler2
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp byte ptr [emptyBuffer], 13
    je endsummaryNewLine
    cmp byte ptr [emptyBuffer], 10
    je endsummaryNewLine
    jmp summaryNewLine
endsummaryNewLine:
    ret
summaryNewLine endp
readPricePerUnit proc
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    lea si, pricePerUnit
    jmp repeatReadPrice
assignexitt:
    mov eof, 1
    ret
repeatReadPrice:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp cx, ax
    jne assignexitt
    cmp byte ptr [emptyBuffer], 10
    je endReadPrice
    cmp byte ptr [emptyBuffer], 13
    je endReadPrice
    mov al, emptyBuffer
    mov byte ptr [si], al
    inc si
    jmp repeatReadPrice
endReadPrice:
    mov byte ptr [si], '$'
    mov bx, 45
    lea si, pricePerUnit
copyToSummaryTemplate2:
    mov al, byte ptr [si]
    mov byte ptr [summaryTemplate + bx], al
    inc si
    inc bx
    cmp byte ptr [si], '$'
    jne copyToSummaryTemplate2
copySpaceToSummaryTemplate2:
    cmp bx, 63
    je endReadPricePerUnit
    mov byte ptr [summaryTemplate + bx], ' '
    inc bx
    jmp copySpaceToSummaryTemplate2
endReadPricePerUnit:
    ret
readPricePerUnit endp
readMenuName proc
    lea si, targetSummaryMenu
loopreadmenuname:
    mov ah, 3fh
    mov bx, handler
    mov cx, 1
    lea dx, emptyBuffer
    int 21h
    cmp cx, ax
    jne assignexit
    mov al, emptyBuffer
    cmp al, 10
    je loopreadmenuname
    mov byte ptr [si], al
    cmp byte ptr [si], '@'
    je endloopreadmenuname
    inc si
    jmp loopreadmenuname
endloopreadmenuname:
    mov byte ptr [si], '$'
    mov bx, 1
    lea si, targetSummaryMenu
copyToSummaryTemplate:
    mov al, byte ptr [si]
    cmp al, 10
    je incSiThenCopyToSummaryTemplate
    mov byte ptr [summaryTemplate + bx], al
    inc si
    inc bx
    cmp byte ptr [si], '$'
    jne copyToSummaryTemplate
    jmp copySpaceToSummaryTemplate
incSiThenCopyToSummaryTemplate:
    inc si
    jmp copyToSummaryTemplate
copySpaceToSummaryTemplate:
    cmp bx, 31
    je endReadSummaryMenu
    mov byte ptr [summaryTemplate + bx], ' '
    inc bx
    jmp copySpaceToSummaryTemplate
endReadSummaryMenu:
    ret
assignexit:
    mov byte ptr [si], '$'
    mov eof, 1
    ret
readMenuName endp