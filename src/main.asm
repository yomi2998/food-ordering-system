.model SMALL
.stack 100H
.data
    isLogin db 0
    currentAccount db 30 dup("$")

    mainopt db "Welcome to PandaFood", 10, "1. Login", 10, "2. Register", 10, "3. Continue without logging in", 10, "4. Exit", 10, "Enter your choice: $"
    loginopt db "Login", 10, "1. Login as member", 10, "2. Login as staff", 10, "3. Back", 10, "Enter your choice: $"
    registeropt db "Register", 10, "1. Register as member", 10, "2. Register as staff", 10, "3. Back", 10, "Enter your choice: $"
    confirmnologin db "Are you sure? You'll not be able to enjoy discount perks and other benefits!", 10, "1. Yes", 10, "2. No", 10, "Enter your choice: $"

    memberreg db "Member Registration", 10, "$"
    memberlog db "Member Login", 10, "$"
    staffreg db "Staff Registration", 10, "$"
    stafflog db "Staff Login", 10, "$"
    usernamePrompt db "Enter your username (maximum 8 characters, minimum 2 characters, -1 to cancel): $"
    usernameLoginPrompt db "Enter your username: $"
    username db 30 dup("$")
    passwordPrompt db "Enter your password (maximum 16 characters, minimum 8 characters, -1 to cancel): $"
    passwordLoginPrompt db "Enter your password: $"
    password db 30 dup("$")
    passwordBuffer db 30 dup("$")

    usernameExist db "Username already exists!$"
    passwordTooLong db "Password too long!$"
    usernameTooLong db "Username too long!$"
    passwordTooShort db "Password too short!$"
    usernameTooShort db "Username too short!$"
    regSuccess db "Registration successful!$"
    invalidLogin db "Invalid username or password!$"
    loginSuccess db "Login successful!$"

    staffsearchFile db "staff\", 100, ?, 100 dup(0)
    membersearchFile db "member\", 100, ?, 100 dup(0)
    handler dw ?
.code
main PROC
    mov ax, @DATA
    mov ds, ax

menu:
    call cls

    mov ah, 9
    lea dx, mainopt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je loginsession
    cmp al, '2'
    je registersession
    cmp al, '3'
    je confirmcontinue
    cmp al, '4'
    je quit
    
    jmp menu

    CALL STAFFREGISTRATION

loginsession:
    call cls

    mov ah, 9
    lea dx, loginopt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je mbrlogin
    cmp al, '2'
    je stflogin
    cmp al, '3'
    je menu
    
    jmp loginsession

mbrlogin:
    call MEMBERLOGIN
    jmp stflogin
stflogin:
    call STAFFLOGIN
    jmp loginsession
registersession:
    call cls

    mov ah, 9
    lea dx, registeropt
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je memberRegister
    cmp al, '2'
    je staffRegister
    cmp al, '3'
    je menu
    
    jmp registersession
memberRegister:
    CALL MEMBERREGISTRATION
    jmp registersession
staffRegister:
    CALL STAFFREGISTRATION
    jmp registersession
confirmcontinue:
    call cls

    mov ah, 9
    lea dx, confirmnologin
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je proceed
    cmp al, '2'
    je proceed
    
    jmp confirmcontinue
proceed:
    mov currentAccount, '-'
    mov currentAccount + 1, '1'
quit:
    mov ah, 4CH
    int 21h
main ENDP
INCLUDE ..\..\src\log\mbrlog.asm
INCLUDE ..\..\src\log\stafflog.asm
INCLUDE ..\..\src\reg\staffreg.asm
INCLUDE ..\..\src\reg\mbrreg.asm
INCLUDE ..\..\src\utils\cls.asm
INCLUDE ..\..\src\utils\newline.asm
INCLUDE ..\..\src\utils\pause.asm
end main