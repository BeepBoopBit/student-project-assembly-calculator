.model small
.stack
.data
 
    first_num   db "Enter the first number: $"
    second_num  db "Enter the second number: $"
    ope_prompt  db "'+' Add | '-' Subtract | '*' Multiply | '/' Divide $"
    operation   db "Enter Operation: $" 
    ans_prompt  db "The answer is: $"
    end_prompt  db "Continue (y/n)? $"
    err1_prompt db "Wrong Operation Input: $"
    err2_prompt db "Wrong Integer Input: $"
    new_line    db 0ah, 0dh, '$'

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; clear Screen
    mov ah, 06h
    mov al, 0
    mov bh, 7
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 10h

MainProgram:
    ; prompt 'firstNum' message
    Check_first:
        mov ah, 09h
        mov dx, offset new_line
        int 21h
        mov dx, offset first_num
        int 21h
        
        ; get input
        mov ah, 01h
        int 21h

        mov ah, 09h        
        mov dx, offset new_line
        int 21h

        ; check number if out of bound
        CMP al, '0'
        JB Check_first              ; uhm should have "said wrong input?" (suggest) - ryoji
        CMP al, '9'                 ; naglagay me new db for that braie
        JA check_first

    Check_second:
        mov ah, 09h
        mov dx, offset second_num
        int 21h

        ; get input
        mov ah, 01h
        int 21h

        mov ah, 09h 
        mov dx, offset new_line
        int 21h

        ; check number if out of bound
        CMP al, '0'
        JB Check_second
        CMP al, '9'
        JA Check_second

        mov ah, 09h 
        mov dx, offset new_line
        int 21h

    Check_operation:
        mov ah, 09h
        mov dx, offset ope_prompt
        int 21h
        mov dx, offset new_line
        int 21h
        mov dx, offset operation
        int 21h

        ; get input
        mov ah, 01h
        int 21h

        mov ah, 09h 
        mov dx, offset new_line
        int 21h

        ; check if basic operations
        CMP al, '+'
        JE Addition
        CMP al, '-'
        JE Subtraction
        CMP al, '/'
        JE Division
        CMP al, '*'
        JE Multiplication    

        ; check if input is correct 
        CMP al, '*'
        JB Operation_Error 
        CMP al, '/'
        JA Operation_Error
        JMP Check_operation

        ;Operation Input Erorr Check 
        Operation_Error:
        lea dx, err_prompt
        mov ah, 09h ;output string ds:dx
        int 21h


    Main_relative:
        JMP MainProgram

    Answer:
        mov ah, 09h 
        mov dx, offset new_line
        int 21h

        mov ah, 09h 
        mov dx, offset ans_prompt
        int 21h

        mov ah, 09h 
        mov dx, offset new_line
        int 21h

    Continue:
        mov ah, 09h 
        mov dx, offset end_prompt
        int 21h
        
        ; get input
        mov ah, 01h
        int 21h

        mov ah, 09h 
        mov dx, offset new_line
        int 21h
        
        ; check if (y/n)
        CMP al, 'y'
        JE Main_relative
        CMP al, 'n'
        JE Exit

        JMP Continue
        
        Exit:
            mov ah, 4ch
            int 21h


    ; basic operation function
    Addition:
        
        ; your code here
        
        JMP Answer

    Subtraction:

        ; your code here

        JMP Answer

    Division:

        ; your code here

        JMP Answer

    Multiplication:

        ; your code here

        JMP Answer

main endp
end main

C:\Users\Ryoji\Desktop\assembly-calculator
