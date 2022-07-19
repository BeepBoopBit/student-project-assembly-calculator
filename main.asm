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
    first_value     db 39h
    second_value    db 39h
    operation_value db 00h
    answer_value    db 0FFh     ; Default to Infinite
    remainder_value db 00h
    value_flag      db 00h      ; tell if it's a negative

.code
    ; [ Main Function ]

    MAIN PROC ; Aguirre
        ; Initialize the data
        MOV AX, @data
        MOV DS, AX
        MainContinue:
            CALL CLEAR_SCREEN
            CALL DISPLAY_BOX
            CALL DISPLAY_FIRST_PROMPT
            CALL DISPLAY_SECOND_PROMPT
            CALL DISPLAY_OPERATOR_PROMPT
            CALL ASK_FIRST
            CALL ASK_SECOND
            CALL ASK_OPERATOR

            ; Get the Operator [No Checking]
            MOV BX, OFFSET operation_value
            MOV AX, [BX]

            ; Comparing
            CMP AL, '+'
            JE AddFunction
            CMP AL, '-'
            JE SubFunction
            CMP AL, '*'
            JE MulFunction
            CMP AL, '/'
            JE DivFunction
            
            ; Functions
            AddFunction:
                CALL ADD_VALUE
                JMP CompareContine
            SubFunction:
                CALL SUB_VALUE
                JMP CompareContine
            MulFunction:
                CALL MUL_VALUE
                JMP CompareContine
            DivFunction:
                CALL DIV_VALUE
            CompareContine:
                ; Answer
                CALL DISPLAY_ANSWER_BOX
                CALL DISPLAY_ANSWER

                ; Try Again
                CALL DISPLAY_TRY_AGAIN_BOX
                CALL DISPLAY_TRY_AGAIN
                CALL ASK_INPUT

                ; The program will stop if any value is entered other than 'y'
                CMP AL, 'y'
                JE MainContinue
                JMP MainStop
            MainStop:
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
    
    DISPLAY_ANSWER_BOX PROC
        ; INSERT CODE HERE    
    DISPLAY_ANSWER_BOX ENDP
    
    DISPLAY_TRY_AGAIN_BOX PROC
        ; INSERT CODE HERE    
    DISPLAY_TRY_AGAIN_BOX ENDP
    
    DISPLAY_TRY_AGAIN PROC
        ; INSERT CODE HERE    
    DISPLAY_TRY_AGAIN ENDP
    
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
    ADD_VALUE PROC  ; Aguirre
        ; Get the first number
        MOV BX, offset first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, offset second_value
        MOV CX, [BX]

        MOV AH, 00h ; reset
        MOV CH, 00h ; reset
        SUB AX, 30h
        SUB CX, 30h

        ; Add Value and Save
        ADD AX, CX
        MOV BX, offset answer_value
        MOV [BX], AX
        RET
    ADD_VALUE ENDP

    SUB_VALUE PROC  ; Aguirre
        ; Get the first number
        MOV BX, offset first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, offset second_value
        MOV CX, [BX]

        MOV AH, 00h ; reset
        MOV CH, 00h ; reset
        SUB AX, 30h
        SUB CX, 30h
        ; Subtract the values
        SUB AX, CX

        CMP AX, 0
        JL NegativeValue
        PositiveValue:
            MOV AH, 00h                     ; Signifies that it's a positive value
            MOV BX, offset answer_value
            MOV [BX], AX
            JMP SubtractionEnd
        NegativeValue:
            MOV CX, 0FFFFh
            SUB CX, AX;
            INC CX                          ; The value is less than one everytime when we have negative value
            MOV BX, offset answer_value
            MOV [BX], CX

            ; Assing Flag
            MOV BX, OFFSET value_flag
            MOV AX, 01h
            MOV [BX], AX                   ; 01h indicates that it's a negative value
        SubtractionEnd:
            RET
    SUB_VALUE ENDP

    MUL_VALUE PROC ; Aguirre
        ; Get the first number
        MOV BX, offset first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, offset second_value
        MOV CX, [BX]

        MOV AH, 00h                     ; reset
        MOV CH, 00h                     ; reset
        SUB AX, 30h
        SUB CX, 30h
        MOV BX, CX                      ; put the Multiplier in position

        ; Add Value and Save
        MUL BX
        MOV BX, offset answer_value
        MOV [BX], AX
        RET
    MUL_VALUE ENDP

    DIV_VALUE PROC ; Aguirre
        ; Get the first number
        MOV BX, offset first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, offset second_value
        MOV CX, [BX]

        MOV AH, 00h                     ; Reset
        MOV CH, 00h                     ; Reset
        MOV DX, 00h                     ; Reset

        CMP CL, 30h
        JE InfiniteValue
        JMP NonInfinite
        InfiniteValue:
            MOV BX, OFFSET value_flag
            MOV AX, 02h
            MOV [BX], AX
            JMP DivisionEnd
        NonInfinite:
            SUB AX, 30h
            SUB CX, 30h
            MOV BX, CX                      ; Put the Multiplier in position
    
            ; Add Value and Save
            DIV BX
            MOV AH, 00h                     ; Signifies that it's a positive value
            MOV DH, 00h                     ; Signifies that it's a positive value
            MOV BX, offset answer_value
            MOV [BX], AX
            MOV BX, offset remainder_value
            mov [BX], DX
        DivisionEnd:
            RET
    DIV_VALUE ENDP 

    ; [ Printing ]

    DISPLAY_ANSWER PROC ; Aguirre
        ; Get the flag
        MOV BX, OFFSET value_flag
        MOV DX,[BX]

        ; Comparing
        CMP DL, 01h                         ; Check if the value is negative
        JE DisplayNegative
        CMP DL, 02h                        ; Check if the value is infinite
        CALL GET_ANSWER
        JE DisplayInfinite
        JMP ContinueOperatorDisplay
        DisplayInfinite:
            ; Save Value
            MOV AH, 02h
            MOV DX, 'i'
            INT 21h
            MOV DX, 'n'
            INT 21h
            MOV DX, 'f'
            INT 21h
            JMP EndDigit
        DisplayNegative:
            PUSH DX                         ; Save Value
            MOV AH, 02h
            MOV DX, '-'
            INT 21h
            POP DX
        ContinueOperatorDisplay:
            ; Compare if The value is LESS THAN OR EQUAL to 09h
            CMP DL, 09h
            JBE OneDigit
            JMP TwoDigit
            OneDigit:
                ; Print it normally
                MOV AH, 02h
                ADD DL, 30h
                INT 21h
                JMP EndDigit
            TwoDigit:
                ; Divide the Digit By 10
                MOV AX, 00h                 ; Reset
                MOV AL, DL                  ; Get the value of DL (Divident)
                MOV BX, 00h                 ; Reset
                MOV BL, 0Ah                 ; Put 10 as value 
                MOV DX, 00h                 ; Reset
                DIV BX
    
                ; Store the Values
                PUSH DX                     ; Contains the Remainder 
                PUSH AX                     ; Contains The Quotient
    
                ; Print The Quotient
                POP DX
                MOV AX, 00h                 ; Reset
                MOV AH, 02h                 ; Function 2
                MOV DH, 00H                 ; Reset
                ADD DL, 30h                 ; Add 30h To make the value its ASCII Representation
                INT 21h
    
                ; Print The Remainder
                POP DX
                MOV DH, 00h                 ; Reset
                ADD DL, 30h
                INT 21h
            EndDigit:
                ; Get remainder
                MOV BX, OFFSET remainder_value
                MOV AX, [BX]

                MOV AH, 00h                 ; Reset
                CMP AX, 00h
                JA RemainderExists 
                JMP EndRemainder
                RemainderExists:
                    PUSH AX                 ; Save value
                    MOV AH, 02h
                    MOV DX, 'r'
                    INT 21h
                    POP DX
                    ADD DX, 30h             ; Add 30h To make the value its ASCII Representation
                    INT 21h
                EndRemainder:
                    RET
    DISPLAY_ANSWER ENDP

    ; [ Auxiliary ]

    ; Assumes that DL and DH are already been configured
    MOVE_CURSOR PROC ; Aguirre
        MOV AH, 02h
        MOV BH, 00h
        INT 10H
        RET
    MOVE_CURSOR ENDP

    CLEAR_SCREEN PROC ; Aguirre
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

    ASK_INPUT PROC  ; Aguirre
        MOV AH, 01h
        INT 21h
        RET
    ASK_INPUT ENDP

    GET_ANSWER PROC
        MOV BX, OFFSET answer_value
        MOV DX, [BX]
        RET
    GET_ANSWER ENDP
end MAIN