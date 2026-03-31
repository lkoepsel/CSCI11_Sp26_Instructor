; stack_prod:

; Production level code which does not do stack error checking
; the most simple stack code with direct manipulation of R6

; Demonstrates:
; Uses stack to swap values in two memory locations

; Registers:
; R0: Returns pop value, receives push value
; R3: Addresses of values

; Memory:
; A: xAAAA: Value to be pushed onto stack
; B: xBBBB: Value to be pushed onto stack

                .ORIG x3000
                BR      START
                ; User program data
A               .FILL xAAAA     ; Value to be pushed onto stack
B               .FILL xBBBB     ; Value to be popped from stack

START
                LD R6, USER_STACK     ; Initialize stack, REQUIRED

                ; Set up values to be swapped and push onto stack
                LD R0, A        ; Load a value to be pushed onto stack
                ADD R6, R6, #-1 ; Push: Decrement
                STR R0, R6, #0  ; and Store

                LD R0,B         ; Load second value to be pushed onto stack
                ADD R6, R6, #-1 ; Push: Decrement
                STR R0, R6, #0  ; and Store

                ; Pop values and swap locations
                LEA R3, A       ; Load address of A
                LDR R0, R6, #0  ; Pop: Load
                ADD R6, R6, #1  ; and Increment
                STR R0, R3, #0  ; Store B in A

                LEA R3, B       ; Load address of B
                LDR R0, R6, #0  ; Pop: Load
                ADD R6, R6, #1  ; and Increment
                STR R0, R3, #0  ; Store B in A

                ; normal termination
NORM            LEA R0, NORMAL
                PUTS       
EXIT            HALT


                ; stack data
USER_STACK      .FILL x4000     ; Top of stack
NORMAL          .STRINGZ "Normal Termination"
; ************** END OF STACK LIBRARY CODE **************************************                

                .END
