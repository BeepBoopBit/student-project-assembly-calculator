title Calculator Project - GROUP 1
.model small
.stack
.data
    first_prompt    db " Enter the first number :     $"
    second_prompt   db " Enter the second number:     $"
    operator_prompt db " Enter the operation    :     $" 
    ans_prompt      db " Answer                 :     $"
    end_prompt      db " Try Again (y/n)        :     $"
    err_operation   db "Wrong Operation Input$"
    err_integer     db "Wrong Integer Input$"
    new_line        db 0ah, 0dh, '$'
    
    ; calculator number
    first_value     db 39h
    second_value    db 39h
    operator_value  db 00h
    answer_value    db 0FFh     ; Default to Infinite
    remainder_value db 00h
    value_flag      db 00h      ; tell if it's a negative (01) or infinite (02)

.code
    ; [ Main Function ]

    MAIN PROC ; Aguirre
        ; Initialize the data
        MOV AX, @data
        MOV DS, AX
        
        MainContinue:
            ; Initialize Screen
            CALL CLEAR_SCREEN
            MOV DH, 00h
            MOV DL, 00h
            CALL MOVE_CURSOR
            
            ; Calling the main procedures
            CALL DISPLAY_FIRST_PROMPT
            CALL ASK_FIRST
            CALL DISPLAY_SECOND_PROMPT
            CALL ASK_SECOND
            CALL DISPLAY_OPERATOR_PROMPT
            CALL ASK_OPERATOR

            ; Get the Operator 
            MOV BX, OFFSET operator_value
            MOV AX, [BX]

            ; Comparing [No Checking]
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
                MOV DH, 09h
                MOV DL, 1Bh
                CALL MOVE_CURSOR
                CALL ASK_INPUT

                ; The program will stop if any value is entered other than 'y'
                CMP AL, 'y'
                JE MainContinue
                JMP MainStop
            MainStop:
                MOV DH, 0Bh
                MOV DL, 00h
                CALL MOVE_CURSOR
                ; terminate the program
                 MOV AH, 04Ch
                 INT 21h
    MAIN ENDP

    DISPLAY_FIRST_PROMPT PROC   ; Paul
        CALL DISPLAY_TOP
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, offset first_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        CALL DISPLAY_NEWLINE
        CALL DISPLAY_BOT
        RET
    DISPLAY_FIRST_PROMPT ENDP

    DISPLAY_SECOND_PROMPT PROC  ; Paul
        MOV DH, 02h
        MOV DL, 00h
        CALL MOVE_CURSOR
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, offset second_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        CALL DISPLAY_NEWLINE
        CALL DISPLAY_BOT
        RET
    DISPLAY_SECOND_PROMPT ENDP

    DISPLAY_OPERATOR_PROMPT PROC ; paul
        MOV DH, 03h
        MOV DL, 00h
        CALL MOVE_CURSOR
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, offset operator_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        CALL DISPLAY_NEWLINE
        CALL DISPLAY_BOT
        RET
    DISPLAY_OPERATOR_PROMPT ENDP
    
    DISPLAY_ANSWER_BOX PROC
        MOV DH, 04h
        MOV DL, 00h
        CALL MOVE_CURSOR
        CALL DISPLAY_BOT
        CALL DISPLAY_TOP
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, offset ans_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        CALL DISPLAY_NEWLINE
        CALL DISPLAY_BOT
        RET
    DISPLAY_ANSWER_BOX ENDP
    
    DISPLAY_TRY_AGAIN_BOX PROC
        MOV DH, 08h
        MOV DL, 00h
        CALL MOVE_CURSOR
        CALL DISPLAY_TOP
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, offset end_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        CALL DISPLAY_NEWLINE
        CALL DISPLAY_BOT
        RET
    DISPLAY_TRY_AGAIN_BOX ENDP
    
    ; [ Prompts ]
    ASK_FIRST PROC ; Ambraie
        AskFirstAgain:
            MOV DH, 01h
            MOV DL, 01Bh
            CALL RESET_CURSOR_VALUE

            CALL ASK_INPUT
            CMP AL, '0'
            JB AskFirstAgain
            CMP AL, '9'
            JA AskFirstAgain

            ; Store Value
            MOV AH, 01h
            MOV BX, OFFSET first_value
            MOV [BX], AL
            RET
    ASK_FIRST ENDP
    
    ASK_SECOND PROC ; Ambraie
        AskSecondAgain:
            MOV DH, 02h
            MOV DL, 01Bh
            CALL RESET_CURSOR_VALUE

            CALL ASK_INPUT
            CMP AL, '0'
            JB AskSecondAgain
            CMP AL, '9'
            JA AskSecondAgain

            ; Store Value
            MOV AH, 01h
            MOV BX, OFFSET second_value
            MOV [BX], AL
            RET
    ASK_SECOND ENDP
    
    ASK_OPERATOR PROC
        AskOperatorAgain:
            MOV DH, 03h
            MOV DL, 01Bh
            CALL RESET_CURSOR_VALUE

            CALL ASK_INPUT
            CMP AL, '+'
            JE OperatorContinue
            CMP AL, '-'
            JE OperatorContinue
            CMP AL, '*'
            JE OperatorContinue
            CMP AL, '/'
            JE OperatorContinue
            JMP AskOperatorAgain
            OperatorContinue:
                ; Store Value
                MOV AH, 01h
                MOV BX, OFFSET operator_value
                MOV [BX], AL
                RET
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
        
        MOV DH, 06h
        MOV DL, 01Bh
        CALL MOVE_CURSOR

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

    ; Assumes that DL and DH are already been configured
    RESET_CURSOR_VALUE PROC ; Aguirre
        CALL MOVE_CURSOR
        PUSH DX
        MOV AH, 02h
        MOV DL, ' '
        INT 21h
        POP DX
        CALL MOVE_CURSOR
        RET
    RESET_CURSOR_VALUE ENDP

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

    GET_ANSWER PROC ; Aguirre
        MOV BX, OFFSET answer_value
        MOV DX, [BX]
        RET
    GET_ANSWER ENDP

    DISPLAY_TOP PROC ; Aguirre
        ; DA - ┌
        MOV AH, 02h
        MOV DL, 0DAh
        INT 21h
        
        ; C4 - ─
        mov CX, 30
        MOV DL, 0C4h
        TopDisplayCharacterLoop:
            INT 21h
            loop TopDisplayCharacterLoop
        
        ; BF - ┐
        MOV DL, 0BFh
        INT 21h    

        MOV AH, 09h
        MOV DX, offset new_line
        INT 21h
        RET
    DISPLAY_TOP ENDP

    DISPLAY_BOT PROC ; Aguirre
        ; C0 - └
        MOV AH, 02h
        MOV DL, 0C0h
        INT 21h
        
        ; C4 - ─
        mov CX, 30
        MOV DL, 0C4h
        BotDisplayCharacterLoop:
            INT 21h
            loop BotDisplayCharacterLoop
        
        ; D9 - ┘
        MOV DL, 0D9h
        INT 21h    

        MOV AH, 09h
        MOV DX, offset new_line
        INT 21h
        RET
    DISPLAY_BOT ENDP

    DISPLAY_NEWLINE PROC
        MOV AH, 09h
        MOV DX, offset new_line
        INT 21h
        RET
    DISPLAY_NEWLINE ENDP
end MAIN