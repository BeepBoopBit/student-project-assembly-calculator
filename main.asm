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
    start1		  db " IT150-8L / OL165$"
    start2		  db "BASIC ARITHMETIC OPERATIONS CALCULATOR$"
    start3		  db "By Group 1$"
    start4		  db "[ Press [1] go to Instructions ]$"
    start5		  db "[ Press [2] go to Caclculator ]$"
    start6		  db "[ Press [3] go to Exit ]$"
    start7		  db "--------------------------------------$"
    buffer        db 20h,0h, 20h dup('$')
   
    
    ;Program Instructions Press Variables
    press1		  db "< Press [1] to Back$"
    press2		  db "Press [2] to Next >$"

    ;Program Instructions 1 Variables
    inst1a		  db "Range of Supported Numbers and  What to Input$"
    inst1b		  db "INSTRUCTIONS (1/4)$"
    inst1c		  db "Program will only accept numbers from$"
    inst1d        db " [0 - 65535].$"
    inst1e        db "Program will only support$"
    inst1f        db " [5$"
    inst1g        db " digit input.$"
    inst1h        db "Program will be expecting the following$"
    inst1i        db "operators:$"
    inst1j        db " [+ - * /]$"

    ;Program Instructions 2 Variables
    inst2a		  db "         How to Use the Program$"
    inst2b		  db "INSTRUCTIONS (2/4)$"
    inst2c		  db "1. Enter the First Number$"
    inst2d        db "  [0 - 65535]$"
    inst2e        db "2. Enter the Second Number$"
    inst2f        db " [0 - 65535]$"
    inst2g        db "3. Enter the Appopriate Operator$"
    inst2h        db "+$"
    inst2i        db " = Addition, $"
    inst2j        db "-$"
    inst2k        db " = Subtraction,$"
    inst2l        db "*$"
    inst2m        db " = Multiplication, $"
    inst2n        db " /$"
    inst2o        db " = Divsion$"
    inst2p        db "4. See the Results$"
    inst2q        db "5. Enter $"
    inst2r        db "[Y or y]$"
    inst2s        db " if try again, else$"
    inst2t        db "enter any value to exit$"

    ;Program Instructions 3 Variables
    inst3a        db "How to Read Errors$"
    inst3b        db "INSTRUCTIONS (3/4)$"
    inst3c        db "1. Input error, if the First Number is not a$"
    inst3d        db " positive$"                                           ;color
    inst3e        db "integer$"                                             ;color
    inst3f        db "2. Input error, if the Second Number is not a$"
    inst3g        db " positive$"                                           ;color
    inst3h        db "integer$"                                             ;color
    inst3i        db "3. Input error, if the Operator is $"
    inst3j        db "different$"                                           ;color                                       
    inst3k        db " on the$"
    inst3l        db "instructions$"


    ;Program Instructions 4 Variables
    inst4a        db "Example$"
    inst4b        db "INSTRUCTIONS (4/4)$"
    inst4c        db "2333$"
    inst4d        db "126 $"
    inst4e        db "+   $"
    inst4f        db "2459$"
    inst4g        db "Y   $"

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
        MOV DH, 6
        MOV DL, 15H
        CALL MOVE_CURSOR

        ;set color
        MOV AH, 09h
        MOV BL, 10000010b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET start7 ;Prompts for the "------------------------"
        INT 21H

      ;set cursor position
        MOV DH, 8
        MOV DL, 20H
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET start1 ;Prompts for the "IT150-8L / OL165"
        INT 21H

        ;set cursor position
        MOV DH, 9
        MOV DL, 15H
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET start2 ;Prompts for the "BASIC ARITHMETIC OPERATIONS CALCULATOR"
        INT 21H

        ;set cursor position
        MOV DH, 0AH
        MOV DL, 23H
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET start3 ;Prompts for the "By Group 1"
        INT 21H

        ;set cursor position
        MOV DH, 0DH
        MOV DL, 1AH
        CALL MOVE_CURSOR

        ;set color
        MOV AH, 09h
        MOV BL, 00000110b
        MOV CX, 34
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET start4 ;Prompts for the "[ Press [1] go to Instructions ]"
        INT 21H

        ;set cursor position
        MOV DH, 0EH
        MOV DL, 1AH
        CALL MOVE_CURSOR

        ;set color
        MOV AH, 09h
        MOV BL, 00000110b
        MOV CX, 32
        INT 10H

        MOV AH, 9
        MOV DX, offset start5 ;Prompts for the "[ Press [2] go to Caclculator ]"
        INT 21H

        ;set cursor position
        MOV DH, 0FH
        MOV DL, 1AH
        CALL MOVE_CURSOR

        ;set color
        MOV AH, 09h
        MOV BL, 00000110b
        MOV CX, 25
        INT 10H

        MOV AH, 9
        MOV DX, offset start6 ;Prompts for the "[ Press [3] go to Exit ]"
        INT 21H

        ;set cursor position
        MOV DH, 11H
        MOV DL, 15H
        CALL MOVE_CURSOR

        ;set color
        MOV AH, 09h
        MOV BL, 10000010b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET start7 ;Prompts for the "------------------------"
        INT 21H

        ;set cursor position
        MOV DH, 10H
        MOV DL, 28H
        CALL MOVE_CURSOR

        ;Get Input of the user
        MOV AH, 1
        INT 21H

       ;CMP AL, '1'
       ;JE DISPLAY_INST1
       ;CMP AL, '2'
       ;JE DISPLAY_FIRST_PROMPT
       ;CMP AL, '3'
       ;JE EXIT PROC

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
                CALL CLEAR_SCREEN
                MOV DH, 0Bh
                MOV DL, 00h
                CALL MOVE_CURSOR
                ; terminate the program
                MOV AH, 04Ch
                INT 21h
    MAIN ENDP

    ; [Display]
    DISPLAY_INST1 PROC
        ; top green background
	    mov bh,00100000b 
	    mov ch,0 
	    mov cl,0
	    mov dh,1
	    mov dl,79
	    int 10h

	    ; bottom green background
	    mov bh,00100000b 
	    mov ch,23
	    mov cl,0
	    mov dh,24
	    mov dl,79
	    int 10h

	    ; Press [1] to Back
        ; set cursor position
        MOV DH, 03h
        MOV DL, 0h
        CALL MOVE_CURSOR

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press1
        INT 21H

	    ; Press [2] to Next
        ;set cursor position
        MOV DH, 03h
        MOV DL, 3Dh
        CALL MOVE_CURSOR

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press2
        INT 21H

	    ; Prompts
        ; set cursor position
        MOV DH, 09h
        MOV DL, 12h
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET inst1a
        INT 21H

        ; set cursor position
        MOV DH, 0Ah
        MOV DL, 20h
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET inst1b
        INT 21H

        ; set cursor position
        MOV DH, 0Ch
        MOV DL, 10h
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET inst1c
        INT 21H

	    ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 12
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst1d
        INT 21H

        ; set cursor position
        MOV DH, 0Dh
        MOV DL, 14h
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET inst1e
        INT 21H

	    ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 4
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst1f
        INT 21H

        MOV AH, 9
        MOV DX, OFFSET inst1g
        INT 21H

        ; set cursor position
        MOV DH, 0Eh
        MOV DL, 15h
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET inst1h
        INT 21H

        ; set cursor position
        MOV DH, 0Fh
        MOV DL, 1Eh
        CALL MOVE_CURSOR

        MOV AH, 9
        MOV DX, OFFSET inst1i
        INT 21H

	    ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 10
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst1j
        INT 21H

        ; set cursor position
        MOV DH, 17h
        MOV DL, 28h
        CALL MOVE_CURSOR
        RET
    DISPLAY_INST1 ENDP

    DISPLAY_INST2 PROC

    	; top green background
	    MOV BH,00100000b 
	    MOV CH,0 
	    MOV CL,0
	    MOV DH,1
	    MOV DL,4FH
	    INT 10H

	    ; bottom green background
	    MOV BH,00100000b 
	    MOV CH,23
	    MOV CL,0
	    MOV DH,18H
	    MOV DL,4FH
	    INT 10H

	    ; Press [1] to Back
        ; set cursor position
        MOV DH, 3
        MOV DL, 0
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press1 ;Prompts the "< Press [1] to Back"
        INT 21H

	    ; Press [2] to Next
        ;set cursor position
        MOV DH, 3
        MOV DL, 3DH
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press2 ;Prompts the "Press [2] to Next >"
        INT 21H

        ; Prompts
        ; set cursor position
        MOV DH, 7
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2a ;Prompts "How to Use the Program"
        INT 21H

        ; set cursor position
        MOV DH, 8
        MOV DL, 20H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2b ;Prompts "Instructions"
        INT 21H

        ; set cursor position
        MOV DH, 0BH
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2c ;Prompts "Enter the First Number"
        INT 21H

	    ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 13
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2d ;Prompts "65535"
        INT 21H

       ; set cursor position
        MOV DH, 0CH
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2e ;Prompts "Enter the Second Number""
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 12
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2f ;Prompts "65535"
        INT 21H

        ; set cursor position
        MOV DH, 0DH
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2g ;Prompts "Enter the Operator"
        INT 21H

        ; set cursor position
        MOV DH, 0EH
        MOV DL, 18H
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 1
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2h ;Prompts the '+' Sign
        INT 21H

        MOV AH, 9
        MOV DX, OFFSET inst2i ;Prompts the " = Addition"
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 1
        INT 10h

        ; set cursor position
        MOV DH, 0EH
        MOV DL, 2DH
        CALL MOVE_CURSOR
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 1
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2j ;Prompts the '-' Sign
        INT 21H

        MOV AH, 9
        MOV DX, OFFSET inst2k ;Prompts the "= Subtraction"
        INT 21H

        ; set cursor position
        MOV DH, 0FH
        MOV DL, 18H
        CALL MOVE_CURSOR
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 2
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2l ;Prompts the '*' Sign
        INT 21H

        MOV AH, 9
        MOV DX, OFFSET inst2m ;Prompts the " = Multiplication"
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 3
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2n ;Prompts the '/' Sign
        INT 21H

        MOV AH, 9
        MOV DX, OFFSET inst2o ;Prompts the " = Division"
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 10
        INT 10h

        ; set cursor position
        MOV DH, 10H
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2p ;Prompts the "4. See the Results"
        INT 21H

        ; set cursor position
        MOV DH, 11H
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2q ;Prompts the "5. Enter"
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 9
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET inst2r ;Prompts the "[Y/y]
        INT 21H

        MOV AH, 9
        MOV DX, OFFSET inst2s ;Prompts the "if try again, else"
        INT 21H

        ; set cursor position
        MOV DH, 12H
        MOV DL, 14H
        CALL MOVE_CURSOR
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst2t ;Prompts the "enter any value to exit"
        INT 21H

        RET
    DISPLAY_INST2 ENDP

    DISPLAY_INST3 PROC

    	; top green background
	    MOV BH,00100000b 
	    MOV CH,0 
	    MOV CL,0
	    MOV DH,1
	    MOV DL,4FH
	    INT 10H

	    ; bottom green background
	    MOV BH,00100000b 
	    MOV CH,23
	    MOV CL,0
	    MOV DH,18H
	    MOV DL,4FH
	    INT 10H

	    ; Press [1] to Back
        ; set cursor position
        MOV DH, 3
        MOV DL, 0
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press1 ;Prompts the "< Press [1] to Back"
        INT 21H

	    ; Press [2] to Next
        ;set cursor position
        MOV DH, 3
        MOV DL, 3DH
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press2 ;Prompts the "Press [2] to Next >"
        INT 21H

        ; Prompts
        ; set cursor position
	    MOV AH, 2
        MOV BH, 0
        MOV DH, 09h
        MOV DL, 20h
        INT 10H

        MOV AH, 09h
        MOV DX, OFFSET inst3a
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Ah
        MOV DL, 20h
        INT 10H

        MOV AH, 09h
        MOV DX, OFFSET inst3b
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Ch
        MOV DL, 10h
        INT 10H

        MOV AH, 09h
        MOV DX, OFFSET inst3c
        INT 21H

	    ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 60
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET inst3d               
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Dh
        MOV DL, 13h
        INT 10H

        MOV AH, 9
        MOV DX, OFFSET inst3e           
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Eh
        MOV DL, 10h
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET inst3f
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 60
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET inst3g       
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Fh
        MOV DL, 13h
        INT 10H        

        MOV AH, 09h
        MOV DX, OFFSET inst3h       
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 10h
        MOV DL, 10h
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET inst3i      
        INT 21H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 12
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET inst3j
        INT 21H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 09h
        MOV DX, OFFSET inst3k
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 11h
        MOV DL, 13h
        INT 10H        

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 12
        INT 10h    

        MOV AH, 09h
        MOV DX, OFFSET inst3l    
        INT 21H        
        
        ; set cursor position
        MOV DH, 17h
        MOV DL, 28h
        CALL MOVE_CURSOR
        RET
    DISPLAY_INST3 ENDP

    DISPLAY_INST4 PROC

    	; top green background
	    MOV BH,00100000b 
	    MOV CH,0 
	    MOV CL,0
	    MOV DH,1
	    MOV DL,4FH
	    INT 10H

	    ; bottom green background
	    MOV BH,00100000b 
	    MOV CH,23
	    MOV CL,0
	    MOV DH,18H
	    MOV DL,4FH
	    INT 10H

	    ; Press [1] to Back
        ; set cursor position
        MOV DH, 3
        MOV DL, 0
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press1 ;Prompts the "< Press [1] to Back"
        INT 21H

	    ; Press [2] to Next
        ;set cursor position
        MOV DH, 3
        MOV DL, 3DH
        CALL MOVE_CURSOR
        INT 10H

        ; set color
        MOV AH, 09h
        MOV BL, 00000111b
        MOV CX, 38
        INT 10h

        MOV AH, 9
        MOV DX, OFFSET press2 ;Prompts the "Press [2] to Next >"
        INT 21H

        ; Prompts
        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 09h
        MOV DL, 25h
        INT 10H

        MOV AH, 09h
        MOV DX, OFFSET inst4a
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Ah
        MOV DL, 20h
        INT 10H

        MOV AH, 09h
        MOV DX, OFFSET inst4b
        INT 21H

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Ch
        MOV DL, 19h
        INT 10H

        CALL DISPLAY_TOP

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Dh
        MOV DL, 19h
        INT 10H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET first_prompt
        int 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Dh
        MOV DL, 34h
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 4
        INT 10h  

        MOV AH, 09h
        MOV DX, OFFSET inst4c
        INT 21H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Eh
        MOV DL, 19h
        INT 10H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET second_prompt
        int 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Eh
        MOV DL, 34h
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 3
        INT 10h  

        MOV AH, 09h
        MOV DX, OFFSET inst4d
        INT 21H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Fh
        MOV DL, 19h
        INT 10H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET operator_prompt
        int 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 0Fh
        MOV DL, 34h
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 1
        INT 10h 


        MOV AH, 09h
        MOV DX, OFFSET inst4e
        INT 21H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 10h
        MOV DL, 19h
        INT 10H

        CALL DISPLAY_BOT

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 11h
        MOV DL, 19h
        INT 10H

        CALL DISPLAY_TOP
        
        ; set cursor position
	    MOV AH, 02
        MOV BH, 0
        MOV DH, 12h
        MOV DL, 19h
        INT 10H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET ans_prompt
        int 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 12h
        MOV DL, 34h
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 4
        INT 10h 

        MOV AH, 09h
        MOV DX, OFFSET inst4f
        INT 21H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 13h
        MOV DL, 19h
        INT 10H

        CALL DISPLAY_BOT

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 14h
        MOV DL, 19h
        INT 10H

        CALL DISPLAY_TOP

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 15h
        MOV DL, 19h
        INT 10H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        MOV AH, 09h
        MOV DX, OFFSET end_prompt
        int 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 15h
        MOV DL, 34h
        INT 10H

        ;set color
        MOV AH, 09h
        MOV BL, 00000011b
        MOV CX, 1
        INT 10h 

        MOV AH, 09h
        MOV DX, OFFSET inst4g
        INT 21H

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; set cursor position
	    MOV AH, 02h
        MOV BH, 0
        MOV DH, 16h
        MOV DL, 19h
        INT 10H

        CALL DISPLAY_BOT

        ; set cursor position
        MOV DH, 17h
        MOV DL, 28h
        CALL MOVE_CURSOR
        RET
    DISPLAY_INST4 ENDP

    DISPLAY_FIRST_PROMPT PROC   ; Paul

        ; Move the cursor
        MOV DH, 6
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; Display the top Line
        CALL DISPLAY_TOP

        ; Move the cursor
        MOV DH, 7
        MOV DL, 08h
	    CALL MOVE_CURSOR

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Print Prompt
        MOV AH, 09h
        MOV DX, OFFSET first_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Set Color to Blue
        MOV AH, 09h
        MOV BL, 00001011b               ;Blue
        MOV CX, 10
        INT 10h

        ; Print Supporting Instruction
        MOV DX, OFFSET sup_number
        int 21h

        ; New line
        CALL DISPLAY_NEWLINE

        ; Move Cursor
        MOV DH, 8
        MOV DL, 08h
	    CALL MOVE_CURSOR
        
        ; Display the Bottom line
        CALL DISPLAY_BOT
        RET
    DISPLAY_FIRST_PROMPT ENDP

    DISPLAY_SECOND_PROMPT PROC  ; Paul
        ; Move cursor
        MOV DH, 8
        MOV DL, 08h
        CALL MOVE_CURSOR
        
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Print Prompt
        MOV AH, 09h
        MOV DX, OFFSET second_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Set Color to Blue
        MOV AH, 09h
        MOV BL, 00001011b                      ;Blue
        MOV CX, 10
        INT 10h
      
        ; Print Supporting Instruction
        MOV AH, 09h
        MOV DX, OFFSET sup_number
        int 21h

        ; Display New Line
        CALL DISPLAY_NEWLINE

        ; Move Cursor
        MOV DH, 9
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; Display Bottom Line
        CALL DISPLAY_BOT
        RET
    DISPLAY_SECOND_PROMPT ENDP

    DISPLAY_OPERATOR_PROMPT PROC ; Paul
        ; Move Cursor
        MOV DH, 9
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Display Prompt
        MOV AH, 09h
        MOV DX, OFFSET operator_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Set Color to Blue
        MOV AH, 09h
        MOV BL, 00001011b                   ;Blue
        MOV CX, 18
        INT 10h

        ; Display Supporting Instruction
        MOV AH, 09h
        MOV DX, OFFSET sup_operator
        int 21h

        ; Display New Line
        CALL DISPLAY_NEWLINE

        ; Move Cursor
        MOV DH, 10
        MOV DL, 08h
        CALL MOVE_CURSOR
        
        ; Display Bottom Line
        CALL DISPLAY_BOT
        RET
    DISPLAY_OPERATOR_PROMPT ENDP
    
    DISPLAY_ANSWER_BOX PROC ; Paul
        ; Move Cursor
        MOV DH, 11
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; Display Top line
        CALL DISPLAY_TOP

        ; Move Cursor
        MOV DH, 12
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Display Prompt
        MOV AH, 09h
        MOV DX, OFFSET ans_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Display New line
        CALL DISPLAY_NEWLINE

        ; Move Cursor
        MOV DH, 13
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; Display Bottom line
        CALL DISPLAY_BOT
        RET
    DISPLAY_ANSWER_BOX ENDP
    
    DISPLAY_TRY_AGAIN_BOX PROC ; Paul
        ; Move Cursor
        MOV DH, 15
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; Display Top Line
        CALL DISPLAY_TOP
        
        ; Move Cursor
        MOV DH, 16
        MOV DL, 08h
        CALL MOVE_CURSOR
	  
        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Display Prompt
        MOV AH, 09h
        MOV DX, OFFSET end_prompt
        int 21h

        ; B3 - |
        MOV AH, 02h
        MOV DL, 0B3h
        INT 21h

        ; Set Color to Blue
        MOV AH, 09h
        MOV BL, 00001011b               ;Blue
        MOV CX, 29
        INT 10h

        ; Display Supporting Instruction
        MOV AH, 09
        MOV DX, OFFSET sup_try_again
        int 21h
        
        ; Display New Line
        CALL DISPLAY_NEWLINE
        
        ; Move Cursor
        MOV DH, 17
        MOV DL, 08h
        CALL MOVE_CURSOR

        ; Display Bottome Line
        CALL DISPLAY_BOT
        RET
    DISPLAY_TRY_AGAIN_BOX ENDP
    
    ; [ Prompts ]
    ASK_FIRST PROC ; Ambraie
        ; Reset the Register
        CALL RESET_REGISTER
    
        ; Reset The Flag
        MOV BX, OFFSET err_flag
        MOV AX, 00h
        MOV [BX], AX

        ; Ask for the value 
        AskFirstAgain:
            ; Move the Cursor to its normal position
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

            ; Configured SI for CHECK_VALUE
            MOV SI, OFFSET first_value_array
            CALL CHECK_VALUE
            
            ; Get err_flag
            MOV BX, OFFSET err_flag
            MOV AX, [BX]

            ; Check if there is an error
            CMP AL, 0101b
            JE FirstInputError
            JMP FirstInputContinue
            FirstInputError:                    ; An Error has occured
                ; Print the error
                CALL PRINT_ERROR
                
                ; Reset the flag
                MOV BX, OFFSET err_flag
                MOV AX, 00000000b
                MOV [BX], AL

                ; Configured SI for RESET_ARRAY_VALUE
                MOV SI, OFFSET first_value_array

                ; Reset the array
                CALL RESET_ARRAY_VALUE
                JMP AskFirstAgain
            FirstInputContinue:                 ; No error
                ; Reset the Registers
                CALL RESET_REGISTER
                
                ; Reset Error Flag
                MOV AX, 00000101b
                MOV BX, OFFSET err_flag
                MOV [BX], AL

                ; Clear the Error Text
                CALL CLEAR_OPERATOR
                RET
    ASK_FIRST ENDP
   
    ASK_SECOND PROC ; Ambraie
        ; Reset Register
        CALL RESET_REGISTER
        
        ; Ask for the value
        AskSecondAgain:
            ; Reset cursor to its normal position
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

            ; Configure SI for CHECK_VALUE
            MOV SI, OFFSET second_value_array
            CALL CHECK_VALUE
            
            ; Get err_flag
            MOV BX, OFFSET err_flag
            MOV AX, [BX]

            ; Check if there is an error
            CMP AL, 0111b
            JE SecondInputError
            JMP SecondInputContinue
            SecondInputError:                   ; An error has occured
                ; Print ther error
                CALL PRINT_ERROR

                ; Reset the flag
                MOV BX, OFFSET err_flag
                MOV AX, 00000000b
                MOV [BX], AX

                ; Configured SI for RESET_ARRAY_VALUE
                MOV SI, OFFSET second_value_array

                ; Reset the array
                CALL RESET_ARRAY_VALUE
                JMP AskSecondAgain
            SecondInputContinue:
                ; Reset Registers
                CALL RESET_REGISTER

                ; Reset Flag                
                MOV AX, 00000111b
                MOV BX, OFFSET err_flag
                MOV [BX], AX

                ; Clear the error text
                CALL CLEAR_OPERATOR
                RET
    ASK_SECOND ENDP
    
    ASK_OPERATOR PROC ; Ambraie

        ; Ask for Operator
        AskOperatorAgain:
            ; Reset cursor to its normal position
            MOV DH, 9
            MOV DL, 36
            CALL RESET_CURSOR_VALUE
            
            ; Ask for Input
            MOV AH, 01h
            INT 21h
            ; Push the value to the stack
            PUSH AX

            ; Check if it's a valid operator
            CMP AL, '+'
            JE OperatorContinue
            CMP AL, '-'
            JE OperatorContinue
            CMP AL, '*'
            JE OperatorContinue
            CMP AL, '/'
            JE OperatorContinue
            JMP OperatorInputError

            OperatorInputError:             ; If the input is not value
                ; Configure the error flag
                MOV AX, 00000011b
                MOV BX, OFFSET err_flag
                MOV [BX], AX
                
                ; Print the error
                CALL PRINT_ERROR

                ; Get AX back 
                POP AX
                JMP AskOperatorAgain
            OperatorContinue:               ; If there is no error
                ; Reset Register
                CALL RESET_REGISTER

                ; Get AX back
                POP AX
                
                ; Save the operator
                MOV AH, 00h
                MOV BX, OFFSET operator_value
                MOV [BX], AX
                
                ; Configure Error flag
                MOV AX, 00000011b
                MOV BX, OFFSET err_flag
                MOV [BX], AX

                ; Clear the Operator text
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

        ; Add the Value
        ADD AX, CX

        ; Save the value
        MOV BX, OFFSET answer_value
        MOV [BX], AX
        RET
    ADD_VALUE ENDP

    SUB_VALUE PROC  ; Aguirre
        ; Reset the Register
        CALL RESET_REGISTER

        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]

        ; Subtract the values
        SUB AX, CX

        ; Compare if it's a negative value (less than 0)
        CMP AX, 0
        JL NegativeValue
        PositiveValue:                      ; If positive
            ; Store the value to the 'answer_value'
            MOV BX, OFFSET answer_value
            MOV [BX], AX
            JMP SubtractionEnd
        NegativeValue:                      ; If negative
            MOV CX, 0FFFFh                  ; get the largest value possible for 2 bytes
            SUB CX, AX                      ; Subtract it to AX (to get the positive)
            INC CX                          ; The value is less than one everytime when we have negative value

            ; Save the value
            MOV BX, OFFSET answer_value   
            MOV [BX], CX

            ; Configured the flag to print '-' when displaying tha answer
            MOV BX, OFFSET value_flag
            MOV AX, 01h                     ; 01h indicates that it's a negative value
            MOV [BX], AX                   
        SubtractionEnd:
            RET
    SUB_VALUE ENDP

    MUL_VALUE PROC ; Aguirre
        ; Reset the register
        CALL RESET_REGISTER

        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]
        MOV BX, CX

        ; Multiply the value
        MUL BX

        ; Save the value
        MOV BX, OFFSET answer_value
        MOV [BX], AX
        RET
    MUL_VALUE ENDP

    DIV_VALUE PROC ; Aguirre
        ; Reset Registers
        CALL RESET_REGISTER
        
        ; Get the first number
        MOV BX, OFFSET first_value
        MOV AX, [BX]

        ; Get second number
        MOV BX, OFFSET second_value
        MOV CX, [BX]

        ; Reset DX (DX contains the remainder)
        MOV DX, 00h                     

        ; Compare if the value is zero or not
        CMP CX, 30h
        JBE InfiniteValue
        JMP NonInfinite
        InfiniteValue:                      ; If zero
            ; Configure the flag for infinite
            MOV BX, OFFSET value_flag
            MOV AX, 02h
            MOV [BX], AX
            JMP DivisionEnd
        NonInfinite:                        ; If none-zero
            ; Put the Multiplier in position
            MOV BX, CX         

            ; Divide Value
            DIV BX
            
            ; Save the answer and remainder
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

        ; Move the cursor
        MOV DH, 9
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Set Color to Red
        MOV AH, 09h
        MOV BL, 10001100b           ;Red (Blinking)
        MOV CX, 19
        INT 10h

        ; Print error string
        MOV AH, 09h;
        MOV DX, OFFSET err_input
        INT 21h

        ; Set color to blue
        MOV AH, 09h
        MOV BL, 00001011b           ;Blue
        MOV CX, 18
        INT 10h
        
        ; Print Suporting Instruction
        MOV DX, OFFSET sup_operator
        INT 21h
        RET
    PRINT_OPERATOR_ERROR ENDP

    PRINT_FIRST_NUMBER_ERROR PROC  ; Ryoji
        ; Move Cursor
        MOV DH, 7
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Set color to RED
        MOV AH, 09h
        MOV BL, 10001100b               ;Red (Blinking)
        MOV CX, 19
        INT 10h

        ; Print error string
        MOV AH, 09h
        MOV DX, OFFSET err_input
        INT 21h

        ; Set color to BLUE
        MOV AH, 09h
        MOV BL, 00001011b               ;Blue
        MOV CX, 10
        INT 10h

        ; Print supporting instruction
        MOV DX, OFFSET sup_number
        INT 21h
        RET
    PRINT_FIRST_NUMBER_ERROR ENDP

    PRINT_SECOND_NUMBER_ERROR PROC  ; Ryoji
        ; Move Cursor
        MOV DH, 8
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Set color to red
        MOV AH, 09h
        MOV BL, 10001100b               ;Red (Blinking)
        MOV CX, 19
        INT 10h
        
        ; Print error string
        MOV AH, 09h
        MOV DX, OFFSET err_input
        INT 21h

        ; Set Color to blue
        MOV AH, 09h
        MOV BL, 00001011b               ;Blue
        MOV CX, 10
        INT 10h

        ; Print Supporting instruction
        MOV DX, OFFSET sup_number
        INT 21h
        RET
    PRINT_SECOND_NUMBER_ERROR ENDP

    PRINT_TRY_AGAIN_ERROR PROC  ; Ryoji
        ; Move cursor
        MOV DH, 14
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Print Error input
        MOV AH, 09h
        MOV DX, OFFSET err_input
        INT 21h

        ; Print Supporting Instruction
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
        ; Move cursor
        MOV DH, 9
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Print Spaces
        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_OPERATOR_CLEAR ENDP

    PRINT_FIRST_NUMBER_CLEAR PROC  ; Hans
        ; Move cursor
        MOV DH, 7
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Print Spaces
        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_FIRST_NUMBER_CLEAR ENDP

    PRINT_SECOND_NUMBER_CLEAR PROC  ; Hans
        ; Move cursor
        MOV DH, 8
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Print Spaces
        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_SECOND_NUMBER_CLEAR ENDP

    PRINT_TRY_AGAIN_CLEAR PROC  ; Hans
        ; Move cursor
        MOV DH, 14
        MOV DL, 40
        CALL MOVE_CURSOR

        ; Print Spaces
        MOV AH, 09h
        MOV DX, OFFSET sup_clear_error
        INT 21h
        RET
    PRINT_TRY_AGAIN_CLEAR ENDP

    ; [ Printing ]
    ; - Assumes that the values are already calculated and was transformed into hex
    
    ; Display the answer
    DISPLAY_ANSWER PROC ; Aguirre
        ; Move Cursor
        MOV DH, 12
        MOV DL, 35
        CALL MOVE_CURSOR

        ; Get the flag
        MOV BX, OFFSET value_flag
        MOV DX,[BX]

        ; Comapre the flags
        CMP DL, 01h                         ; Check if the value is negative
        JE DisplayNegative
        CMP DL, 02h                         ; Check if the value is infinite
        JE DisplayInfinite
        JMP ContinueOperatorDisplay
        DisplayInfinite:                    ; If infinite (divided by zero)
            ; Print 'inf'
            MOV AH, 02h
            MOV DX, 'i'
            INT 21h
            MOV DX, 'n'
            INT 21h
            MOV DX, 'f'
            INT 21h
            ; Return to MAIN
            JMP EndDigit
        DisplayNegative:                    ; if negative
            ; print '-' then continue with displaying the numbers
            MOV AH, 02h
            MOV DX, '-'
            INT 21h
        ContinueOperatorDisplay:
            ; Print the individual digits
            CALL PRINT_ANSWER

            ; Get the remainder value
            MOV BX, OFFSET remainder_value
            MOV AX, [BX]

            ; Check if a remainder exists
            CMP AX, 00h
            JE EndDigit
            RemainderThings:                ; If there is a remainder
                ; Print 'r'
                MOV AH, 02h
                MOV DL, 'r'
                INT 21h

                ; Push '$'
                MOV AX, '$'                 ; Signifies the 'end' of the printing                     
                PUSH AX         

                ; Reset all registers
                CALL RESET_REGISTER

                ; Get the remainder value
                MOV BX, OFFSET remainder_value
                MOV AX, [BX]
                
                ; Set-up CX 
                MOV CX, 01h
                RemainderTransform:
                    MOV BX, 0Ah                     ; Set-up BX for division (0A -> 10d)
                    DIV BX                          ; Divide the answer (AX) to 10d (BX)
                    ADD DX, 30h                     ; Convert the Remainder to ASCII
                    PUSH DX                         ; push it to the stack
                    MOV DX,00h                      ; Reset DX
                    CMP AX, 00h                     ; Check if there is still a value in AX
                    JE StopRemainderTransform       ; If there is none, then stop transform
                    MOV CX, 02h                     ; Otherwise, loop infinitely
                    loop RemainderTransform
                StopRemainderTransform:
                    ; Set-up initial Registers     
                    MOV CX, 01h                     ; Temporary CX
                    MOV AH, 02h                     ; Software interuppt for printing
                    PrintRemainderLoop:
                        POP DX                      ; get the value from the stack and store it to DX
                        CMP DX, '$'                 ; IF the DX is '$'
                        JE EndDigit                 ; Then it's the last of the values
                        INT 21h                     ; Otherwise, print
                        MOV CX, 02h                 ; then proceed into looping
                        loop PrintRemainderLoop
                    EndDigit:
                        RET
    DISPLAY_ANSWER ENDP

    ; [ Auxiliary ]

    ; Assumes that DL and DH are already been configured
    ; Move the cursor to a designated location
    MOVE_CURSOR PROC ; Aguirre
        MOV AH, 02h
        MOV BH, 00h
        INT 10H
        RET
    MOVE_CURSOR ENDP

    ; Clear the Screen
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
    ; Ask for a string not a character
    ASK_INPUT PROC  ; Aguirre
        MOV AH, 0Ah
        INT 21h
        RET
    ASK_INPUT ENDP

    ; Store the answer_Value to DX
    GET_ANSWER PROC ; Aguirre
        MOV BX, OFFSET answer_value
        MOV DX, [BX]
        RET
    GET_ANSWER ENDP

    ; Display Top Line
    DISPLAY_TOP PROC ; Aguirre
        ; DA - ┌
        MOV AH, 02h
        MOV DL, 0DAh
        INT 21h
        
        ; C4 - ─
        mov CX, 30
        MOV DL, 0C4h
        TopDisplayCharacterLoop:            ; Print 30d times
            INT 21h
            loop TopDisplayCharacterLoop
        
        ; BF - ┐
        MOV DL, 0BFh
        INT 21h    

        ; Print New Line
        MOV AH, 09h
        MOV DX, OFFSET new_line
        INT 21h
        RET
    DISPLAY_TOP ENDP

    ; Display Bottom  line
    DISPLAY_BOT PROC ; Aguirre
        ; C0 - └
        MOV AH, 02h
        MOV DL, 0C0h
        INT 21h
        
        ; C4 - ─
        mov CX, 30
        MOV DL, 0C4h
        BotDisplayCharacterLoop:            ; Print 30d times
            INT 21h
            loop BotDisplayCharacterLoop
        
        ; D9 - ┘
        MOV DL, 0D9h
        INT 21h    

        ; Print new lines
        MOV AH, 09h
        MOV DX, OFFSET new_line
        INT 21h
        RET
    DISPLAY_BOT ENDP

    ; Print new line
    DISPLAY_NEWLINE PROC ; Aguirre
        MOV AH, 09h
        MOV DX, OFFSET new_line
        INT 21h
        RET
    DISPLAY_NEWLINE ENDP
    
    ; Assumes that DL and DH are already been configured
    ; Delete the printed value inside of the terminal in a cursor and move it back to it
    RESET_CURSOR_VALUE PROC ; Aguirre
        ; Move the cursor
        CALL MOVE_CURSOR

        ; Save DX
        PUSH DX

        ; Print ' '
        MOV AH, 02h
        MOV DL, ' '
        INT 21h

        ; Restore DX
        POP DX

        ; Move the cursor back to the position
        CALL MOVE_CURSOR
        RET
    RESET_CURSOR_VALUE ENDP

    ; Reset all relevant variables
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

    ; Reset all registers to zero
    RESET_REGISTER PROC ; Aguirre
        MOV AX, 00h
        MOV BX, 00h
        MOV CX, 00h
        MOV DX, 00h
        RET
    RESET_REGISTER ENDP

    ; Assumes that SI is configured
    RESET_ARRAY_VALUE PROC
        INC SI              ; Point to the size
        MOV CX, [SI]        ; Get the size
        MOV CH, 00h         ; Reset
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

    ; Assumes that err_check is configured before calling
    ; Assumes that SI is configured before calling
    ; Check the value of the array if everything contains only numbers
    CHECK_VALUE PROC ; Aguirre
        INC SI                          ; Point to the value_size: [array_size, value_size, ..., '$']
        MOV CX, [SI]                    ; Get the Size of the array
        MOV CH, 00h                     ; Reset
        INC SI                          ; Get the Value
        CheckingLoop:                   ; Loop through each values
            MOV AX, [SI]                ; Store the value of [SI]
            CMP AL, '0'                 ; compare it to '0'
            JB GeneralInputError        ; if it's below, then trigger an error 
            CMP AL, '9'                 ; compare it to '9'
            JA GeneralInputError        ; if it's above, then trigger an error
            INC SI                      ; Increment SI to point to the next element
            loop CheckingLoop           ; loop back
        JMP CheckingIsGood

        GeneralInputError:              ; If an error occured 
            ; get the checking value
            MOV BX, OFFSET err_check
            MOV AX, [BX]

            ; Check if we are checking the first input or the 2nd input
            CMP AL, 0001b
            JE FirstValueErr
            CMP AL, 0010b
            JE SecondValueErr

            ; If err_check didn't get configured
            ; then it will automatically trigger FirstValueErr
            ; Again, we assume that it's configured, if for some reason it's not, then CONFIGURE IT
            FirstValueErr:
                ; Configure error flag
                MOV BX, OFFSET err_flag 
                MOV AX, 00000101b
                MOV [BX], AL
                
                ; Return to the calling function
                JMP CheckingIsGood
            SecondValueErr:
                ; Configure error flag
                MOV BX, OFFSET err_flag
                MOV AX, 00000111b
                MOV [BX], AL

                ; Return to the calling function
                JMP CheckingIsGood
        CheckingIsGood:
            RET
    CHECK_VALUE ENDP





    ; Assumes SI and DI is configured to pointing to the size
    ; Auxillary function of COVERT_TO_HEX that implements the convertion to HEX and store it to DX
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

        RET
    CONVERT_TO_HEX ENDP

    ; Print the individual digits to the console
    PRINT_ANSWER PROC ; aguirre
        ; Will be use later for "PrintingLoop"
        MOV AX, '$'
        PUSH AX

        ; Reset the register
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