title Calculator Project - GROUP 1
.model small
.stack
.data
    ; Prompt Variable
    first_prompt    db " Enter the first number :     $"
    second_prompt   db " Enter the second number:     $"
    operator_prompt db " Enter the operation    :     $" 
    ans_prompt      db " Answer                 :     $"
    end_prompt      db " Try Again              :     $"
    new_line        db 0ah, 0dh, '$'

    ; Support Prompts
    sup_operator    db " [ + | - | * | / ] $"
    sup_number      db " [ 0 - 9 ]$"
    sup_try_again   db " [ Y | y | Any Value (exit) ] $"
    sup_clear_error db "                                  $"

    ; Errors Variables
    ; 0001 -> Wrong Input  (General) [No Use for now]
    ; 0011 -> Wrong Input Operator
    ; 0101 -> Wrong Input First Number
    ; 0111 -> Wrong Input Second Number
    ; 1001 -> Wrong Input Try Again
    err_flag        db 0000b  
    err_input       db " [!] Wrong Input$"
    ; Signifies to what variable the procedure CHECK_VALUE will check 
    ; 0001 -> first_value
    ; 0010 -> second_value 
    ; 0100 -> operator
    ; 1000 -> try again
    err_check       db 0000b

    ; Calculation Variables
    first_value_array   db 20h,0h, 20h dup('$')
    second_value_array  db 20h,0h, 20h dup('$')
    first_value         dw 32h
    second_value        dw 39h
    operator_value      db 00h
    answer_value        dw 0FFh     ; Default to Infinite
    remainder_value     dw 00h
    answer_value_array  db 20h, 0h, 20h dup('$')
    value_flag          db 00h      ; tell if it's a negative (0001) or infinite (0010)

    ; Program Start Variables
    start1		  db "IT150-8L / OL165$"
    start2		  db "BASIC ARITHMETIC OPERATIONS CALCULATOR$"
    start3		  db "By Group 1$"
    start4		  db "[ Press any key to start ]$"
    start5		  db "--------------------------------------$"

    buffer        db 20h,0h, 20h dup('$')


.code
    ; [ Main Function ]

    MAIN PROC ; Aguirre
        ; Initialize the data
        MOV AX, @data
        MOV DS, AX
        MOV ES, AX

        CALL RESET_VALUE
	    CALL CLEAR_SCREEN

        ;set cursor position
	    MOV AH, 2
        MOV BH, 0
        MOV DH, 6
        MOV DL, 21
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000010b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET start5
        INT 21H

        ;set cursor position
        MOV AH, 2
        MOV BH, 0
        MOV DH, 8
        MOV DL, 32
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET start1
        INT 21H

        ;set cursor position
        MOV AH, 2
        MOV BH, 0
        MOV DH, 9
        MOV DL, 21
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET start2
        INT 21H

        ;set cursor position
        MOV AH, 2
        MOV BH, 0
        MOV DH, 10
        MOV DL, 35
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET start3
        INT 21H

        ;set cursor position
        MOV AH, 2
        MOV BH, 0
        MOV DH, 12
        MOV DL, 26
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 10000110b
        MOV CX, 26
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET start4
        INT 21H

        ;set cursor position
        MOV AH, 2
        MOV BH, 0
        MOV DH, 14
        MOV DL, 21
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000010b
        MOV CX, 38
        INT 10H

        MOV AH, 9
        MOV DX, offset start5
        INT 21H

        ;set cursor position
        MOV AH, 2
        MOV BH, 0
        MOV DH, 16
        MOV DL, 40
        INT 10H

        MOV AH, 1
        INT 21H

        MainContinue:
        
            ; Initialize Screen
            CALL RESET_VALUE
            CALL CLEAR_SCREEN
            
            ; Calling the main procedures
            CALL DISPLAY_FIRST_PROMPT
            CALL ASK_FIRST
            CALL DISPLAY_SECOND_PROMPT
            CALL ASK_SECOND

            ; Convert the inputs to hex
            CALL CONVERT_TO_HEX

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
                MOV DH, 16
                MOV DL, 36
                CALL MOVE_CURSOR
                MOV AH, 01h
                INT 21h

                ; The program will stop if any value is entered other than 'y'
                CMP AL, 'y'
                JE MainContinue
                CMP AL, 'Y'
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
        MOV DH, 6
        MOV DL, 08h
        CALL MOVE_CURSOR

        CALL DISPLAY_TOP

        MOV DH, 7
        MOV DL, 08h
	  CALL MOVE_CURSOR

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET first_prompt

        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 10
        INT 10h
      
        MOV DX, OFFSET sup_number
        int 21h

        CALL DISPLAY_NEWLINE

        MOV DH, 8
        MOV DL, 08h
	  CALL MOVE_CURSOR
        CALL DISPLAY_BOT
        RET
    DISPLAY_FIRST_PROMPT ENDP

    DISPLAY_SECOND_PROMPT PROC  ; Paul
        MOV DH, 8
        MOV DL, 08h
        CALL MOVE_CURSOR
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET second_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 10
        INT 10h
      
        MOV AH, 09h
        MOV DX, OFFSET sup_number
        int 21h

        CALL DISPLAY_NEWLINE
	  MOV DH, 9
        MOV DL, 08h
        CALL MOVE_CURSOR
        CALL DISPLAY_BOT
        RET
    DISPLAY_SECOND_PROMPT ENDP

    DISPLAY_OPERATOR_PROMPT PROC ; Paul
        MOV DH, 9
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET operator_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 18
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET sup_operator
        int 21h

        CALL DISPLAY_NEWLINE

	  MOV DH, 10
        MOV DL, 08h
        CALL MOVE_CURSOR
        CALL DISPLAY_BOT
        RET
    DISPLAY_OPERATOR_PROMPT ENDP
    
    DISPLAY_ANSWER_BOX PROC ; Paul
        MOV DH, 11
        MOV DL, 08h
        CALL MOVE_CURSOR
        CALL DISPLAY_TOP

        MOV DH, 12
        MOV DL, 08h
        CALL MOVE_CURSOR
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET ans_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        CALL DISPLAY_NEWLINE

        MOV DH, 13
        MOV DL, 08h
        CALL MOVE_CURSOR
        CALL DISPLAY_BOT
        RET
    DISPLAY_ANSWER_BOX ENDP
    
    DISPLAY_TRY_AGAIN_BOX PROC ; Paul
        MOV DH, 15
        MOV DL, 08h
        CALL MOVE_CURSOR
        CALL DISPLAY_TOP
        
        MOV DH, 16
        MOV DL, 08h
        CALL MOVE_CURSOR
	  
	  ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET end_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 29
        INT 10h
        MOV AH, 09
        MOV DX, OFFSET sup_try_again
        int 21h

        CALL DISPLAY_NEWLINE
        
        MOV DH, 17
        MOV DL, 08h
        CALL MOVE_CURSOR
	  CALL DISPLAY_BOT
        RET
    DISPLAY_TRY_AGAIN_BOX ENDP
    
    ; [ Prompts ]
    ASK_FIRST PROC ; Ambraie
        CALL RESET_REGISTER
        ; Reset The Flag
        MOV BX, OFFSET err_flag
        MOV AX, 00h
        MOV [BX], AX

        AskFirstAgain:
            MOV DH, 7
            MOV DL, 36
            CALL RESET_CURSOR_VALUE

            ; Get and store the value
            MOV DX, OFFSET first_value_array
            CALL ASK_INPUT
            ; Check First value
            MOV BX, OFFSET err_check
            MOV AX, 00000001b
            MOV [BX], AL

            MOV SI, OFFSET first_value_array
            CALL CHECK_VALUE
            
            MOV BX, OFFSET err_flag
            MOV AX, [BX]

            CMP AL, 0101b
            JE FirstInputError
            JMP FirstInputContinue
            FirstInputError:
                CALL PRINT_ERROR
                MOV BX, OFFSET err_flag
                MOV AX, 00000000b
                MOV [BX], AL
                MOV SI, OFFSET first_value_array
                CALL RESET_ARRAY_VALUE
                JMP AskFirstAgain
            FirstInputContinue:
                ; Store Value
                CALL RESET_REGISTER
                
                ; Clear the Error Text
                MOV AX, 00000101b
                MOV BX, OFFSET err_flag
                MOV [BX], AL
                CALL CLEAR_OPERATOR
                RET
    ASK_FIRST ENDP
   
    ASK_SECOND PROC ; Ambraie
        CALL RESET_REGISTER
        AskSecondAgain:
            MOV DH, 8
            MOV DL, 36
            CALL RESET_CURSOR_VALUE

            ; Get and store the value
            MOV DX, OFFSET second_value_array
            CALL ASK_INPUT
            ; Check second value
            MOV BX, OFFSET err_check
            MOV AX, 00000010b
            MOV [BX], AL

            
            MOV SI, OFFSET second_value_array
            CALL CHECK_VALUE
            
            MOV BX, OFFSET err_flag
            MOV AX, [BX]

            CMP AL, 0111b
            JE SecondInputError
            JMP SecondInputContinue
            SecondInputError:
                CALL PRINT_ERROR
                MOV BX, OFFSET err_flag
                MOV AX, 00000000b
                MOV [BX], AX
                MOV SI, OFFSET second_value_array
                CALL RESET_ARRAY_VALUE
                JMP AskSecondAgain
            SecondInputContinue:
                ; Store Value
                CALL RESET_REGISTER
                
                ; Clear the error text
                MOV AX, 00000111b
                MOV BX, OFFSET err_flag
                MOV [BX], AX
                CALL CLEAR_OPERATOR
                RET
    ASK_SECOND ENDP
    
    ASK_OPERATOR PROC ; Ambraie
        AskOperatorAgain:
            MOV DH, 9
            MOV DL, 36
            CALL RESET_CURSOR_VALUE
            
            MOV AH, 01h
            INT 21h
            PUSH AX

            CMP AL, '+'
            JE OperatorContinue
            CMP AL, '-'
            JE OperatorContinue
            CMP AL, '*'
            JE OperatorContinue
            CMP AL, '/'
            JE OperatorContinue
            JMP OperatorInputError

            OperatorInputError:
                MOV AX, 00000011b
                MOV BX, OFFSET err_flag
                MOV [BX], AX
                CALL PRINT_ERROR
                POP AX
                JMP AskOperatorAgain
            OperatorContinue:
                ; Store Value
                CALL RESET_REGISTER
                POP AX
                MOV AH, 00h
                MOV BX, OFFSET operator_value
                MOV [BX], AX
                
                MOV AX, 00000011b
                MOV BX, OFFSET err_flag
                MOV [BX], AX
                CALL CLEAR_OPERATOR
                RET
    ASK_OPERATOR ENDP

    ; [ Operations ]
    ; - Assumes that first_value and second_value are already configured by CONVERT_TO_HEX
    ADD_VALUE PROC  ; Aguirre
        CALL RESET_REGISTER
        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]

        ; Add Value and Save
        ADD AX, CX
        MOV BX, OFFSET answer_value
        MOV [BX], AX
        RET
    ADD_VALUE ENDP

    SUB_VALUE PROC  ; Aguirre
        CALL RESET_REGISTER
        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]

        ; Subtract the values
        SUB AX, CX

        CMP AX, 0
        JL NegativeValue
        PositiveValue:
            MOV BX, OFFSET answer_value
            MOV [BX], AX
            JMP SubtractionEnd
        NegativeValue:
            MOV CX, 0FFFFh
            SUB CX, AX;
            INC CX                          ; The value is less than one everytime when we have negative value
            MOV BX, OFFSET answer_value
            MOV [BX], CX

            ; Assing Flag
            MOV BX, OFFSET value_flag
            MOV AX, 01h                     ; 01h indicates that it's a negative value
            MOV [BX], AX                   
        SubtractionEnd:
            RET
    SUB_VALUE ENDP

    MUL_VALUE PROC ; Aguirre
        CALL RESET_REGISTER
        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]
        MOV BX, CX

        ; Add Value and Save
        MUL BX
        MOV BX, OFFSET answer_value
        MOV [BX], AX
        RET
    MUL_VALUE ENDP

    DIV_VALUE PROC ; Aguirre
        CALL RESET_REGISTER
        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]

        MOV DX, 00h                     ; Reset

        CMP CX, 30h
        JE InfiniteValue
        JMP NonInfinite
        InfiniteValue:
            MOV BX, OFFSET value_flag
            MOV AX, 02h
            MOV [BX], AX
            JMP DivisionEnd
        NonInfinite:
            MOV BX, CX                      ; Put the Multiplier in position
    
            ; Add Value and Save
            DIV BX
            MOV BX, OFFSET answer_value
            MOV [BX], AX
            MOV BX, OFFSET remainder_value
            mov [BX], DX
        DivisionEnd:
            RET
    DIV_VALUE ENDP 

    ; [ Error Handline ]
    PRINT_ERROR PROC ; Ryoji
        ; get error value
        MOV BX, OFFSET err_flag
        MOV AX, [BX]

        CMP AL, 0011b               ; Input Operator Error
        JE OperatorError
        CMP AL, 0101b              ; Input First Number Error
        JE FirstNumberError
        CMP AL, 0111b              ; Input Second Number Error
        JE SecondNumberError
        CMP AL, 1001b              ; Input Try Again Error
        JE TryAgainError
        JMP NoErrorContinue
        OperatorError:
            CALL PRINT_OPERATOR_ERROR
            JMP NoErrorContinue
        FirstNumberError:
            CALL PRINT_FIRST_NUMBER_ERROR
            JMP NoErrorContinue
        SecondNumberError:
            CALL PRINT_SECOND_NUMBER_ERROR
            JMP NoErrorContinue
        TryAgainError:
            CALL PRINT_TRY_AGAIN_ERROR
        NoErrorContinue:
            RET
    PRINT_ERROR ENDP

    PRINT_OPERATOR_ERROR PROC  ; Ryoji
        MOV DH, 9
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV BL, 10001100b ;Color Red (Blinking)
        MOV CX, 19
        INT 10h
        MOV AH, 09h;
        MOV DX, OFFSET err_input
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 18
        INT 10h
        
        MOV DX, OFFSET sup_operator
        INT 21h
        RET
    PRINT_OPERATOR_ERROR ENDP

    PRINT_FIRST_NUMBER_ERROR PROC  ; Ryoji
        MOV DH, 7
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV BL, 10001100b ;Color Red (Blinking)
        MOV CX, 19
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET err_input
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 10
        INT 10h

        MOV DX, OFFSET sup_number
        INT 21h
        RET
    PRINT_FIRST_NUMBER_ERROR ENDP

    PRINT_SECOND_NUMBER_ERROR PROC  ; Ryoji
        MOV DH, 8
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV BL, 10001100b ;Color Red (Blinking)
        MOV CX, 19
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET err_input
        INT 21h

        MOV AH, 09h
        MOV BL, 00001011b ;Color Blue
        MOV CX, 10
        INT 10h

        MOV DX, OFFSET sup_number
        INT 21h
        RET
    PRINT_SECOND_NUMBER_ERROR ENDP

    PRINT_TRY_AGAIN_ERROR PROC  ; Ryoji
        MOV DH, 14
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV DX, OFFSET err_input
        INT 21h

        MOV DX, OFFSET sup_try_again
        INT 21h
        RET
    PRINT_TRY_AGAIN_ERROR ENDP

    CLEAR_OPERATOR PROC  ; Hans
        ; get error value
        MOV BX, OFFSET err_flag
        MOV AX, [BX]

        CMP AL, 00000011b              ; Input Operator Clear
        JE OperatorClear
        CMP AL, 00000101b              ; Input First Number Clear
        JE FirstNumberClear
        CMP AL, 00000111b              ; Input Second Number Clear
        JE SecondNumberClear
        CMP AL, 00001001b              ; Input Try Again Clear
        JE TryAgainClear
        JMP NoClearContinue
        OperatorClear:
            CALL PRINT_OPERATOR_CLEAR
            JMP NoClearContinue
        FirstNumberClear:
            CALL PRINT_FIRST_NUMBER_CLEAR
            JMP NoClearContinue
        SecondNumberClear:
            CALL PRINT_SECOND_NUMBER_CLEAR
            JMP NoClearContinue
        TryAgainClear:
            CALL PRINT_TRY_AGAIN_CLEAR
        NoClearContinue:
            RET
    CLEAR_OPERATOR ENDP

    PRINT_OPERATOR_CLEAR PROC  ; Hans
        MOV DH, 9
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_OPERATOR_CLEAR ENDP

    PRINT_FIRST_NUMBER_CLEAR PROC  ; Hans
        MOV DH, 7
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_FIRST_NUMBER_CLEAR ENDP

    PRINT_SECOND_NUMBER_CLEAR PROC  ; Hans
        MOV DH, 8
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_SECOND_NUMBER_CLEAR ENDP

    PRINT_TRY_AGAIN_CLEAR PROC  ; Hans
        MOV DH, 14
        MOV DL, 40
        CALL MOVE_CURSOR

        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_TRY_AGAIN_CLEAR ENDP


    ; [ Printing ]

    DISPLAY_ANSWER PROC ; Aguirre
        MOV DH, 12
        MOV DL, 35
        CALL MOVE_CURSOR

        ; Get the flag
        MOV BX, OFFSET value_flag
        MOV DX,[BX]

        ; Comparing
        CMP DL, 01h                         ; Check if the value is negative
        JE DisplayNegative
        CMP DL, 02h                        ; Check if the value is infinite
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
            MOV AH, 02h
            MOV DX, '-'
            INT 21h
        ContinueOperatorDisplay:
            CALL PRINT_ANSWER

            MOV BX, OFFSET remainder_value
            MOV AX, [BX]
            CMP AX, 00h             ; If there are no remainder
            JE EndDigit
            RemainderThings:
                MOV AH, 02h
                MOV DL, 'r'
                INT 21h

                MOV AX, '$'         ; Signifies the end of looping
                PUSH AX         

                CALL RESET_REGISTER

                MOV BX, OFFSET remainder_value
                MOV AX, [BX]
                MOV CX, 01h
                RemainderTransform:
                    MOV BX, 0Ah
                    DIV BX
                    ADD DX, 30h
                    PUSH DX
                    MOV DX,00h
                    CMP AX, 00h
                    JE StopRemainderTransform
                    MOV CX, 02h
                    loop RemainderTransform
                StopRemainderTransform:
                    MOV CX, 01h
                    MOV AH, 02h
                    PrintRemainderLoop:
                        POP DX
                        CMP DX, '$'
                        JE EndDigit
                        INT 21h
                        MOV CX, 02h
                        loop PrintRemainderLoop

            EndDigit:
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

    ; Assumes that DX is initialize before calling
    ASK_INPUT PROC  ; Aguirre
        MOV AH, 0Ah
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
        MOV DX, OFFSET new_line
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
        MOV DX, OFFSET new_line
        INT 21h
        RET
    DISPLAY_BOT ENDP

    DISPLAY_NEWLINE PROC ; Aguirre
        MOV AH, 09h
        MOV DX, OFFSET new_line
        INT 21h
        RET
    DISPLAY_NEWLINE ENDP
    
    RESET_VALUE PROC ; Aguirre
        
        MOV BX, OFFSET err_flag
        MOV AX, 00h
        MOV [BX], AX
        
        MOV BX, OFFSET first_value
        MOV AX, 00h
        MOV [BX], AX
        
        MOV BX, OFFSET second_value
        MOV AX, 00h
        MOV [BX], AX
        
        MOV BX, OFFSET operator_value
        MOV AX, 00h
        MOV [BX], AX
        
        MOV BX, OFFSET answer_value
        MOV AX, 0FFh
        MOV [BX], AX
        
        MOV BX, OFFSET remainder_value
        MOV AX, 00h
        MOV [BX], AX
        
        MOV BX, OFFSET value_flag
        MOV AX, 00h
        MOV [BX], AX

    RESET_VALUE ENDP

    ; Assumes that err_check is configured before calling
    ; Assumes that SI is configured before calling
    CHECK_VALUE PROC ; Aguirre
        ;MOV SI, OFFSET buffer

        INC SI              ; Point to the value_size: [array_size, value_size, ..., '$']
        MOV CX, [SI]        ; Get the Size of the array
        MOV CH, 00h         ; Reset
        INC SI              ; Get the Value
        CheckingLoop:
            MOV AX, [SI]
            CMP AL, '0'
            JB GeneralInputError
            CMP AL, '9'
            JA GeneralInputError
            INC SI
            loop CheckingLoop
        JMP CheckingIsGood

        GeneralInputError:
            ; get the checking value
            MOV BX, OFFSET err_check
            MOV AX, [BX]

            CMP AL, 0001b
            JE FirstValueErr
            CMP AL, 0010b
            JE SecondValueErr

            ; If err_check didn't get configured
            ; then it will automatically print out FirstValueErr
            ; Again, we assume that it's configured, if for some reason not, then CONFIGURE IT
            FirstValueErr:
                MOV BX, OFFSET err_flag
                MOV AX, 00000101b
                MOV [BX], AL
                JMP CheckingIsGood
            SecondValueErr:
                MOV BX, OFFSET err_flag
                MOV AX, 00000111b
                MOV [BX], AL
                JMP CheckingIsGood
        CheckingIsGood:
            RET
    CHECK_VALUE ENDP

    RESET_REGISTER PROC ; Aguirre
        MOV AX, 00h
        MOV BX, 00h
        MOV CX, 00h
        MOV DX, 00h
        RET
    RESET_REGISTER ENDP

    ; Assumes that SI is configured
    RESET_ARRAY_VALUE PROC
        ; Point to the size
        INC SI
        ; Get the size
        MOV CX, [SI]
        ; Reset
        MOV CH, 00h
        ; Point to the value
        INC SI
        ResetArrayLoop:
            MOV AX, 00h
            ; Reset the value pointed by SI
            MOV [SI], AL
            INC SI
            loop ResetArrayLoop
        RET
    RESET_ARRAY_VALUE ENDP

    ; Assumes SI and DI is configured to pointing to the size
    TRANSFORM_VALUE PROC ; Aguirre
        ; Imperative since we are handling 2 bytes of memory
        CALL RESET_REGISTER

        ; store the size and reset CH
        MOV CX, [SI]
        MOV CH, 00h

        ; Point to the first real element of the array
        INC SI

        ; Store the size for later use
        transformingLoop:
            ; store the original CX for later use
            PUSH CX
            CMP CX, 2                   ; If it only has 2 digits
            JE JustMultiplyTen
            CMP CX, 1                   ; If it only has 1 digit
            JE JustMultiplyOne

            NormalPowerMultiple:        ; >= 3 Digits
                ; Let 'y' be the first digit in a number and 'n' be its place value
                ; ( (y*(10^(n-2))) + (((y-1)*(10^(n-2)))) + ... )

                SUB CX, 2                       ; Sub the CX (it's the place value) by '2'

                ; Store 10 (decimal) in AL and BL to loop to get the power
                MOV AL, 0Ah
                MOV BL, 0AH

                ; Push DX (since every multiplication DX get reset for remainders)
                ; DX is used to store the hexadecimal equivalent of the numbers
                PUSH DX

                PowerLoop:                      ; Calculate the power
                    MUL BX
                    loop PowerLoop
                POP DX                          ; Restore the DX 
                JMP JustNormalContinue
            JustMultiplyTen:
                MOV AL, 0Ah
                JMP JustNormalContinue
            JustMultiplyOne:
                MOV AL, 01h
            JustNormalContinue:
                POP CX                          ; Restore CX Value
                MOV BL, [SI]                    ; Get the value inside of SI
                SUB BL, 30h                     ; Subtract it by 30h since it's an ASCII
                MOV BH, 00h                     ; Reset 
                PUSH DX                         ; Store DX
                MUL BX                          ; Multiple it as per the formula
                POP DX                          ; Restore DX
                ADD DX, AX                      ; Add it to the previous DX value
                INC SI                          ; Go to the next element
                MOV AX, 00h                     ; RESET
                MOV BX, 00h                     ; RESET
                loop transformingLoop
            RET
    TRANSFORM_VALUE ENDP

    ; Convert First and Second Value to HEX
    CONVERT_TO_HEX PROC ; Aguirre

        ; Transform First Value to HEX
        MOV SI, OFFSET first_value_array+1
        MOV DI, OFFSET first_value_array+1
        CALL TRANSFORM_VALUE
        ; Then store it to the 'first_value'
        MOV BX, OFFSET first_value
        MOV [BX], DX

        ; Transform second Value to HEX
        MOV SI, OFFSET second_value_array+1
        MOV DI, OFFSET second_value_array+1
        CALL TRANSFORM_VALUE
        ; Then store it to the 'second_value'
        MOV BX, OFFSET second_value
        MOV [BX], DX


        MOV SI, OFFSET answer_value_array + 2
        ;CALL ADD_VALUE
        ;CALL PRINT_ANSWER
        
        RET
    CONVERT_TO_HEX ENDP

    PRINT_ANSWER PROC ; aguirre
        ; Will be use later for "PrintingLoop"
        MOV AX, '$'
        PUSH AX

        CALL RESET_REGISTER

        ; Get and store the value inside of answer_value
        MOV BX, OFFSET answer_value
        MOV AX, [BX]
        MOV CX, 01h     

        ; Convert the Hex to Decimal To ASCII
        ConvertingDataLoop:
            MOV BX, 0AH                 ; Initializes Divisor (10d)
            DIV BX                      ; Divide the answer by 0Ah (10d)
            MOV CX, AX                  ; Store AX
            ADD DL, 30h                 ; Convert to ASCII
            PUSH DX                     ; Put it in the stack (to be printed later)
            INC SI                      ; Point SI to the next pointer
            MOV AX, CX                  ; Restore AX
            MOV BX, 00h                 ; Reset BX
            MOV DX, 00h                 ; Reset DX
            CMP AX, 0000h               ; Stop the Converting if AX doesn't have any values
            JE PrintingLoop
            MOV CX, 02h                 ; Since we are not sure how many times we will divide, we'll put infinity
            LOOP ConvertingDataLoop
        
        ; Print all the values in the stack
        PrintingLoop:
            MOV AH, 02h
            POP DX
            CMP DX, '$'                 ; If the value inside of the stack is '$' then stop printing
            JE StopPrinting
            INT 21h
            LOOP PrintingLoop
        StopPrinting:
            RET
    PRINT_ANSWER ENDP

end MAIN