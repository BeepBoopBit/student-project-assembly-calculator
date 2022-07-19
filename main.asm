title Calculator Project - GROUP 1
.model small
.stack
.data
    ; BF - ┐
    ; C0 - └
    ; D9 - ┘
    ; DA - ┌
    ; 7C - |
    ; C4 - ─

    first_ask       db "Enter the first number: $"
    second_num      db "Enter the second number: $"
    ope_prompt      db "'+' Add | '-' Subtract | '*' Multiply | '/' Divide $"
    operation       db "Enter Operation: $" 
    ans_prompt      db "The answer is: $"
    end_prompt      db "Continue (y/n)? $"
    err_operation   db "Wrong Operation Input: $"
    err_integer     db "Wrong Integer Input: $"
    new_line        db 0ah, 0dh, '$'
    
    ; calculator number
    first_number    db 0
    second_number   db 0
    operation_value db 0 ; contains the hex of the operation
    answer_number   db 0

.code
    ; [ Main Function ]

    MAIN PROC
        ; initialize the data
        MOV AX, @data
        MOV DS, AX
        MainContinue:
            CALL CLEAR_SCREEN
            CALL DISPLAY_BOX
            CALL DISPLAY_FIRST_PROMPT
            CALL DISPLAY_SECOND_PROMPT
            CALL DISPALY_OPERATOR_PROMPT
            CALL ASK_FIRST
            CALL ASK_SECOND
            CALL ASK_OPERATOR
        
            ; [!] Implement Try Again
            JE MainContinue

        ; terminate the program
        MOV AH, 04Ch
        INT 21h
    MAIN ENDP

    ; [ Box ]
    DISPLAY_BOX PROC
        ; PUT YOUR CODE HERE
    DISPLAY_BOX ENDP

    DISPLAY_FIRST_PROMPT PROC
        ; PUT YOUR CODE HERE
    DISPLAY_FIRST_PROMPT ENDP

    DISPLAY_SECOND_PROMPT PROC
        ; PUT YOUR CODE HERE
    DISPLAY_SECOND_PROMPT ENDP

    DISPALY_OPERATOR_PROMPT PROC
        ; PUT YOUR CODE HERE
    DISPALY_OPERATOR_PROMPT ENDP

    ; [ Prompts ]
    ASK_FIRST PROC
        ; PUT YOUR CODE HERE
    ASK_FIRST ENDP
    
    ASK_SECOND PROC
        ; PUT YOUR CODE HERE
    ASK_SECOND ENDP
    
    ASK_OPERATOR PROC
        ; PUT YOUR CODE HERE
    ASK_OPERATOR ENDP

    ; [ Operations ]
    ADD_VALUE PROC
        ; PUT YOUR CODE HERE
    ADD_VALUE ENDP

    SUB_VALUE PROC
        ; PUT YOUR CODE HERE
    SUB_VALUE ENDP

    MUL_VALUE PROC
        ; PUT YOUR CODE HERE
    MUL_VALUE ENDP

    DIV_VALUE PROC
        ; PUT YOUR CODE HERE
    DIV_VALUE ENDP 

    ; [ Printing ]

    DISPLAY_ANSWER PROC
        ; PUT YOUR CODE HERE
    DISPLAY_ANSWER ENDP

    ; [ Auxiliary ]

    ; Assumes that DL and DH are already been configured
    MOVE_CURSOR PROC
        MOV AH, 02h
        MOV BH, 00h
        INT 10H
        RET
    MOVE_CURSOR ENDP

    CLEAR_SCREEN PROC
        MOV AH, 06h
        MOV AL, 00h
        MOV BH, 00000111b
        MOV CH, 00h         ; ROW
        MOV CL, 00h         ; COL
        MOV DH, 19h         ; ROW
        MOV DL, 4Fh         ; COL
        INT 10h
        RET
    CLEAR_SCREEN ENDP
end MAIN