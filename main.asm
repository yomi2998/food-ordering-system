.model small
.stack 100h
.data
    tenthousand db 0
    thousand db 0
    hundred db 0
    ten db 0
    one db 0
    notEnoughMoney db 0
    
    tax db 5
    discount db 10
    subtotalprint db           "Subtotal:      RM $"
    taxprint db 13, 10,        "Tax     :    + RM $"
    discountprint db 13, 10,   "Discount:    - RM $"
    totalpriceprint db 13, 10, "Total price:   RM "
    supertemp db 15 dup("$")
    subtotal db 15 dup("$")
    ftempstr db 15 dup("$")
    ftemp dw 0
    ftempstr2 db 15 dup("$")
    ftemp2 dw 0
    fmultemp dw 0
    ntempstr db 15 dup("$")
    ntemp dw 0
    ntempstr2 db 15 dup("$")
    ntemp2 dw 0
    break db "$"
    usertype db ? ; '1' = member, '2' = staff
    welcome db "Welcome to PandaFood", 13, 10, "1. Login", 13, 10, "2. Register", 13, 10, "3. Exit", 13, 10, "Enter your choice: $"
    loginopt db "Login as", 13, 10, "1. Member", 13, 10, "2. Staff", 13, 10, "3. Exit", 13, 10, "Enter your choice: $"
    registeropt db "Register as", 13, 10, "1. Member", 13, 10, "2. Staff", 13, 10, "3. Exit", 13, 10, "Enter your choice: $"

    membermenuopt db "Menu", 13, 10, "1. View Menu", 13, 10, "2. Order Food", 13, 10, "3. Logout", 13, 10, "Enter your choice: $"
    staffmenuopt db "Menu", 13, 10, "1. View Menu", 13, 10, "2. Add Menu", 13, 10, "3. Edit Menu", 13, 10, "4. Delete Menu", 13, 10, "5. Order checkout", 13, 10, "6. Print summary", 13, 10, "7. Logout", 13, 10, "Enter your choice: $"

    usernameTaken db "Username already taken! Please try with another username.$"
    usernameLoginPrompt db "Enter your username (-1 to cancel): $"
    passwordLoginPrompt db "Enter your password (-1 to cancel): $"
    usernameRegisterPrompt db "Enter your username (-1 to cancel):$"
    usernameInvalid db "Username must be between 2 and 8 characters!$"
    passwordRegisterPrompt db "Enter your password (-1 to cancel):$"
    passwordInvalid db "Password must be between 8 and 16 characters!$"
    username db 30 dup("$")
    password db 30 dup("$")
    breaker db "$"
    passwordBuffer db 30 dup("$")
    staffsearchFile db "staff\", 100, ?, 100 dup(0)
    membersearchFile db "member\", 100, ?, 100 dup(0)
    menuFile db "menu\MENU.TXT", 0
    tempFile db "menu\TEMP.TXT", 0
    orderFile db "order\", 100, ?, 100 dup(0)
    handler dw ?
    handler2 dw ?
    invalidlogin db "Invalid username or password!$"
    loginSuccess db "Login successful!$"
    registerSuccess db "Register successful!$"
    logoutSuccess db "Logout successful!$"
    currentAccount db 30 dup("$")
    menuCounter dw ?
    menuContent db "Food menu", 13, 10, 2000 dup("$")
    emptyBuffer db 15 dup ("$")
    foodOrdered db "Food ordered: ", 100 dup("$")
    printFoodCheckout db 13, 10, "Food ordered: "
    foodBuffer db 50 dup("$")
    printPriceCheckout db "Price: RM "
    foodPrice db 8 dup("$")
    printAmountCheckout db "Amount: "
    foodAmount db 8 dup("$")
    priceAccumulator db 30 dup ("$")
    rmtag db "RM "
    price db 8 dup("$")
    totalPrice db 8 dup("$")
    isLogin db ?
    eof db 0
    scanResult dw 0

    orderMenuPrompt db 13, 10, "Enter the food number you want to order (-1 to cancel): $"
    orderMenuNumber db 6 dup ("$")
    orderMenuAmountPrompt db 13, 10, "Enter the amount of food you want to order (-1 to cancel): $"
    orderMenuAmount db 6 dup ("$")
    confirmOrderPrompt db 13, 10, "Are you sure you want to order this food? (Y/N): $"
    orderTableNum db 5 dup ("$")
    orderTableNumPrompt db 13, 10, "Enter the table number (-1 to cancel): $"
    orderFileNotFound db 13, 10, "Order file not found! Please make sure that you have keyed in the correct table number!$"
    newlineforfilewrite db 13, 10
    aliasspace db 64, 32
    spacealiasspace db 32, 64, 32
    spacealiasspacerm db 32, 64, 32, "RM"
    thankyou db 13, 10, "Thank you for ordering. Please pay at the counter after eating.$"

    menuNamePrompt db "Enter the food name (-1 to cancel): $"
    menuName db 32 dup("$")
    menuPricePrompt db 13, 10, "Enter the food price (-1 to cancel): RM $"
    menuPrice db 8 dup("$")
    menuConfirmPrompt db 13, 10, "Are you sure you want to add this food? (Y/N): $"
    menuSuccess db 13, 10, "Food added successfully!$"

    editMenuPrompt db 13, 10, "Enter the food number you want to edit (-1 to cancel): $"
    editMenuNumber db 6 dup("$")
    editMenuNamePrompt db 13, 10, "Enter the new food name (-1 to cancel): $"
    editMenuName db 32 dup("$")
    editMenuPricePrompt db 13, 10, "Enter the new food price (-1 to cancel): RM $"
    editMenuPrice db 8 dup("$")
    editMenuConfirmPrompt db 13, 10, "Are you sure you want to edit this food? (Y/N): $"
    editMenuSuccess db 13, 10, "Food edited successfully!$"
    menunotfound db "Menu not found!$"

    deleteMenuPrompt db 13, 10, "Enter the food number you want to delete (-1 to cancel): $"
    deleteMenuNumber db 6 dup("$")
    deleteMenuConfirmPrompt db 13, 10, "Are you sure you want to delete this food? (Y/N): $"
    deleteMenuSuccess db 13, 10, "Food deleted successfully!$"

    checkoutPrompt db "Enter the table number you want to checkout (-1 to cancel): $"
    checkoutTableNumber db 5 dup("$")
    membercash db 13, 10, "Enter the amount of cash given by the member: RM $"
    membercashstr db 10 dup("$")
    changeprint db 13, 10, "Change: RM $"
    notEnoughMoneyPrint db 13, 10, "Not enough money! Please enter sufficient amount of money.$"
    thankyoucheckout db 13, 10, "Thank you for eating at PandaFood! Please come next time!$"
    summaryFile db "summary\SUMMARY.TXT", 0

    menuFileNotFound db 13, 10, "Menu file not found!$"
    summaryHeader db " ", 78 dup("-"), " $"
    summaryMidline db "|", 30 dup("-"), "+", 12 dup("-"), "+", 18 dup("-"), "+", 15 dup("-"), "|$"
    summaryColumn db "|          Food Name           |   Units    |  Price Per Unit  |  Total Price  |$"
    summaryTemplate db "|", 30 dup(" "), "|", 12 dup(" "), "|", 18 dup(" "), "|", 15 dup(" "), "|$"
    finalTemplate db "|", "Total Price: ", 17 dup(" "), "|", 12 dup(" "), "|", 18 dup(" "), "|", 15 dup(" "), "|$"
    summaryReportPrint db "                               -Summary Report-", 13, 10, '$'
    units db 12 dup("$")
    totalUnits db 12 dup("$")
    units_int dw 0
    totalUnits_int dw 0
    targetSummaryMenu db 30 dup("$")
    actualSummaryMenu db 30 dup("$")
    pricePerUnit db 15 dup("$")
.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 0
    mov al, 3
    int 10h

    mov ah, 9
    lea dx, welcome
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je login
    cmp al, '2'
    je register
    cmp al, '3'
    je exit
login:
    call plogin
    jmp main
register:
    call pregister
    jmp main
exit:
    mov ah, 4ch
    int 21h
main endp

menudistribution proc
    cmp usertype, '1'
    je gomembermenu
    cmp usertype, '2'
    je gostaffmenu
gomembermenu:
    call membermenu
    ret
gostaffmenu:
    call staffmenu
    ret
menudistribution endp
;include
include summary.asm
include login.asm
include register.asm
include menu.asm
include utils.asm
end