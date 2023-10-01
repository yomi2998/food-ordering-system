fAddCalc proc
    mov bx, 0
loopchecktargetstrlen1:
    cmp byte ptr [si], '.'
    je loopchecktargetstrlen1end
    mov al, byte ptr [si]
    mov ntempstr[bx], al
    inc bx
    inc si
    jmp loopchecktargetstrlen1
loopchecktargetstrlen1end:
    inc si
    mov ntempstr[bx], '$'
    mov bx, 0
loopchecktargetfloatstrlen1:
    cmp byte ptr [si], '$'
    je loopchecktargetfloatstrlen1end
    mov al, byte ptr [si]
    mov ftempstr[bx], al
    inc bx
    inc si
    jmp loopchecktargetfloatstrlen1
loopchecktargetfloatstrlen1end:
    mov ftempstr[bx], '$'
    mov bx, 0
loopchecktargetstrlen2:
    cmp byte ptr [di], '.'
    je loopchecktargetstrlen2end
    mov al, byte ptr [di]
    mov ntempstr2[bx], al
    inc bx
    inc di
    jmp loopchecktargetstrlen2
loopchecktargetstrlen2end:
    inc di
    mov ntempstr2[bx], '$'
    mov bx, 0
loopchecktargetfloatstrlen2:
    cmp byte ptr [di], '$'
    je loopchecktargetfloatstrlen2end
    mov al, byte ptr [di]
    mov ftempstr2[bx], al
    inc bx
    inc di
    jmp loopchecktargetfloatstrlen2
loopchecktargetfloatstrlen2end:
    mov ftempstr2[bx], '$'
    lea di, ntempstr
    call convertStringNumToPlainNum
    mov ntemp, bx
    lea di, ntempstr2
    call convertStringNumToPlainNum
    mov ntemp2, bx
    lea di, ftempstr
    call convertStringNumToPlainNum
    mov ftemp, bx
    lea di, ftempstr2
    call convertStringNumToPlainNum
    mov ftemp2, bx
    
    mov bx, ntemp2
    add ntemp, bx
    mov bx, ftemp2
    add ftemp, bx

loopcheckftempexceed100:
    cmp ftemp, 100
    jae incrementntemp2
    jb loopcheckftempexceed100end
incrementntemp2:
    inc ntemp
    sub ftemp, 100
    jmp loopcheckftempexceed100
loopcheckftempexceed100end:
    mov ax, ntemp
    lea si, supertemp
    call numberMemoryWritter
    mov byte ptr [si], '.'
    inc si
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr[si - 1], '.'
    jne summarizeadd
    mov byte ptr [si], '0'
    inc si
summarizeadd:
    mov byte ptr [si], '$'
    ret
fAddCalc endp

fSubCalc proc
    mov bx, 0
    mov ntempstr[0], "0"
    mov ntempstr2[0], "0"
    mov ftempstr[0], "0"
    mov ftempstr2[0], "0"
    mov ntempstr[1], "$"
    mov ntempstr2[1], "$"
    mov ftempstr[1], "$"
    mov ftempstr2[1], "$"
loopchecktargetstrlen12:
    cmp byte ptr [si], '.'
    je loopchecktargetstrlen1end2
    cmp byte ptr [si], '$'
    je loopchecktargetfloatstrlen1end2
    mov al, byte ptr [si]
    mov ntempstr[bx], al
    inc bx
    inc si
    jmp loopchecktargetstrlen12
loopchecktargetstrlen1end2:
    inc si
    mov ntempstr[bx], '$'
    mov bx, 0
loopchecktargetfloatstrlen12:
    cmp byte ptr [si], '$'
    je loopchecktargetfloatstrlen1end2
    mov al, byte ptr [si]
    mov ftempstr[bx], al
    inc bx
    inc si
    jmp loopchecktargetfloatstrlen12
loopchecktargetfloatstrlen1end2:
    mov ftempstr[bx], '$'
    mov bx, 0
loopchecktargetstrlen22:
    cmp byte ptr [di], '.'
    je loopchecktargetstrlen2end2
    mov al, byte ptr [di]
    mov ntempstr2[bx], al
    inc bx
    inc di
    jmp loopchecktargetstrlen22
loopchecktargetstrlen2end2:
    inc di
    mov ntempstr2[bx], '$'
    mov bx, 0
loopchecktargetfloatstrlen22:
    cmp byte ptr [di], '$'
    je loopchecktargetfloatstrlen2end2
    mov al, byte ptr [di]
    mov ftempstr2[bx], al
    inc bx
    inc di
    jmp loopchecktargetfloatstrlen22
loopchecktargetfloatstrlen2end2:
    mov ftempstr2[bx], '$'
    lea di, ntempstr
    call convertStringNumToPlainNum
    mov ntemp, bx
    lea di, ntempstr2
    call convertStringNumToPlainNum
    mov ntemp2, bx
    lea di, ftempstr
    call convertStringNumToPlainNum
    mov ftemp, bx
    lea di, ftempstr2
    call convertStringNumToPlainNum
    mov ftemp2, bx
    
    mov bx, ntemp2
    sub ntemp, bx
    mov bx, ftemp2
    sub ftemp, bx

loopcheckftempless0:
    mov ax, ftemp
    test ax, ax
    jns loopcheckftempless0end
    dec ntemp
    add ftemp, 100
    jmp loopcheckftempless0
loopcheckftempless0end:
    mov notEnoughMoney, 0
    mov ax, ntemp
    test ax, ax
    jns continuesub
    js movnotenoughmoneythenexit
    mov ax, ftemp
    test ax, ax
    jns continuesub
movnotenoughmoneythenexit:
    mov notEnoughMoney, 1
    ret
continuesub:
    mov ax, ntemp
    lea si, supertemp
    call numberMemoryWritter
    mov byte ptr [si], '.'
    inc si
    cmp ftemp, 10
    jae summarizesub
    mov byte ptr [si], '0'
    inc si
summarizesub:
    mov ax, ftemp
    call numberMemoryWritter
    mov byte ptr [si], '$'
    ret
fSubCalc endp


numberMemoryWritterDX proc
    mov one, 0
    mov ten, 0
    mov hundred, 0
    mov thousand, 0
    mov tenthousand, 0
repeatnumber:
    cmp dx, 10
    jae incrementTen
    mov one, dl
    jmp donerepeatnumber
incrementTen:
    inc ten
    sub dx, 10
    cmp ten, 10
    jae incrementHundred
    jmp repeatnumber
incrementHundred:
    inc hundred
    sub ten, 10
    cmp hundred, 10
    jae incrementThousand
    jmp repeatnumber
incrementThousand:
    inc thousand
    sub hundred, 10
    cmp thousand, 10
    jae incrementTenThousand
    jmp repeatnumber
incrementTenThousand:
    inc tenthousand
    sub thousand, 10
    jmp repeatnumber
donerepeatnumber:
    cmp tenthousand, 0
    jne printTenThousand
    cmp thousand, 0
    jne printThousand
    cmp hundred, 0
    jne printHundred
    cmp ten, 0
    jne printTen

    add one, 30h
    mov dl, one
    mov byte ptr [si], dl
    ret
printTenThousand:
    add tenthousand, 30h
    mov dl, tenthousand
    mov byte ptr [si], dl
    inc si
printThousand:
    add thousand, 30h
    mov dl, thousand
    mov byte ptr [si], dl
    inc si
printHundred:
    add hundred, 30h
    mov dl, hundred
    mov byte ptr [si], dl
    inc si
printTen:
    add ten, 30h
    mov dl, ten
    mov byte ptr [si], dl
    inc si

    add one, 30h
    mov dl, one
    mov byte ptr [si], dl
    ret
numberMemoryWritterDX endp

removeDot proc
checkdotposition:
    cmp byte ptr [si], 46
    je checkdotpositionend
    inc si
    jmp checkdotposition
checkdotpositionend:
    mov al, byte ptr [si + 1]
    mov byte ptr [si], al
    inc si
    mov al, byte ptr [si + 1]
    mov byte ptr [si], al
    inc si
    mov byte ptr [si], '$'
    ret
removeDot endp

assignDot proc
    mov cx, 0
checkstrlen:
    cmp byte ptr [si], '$'
    je checkstrlenend
    inc si
    inc cx
    jmp checkstrlen
checkstrlenend:
    mov al, byte ptr [si - 1]
    mov byte ptr [si], al
    dec si
    mov al, byte ptr [si - 1]
    mov byte ptr [si], al
    mov byte ptr [si - 2], 46
    ret
assignDot endp
convertStringNumToPlainNum proc
    mov cx, 0
loopcheckstringlength:
    cmp byte ptr [di], 13
    je loopcheckstringlengthend
    cmp byte ptr [di], '$'
    je loopcheckstringlengthend
    inc cx
    inc di
    jmp loopcheckstringlength
loopcheckstringlengthend:
    mov bx, 0
    sub di, cx
    cmp cx, 5
    je converttenthousand
    cmp cx, 4
    je convertthousand
    cmp cx, 3
    je converthundred
    cmp cx, 2
    je convertten
    cmp cx, 1
    je convertone
converttenthousand:
    xor cx, cx
    mov cl, byte ptr [di]
    sub cl, 30h
    mov ax, 10000
    mul cx
    add bx, ax
    inc di
convertthousand:
    xor cx, cx
    mov cl, byte ptr [di]
    sub cl, 30h
    mov ax, 1000
    mul cx
    add bx, ax
    inc di
converthundred:
    xor cx, cx
    mov cl, byte ptr [di]
    sub cl, 30h
    mov ax, 100
    mul cx
    add bx, ax
    inc di
convertten:
    xor cx, cx
    mov cl, byte ptr [di]
    sub cl, 30h
    mov ax, 10
    mul cx
    add bx, ax
    inc di
convertone:
    xor cx, cx
    mov cl, byte ptr [di]
    sub cl, 30h
    add bx, cx
    ret
convertStringNumToPlainNum endp

numberMemoryWritter proc
    mov tenthousand, 0
    mov thousand, 0
    mov hundred, 0
    mov ten, 0
    mov one, 0
numberrepeatnumber:
    cmp ax, 10
    jae numberincrementTen
    mov one, al
    jmp numberdonerepeatnumber
numberincrementTen:
    inc ten
    sub ax, 10
    cmp ten, 10
    jae numberincrementHundred
    jmp numberrepeatnumber
numberincrementHundred:
    inc hundred
    sub ten, 10
    cmp hundred, 10
    jae numberincrementThousand
    jmp numberrepeatnumber
numberincrementThousand:
    inc thousand
    sub hundred, 10
    cmp thousand, 10
    jae numberincrementTenThousand
    jmp numberrepeatnumber
numberincrementTenThousand:
    inc tenthousand
    sub thousand, 10
    jmp numberrepeatnumber
numberdonerepeatnumber:
    cmp tenthousand, 0
    jne numberprintTenThousand
    cmp thousand, 0
    jne numberprintThousand
    cmp hundred, 0
    jne numberprintHundred
    cmp ten, 0
    jne numberprintTen
    jmp numberprintOne
numberprintTenThousand:
    add tenthousand, 30h
    mov al, tenthousand
    mov byte ptr [si], al
    inc si
numberprintThousand:
    add thousand, 30h
    mov al, thousand
    mov byte ptr [si], al
    inc si
numberprintHundred:
    add hundred, 30h
    mov al, hundred
    mov byte ptr [si], al
    inc si
numberprintTen:
    add ten, 30h
    mov al, ten
    mov byte ptr [si], al
    inc si
numberprintOne:
    add one, 30h
    mov al, one
    mov byte ptr [si], al
    inc si
    ret
numberMemoryWritter endp
fMulCalc proc
    mov di, 0
    mov bx, 0
fMulChecksPoint:
    cmp byte ptr [si], 46
    je fMulChecksAfterPoint
    cmp byte ptr [si], 13
    je fMulChecksPointEnd
    cmp byte ptr [si], '$'
    je fMulChecksPointEnd
    mov al, byte ptr [si]
    mov ntempstr[di], al
    inc si
    inc di
    jmp fMulChecksPoint
fMulChecksAfterPoint:
    mov ntempstr[di], '$'
    inc si
    inc cx
    cmp byte ptr [si], 13
    je fMulChecksPointEnd
    cmp byte ptr [si], '$'
    je fMulChecksPointEnd
    mov al, byte ptr [si]
    mov ftempstr[bx], al
    inc bx
    jmp fMulChecksAfterPoint
fMulChecksPointEnd:
    mov ftempstr[bx], '$'
    sub si, cx

    lea di, ntempstr
    call convertStringNumToPlainNum
    mov ntemp, bx
    lea di, ftempstr
    call convertStringNumToPlainNum
    mov ftemp, bx

    mov ax, ntemp
    mul fmultemp
    mov ntemp, ax
    mov ax, ftemp
    mul fmultemp
    mov ftemp, ax

loopCheckFtemp:
    cmp ftemp, 100
    jae incrementNtemp
    jmp afterIncrementNtemp
incrementNtemp:
    sub ftemp, 100
    inc ntemp
    jmp loopCheckFtemp
afterIncrementNtemp:
    mov ax, ntemp
    lea si, supertemp
    call numberMemoryWritter
    mov byte ptr [si], 46
    inc si
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr [si - 2], 46
    jne fmulExit
    mov byte ptr [si], 30h
    inc si
fmulExit:
    mov byte ptr [si], '$'
    ret
fMulCalc endp
discountCalc proc
    mov bx, 0
loopcalculatestrdotpos:
    cmp byte ptr [si], '.'
    je loopcalculatestrdotposafter
    mov al, byte ptr [si]
    mov ntempstr[bx], al
    inc si
    inc bx
    jmp loopcalculatestrdotpos
loopcalculatestrdotposafter:
    mov ntempstr[bx], '$'
    inc si
    mov bx, 0
loopcalculatestrdotposafter2:
    cmp byte ptr [si], '$'
    je loopcalculatestrdotposafter2end
    mov al, byte ptr [si]
    mov ftempstr[bx], al
    inc si
    inc bx
    jmp loopcalculatestrdotposafter2
loopcalculatestrdotposafter2end:
    mov ftempstr[bx], '$'
    lea di, ntempstr
    call convertStringNumToPlainNum
    mov ntemp, bx
    lea di, ftempstr
    call convertStringNumToPlainNum
    mov ftemp, bx
    mov ax, ntemp
    xor bx, bx
    mov bl, discount
    mul bx
    mov ntemp, ax
    mov ax, ftemp
    xor bx, bx
    mov bl, discount
    mul bx
    mov ftemp, ax
checkagainftemp:
    cmp ftemp, 100
    jb noaddntemp
    sub ftemp, 100
    inc ntemp
    jmp checkagainftemp
noaddntemp:
    mov bx, 0
    lea si, supertemp
    cmp ntemp, 10
    jb onedivide
    cmp ntemp, 100
    jb tendivide
    cmp ntemp, 1000
    jb hundreddivide
    cmp ntemp, 10000
    jb thousanddivide
    cmp ntemp, 65535
    jne tenthousanddivide
onedivide:
    call pCalcDivOne
    jmp afterperformdivision
tendivide:
    call pCalcDivTen
    jmp afterperformdivision
hundreddivide:
    call pCalcDivHundred
    jmp afterperformdivision
thousanddivide:
    call pCalcDivThousand
    jmp afterperformdivision
tenthousanddivide:
    call pCalcDivTenThousand
    jmp afterperformdivision
afterperformdivision:
    ret
discountCalc endp
taxCalc proc
    mov bx, 0
loopcalculatestrdotpos2:
    cmp byte ptr [si], '.'
    je loopcalculatestrdotposafter22
    mov al, byte ptr [si]
    mov ntempstr[bx], al
    inc si
    inc bx
    jmp loopcalculatestrdotpos2
loopcalculatestrdotposafter22:
    mov ntempstr[bx], '$'
    inc si
    mov bx, 0
loopcalculatestrdotposafter222:
    cmp byte ptr [si], '$'
    je lqwer43
    mov al, byte ptr [si]
    mov ftempstr[bx], al
    inc si
    inc bx
    jmp loopcalculatestrdotposafter222
lqwer43:
    mov ftempstr[bx], '$'
    lea di, ntempstr
    call convertStringNumToPlainNum
    mov ntemp, bx
    lea di, ftempstr
    call convertStringNumToPlainNum
    mov ftemp, bx
    mov ax, ntemp
    xor bx, bx
    mov bl, tax
    mul bx
    mov ntemp, ax
    mov ax, ftemp
    xor bx, bx
    mov bl, tax
    mul bx
    mov ftemp, ax
checkagainftemp2:
    cmp ftemp, 100
    jb noaddntemp2
    sub ftemp, 100
    inc ntemp
    jmp checkagainftemp2
noaddntemp2:
    mov bx, 0
    lea si, supertemp
    cmp ntemp, 10
    jb onedivide2
    cmp ntemp, 100
    jb tendivide2
    cmp ntemp, 1000
    jb hundreddivide2
    cmp ntemp, 10000
    jb thousanddivide2
    cmp ntemp, 65535
    jne tenthousanddivide2
onedivide2:
    call pCalcDivOne
    jmp afterperformdivision2
tendivide2:
    call pCalcDivTen
    jmp afterperformdivision2
hundreddivide2:
    call pCalcDivHundred
    jmp afterperformdivision2
thousanddivide2:
    call pCalcDivThousand
    jmp afterperformdivision2
tenthousanddivide2:
    call pCalcDivTenThousand
    jmp afterperformdivision2
afterperformdivision2:
    ret
taxCalc endp
pCalcDivOne proc
    mov byte ptr [si], '0'
    inc si
    mov byte ptr [si], '.'
    inc si
    mov byte ptr [si], '0'
    inc si
    mov ax, ntemp
    call numberMemoryWritter
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr[supertemp + 4], '5'
    jb pCalcDivOneEnd
    inc byte ptr[supertemp + 3]
    cmp byte ptr[supertemp + 3], '9'
    jbe pCalcDivOneEnd
    mov byte ptr[supertemp + 3], '0'
    inc byte ptr[supertemp + 2]
pCalcDivOneEnd:
    mov byte ptr[supertemp + 4], '$'
    ret
pCalcDivOne endp
pCalcDivTen proc
    mov byte ptr [si], '0'
    inc si
    mov byte ptr [si], '.'
    inc si
    mov ax, ntemp
    call numberMemoryWritter
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr[supertemp + 4], '5'
    jb pCalcDivTenEnd
    inc byte ptr[supertemp + 3]
    cmp byte ptr[supertemp + 3], '9'
    jbe pCalcDivTenEnd
    mov byte ptr[supertemp + 3], '0'
    inc byte ptr[supertemp + 2]
    cmp byte ptr[supertemp + 2], '9'
    jbe pCalcDivTenEnd
    mov byte ptr[supertemp + 2], '0'
    inc byte ptr[supertemp]
pCalcDivTenEnd:
    mov byte ptr[supertemp + 4], '$'
    ret
pCalcDivTen endp
pCalcDivHundred proc
    mov ax, ntemp
    lea si, ntempstr
    call numberMemoryWritter
    lea si, supertemp
    mov al, ntempstr[0]
    mov byte ptr [si], al
    inc si
    mov byte ptr [si], '.'
    inc si
    mov al, ntempstr[1]
    mov byte ptr [si], al
    inc si
    mov al, ntempstr[2]
    mov byte ptr [si], al
    inc si
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr[supertemp + 4], '5'
    jb pCalcDivHundredEnd
    inc byte ptr[supertemp + 3]
    cmp byte ptr[supertemp + 3], '9'
    jbe pCalcDivHundredEnd
    mov byte ptr[supertemp + 3], '0'
    inc byte ptr[supertemp + 2]
    cmp byte ptr[supertemp + 2], '9'
    jbe pCalcDivHundredEnd
    mov byte ptr[supertemp + 2], '0'
    inc byte ptr[supertemp + 1]
pCalcDivHundredEnd:
    mov byte ptr[supertemp + 4], '$'
    ret
pCalcDivHundred endp
pCalcDivThousand proc
    mov ax, ntemp
    lea si, ntempstr
    call numberMemoryWritter
    lea si, supertemp
    mov al, ntempstr[0]
    mov byte ptr [si], al
    inc si
    mov al, ntempstr[1]
    mov byte ptr [si], al
    inc si
    mov byte ptr [si], '.'
    inc si
    mov al, ntempstr[2]
    mov byte ptr [si], al
    inc si
    mov al, ntempstr[3]
    mov byte ptr [si], al
    inc si
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr[supertemp + 5], '5'
    jb pCalcDivThousandEnd
    inc byte ptr[supertemp + 4]
    cmp byte ptr[supertemp + 4], '9'
    jbe pCalcDivThousandEnd
    mov byte ptr[supertemp + 4], '0'
    inc byte ptr[supertemp + 3]
    cmp byte ptr[supertemp + 3], '9'
    jbe pCalcDivThousandEnd
    mov byte ptr[supertemp + 3], '0'
    inc byte ptr[supertemp + 1]
    cmp byte ptr[supertemp + 1], '9'
    jbe pCalcDivThousandEnd
    mov byte ptr[supertemp + 1], '0'
    inc byte ptr[supertemp]
pCalcDivThousandEnd:
    mov byte ptr[supertemp + 5], '$'
    ret
pCalcDivThousand endp
pCalcDivTenThousand proc
    mov ax, ntemp
    lea si, ntempstr
    call numberMemoryWritter
    lea si, supertemp
    mov al, ntempstr[0]
    mov byte ptr [si], al
    inc si
    mov al, ntempstr[1]
    mov byte ptr [si], al
    inc si
    mov al, ntempstr[2]
    mov byte ptr [si], al
    inc si
    mov byte ptr [si], '.'
    inc si
    mov al, ntempstr[3]
    mov byte ptr [si], al
    inc si
    mov al, ntempstr[4]
    mov byte ptr [si], al
    inc si
    mov ax, ftemp
    call numberMemoryWritter
    cmp byte ptr[supertemp + 6], '5'
    jb pCalcDivTenThousandEnd
    inc byte ptr[supertemp + 5]
    cmp byte ptr[supertemp + 5], '9'
    jbe pCalcDivTenThousandEnd
    mov byte ptr[supertemp + 5], '0'
    inc byte ptr[supertemp + 4]
    cmp byte ptr[supertemp + 4], '9'
    jbe pCalcDivTenThousandEnd
    mov byte ptr[supertemp + 4], '0'
    inc byte ptr[supertemp + 2]
    cmp byte ptr[supertemp + 2], '9'
    jbe pCalcDivTenThousandEnd
    mov byte ptr[supertemp + 2], '0'
    inc byte ptr[supertemp + 1]
    cmp byte ptr[supertemp + 1], '9'
    jbe pCalcDivTenThousandEnd
    mov byte ptr[supertemp + 1], '0'
    inc byte ptr[supertemp]
pCalcDivTenThousandEnd:
    mov byte ptr[supertemp + 6], '$'
    ret
pCalcDivTenThousand endp