; stack_example:

; Example of implementing both DEBUG and PROD code
; Illustrates how to use the debug code during dev
; then replace with production code, once working

; Demonstrates:
; Using stack_lib for stack functionality
; Uses stack to swap values in two memory locations
; Uses subroutines:  STK_INIT, PUSH and POP

; Usage:
; Set up two values then swap them using stack

; Registers:
; R0: Returns pop value, receives push value
; R1: temp register, saved and restored
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
                JSR STK_INIT    ; DEBUG: Initialize stack, REQUIRED
                ; LD R6, USER_STACK ; PROD: Initialize stack, REQUIRED

                ; Set up values to be swapped and push onto stack
                LD R0,A         ; Load a value to be pushed onto stack
                JSR PUSH        ; DEBUG: Push a value onto the stack
                ; ADD R6, R6, #-1 ; PROD: Push: Decrement
                ; STR R0, R6, #0  ; PROD: and Store
                
                LD R0,B         ; Load second value to be pushed onto stack
                JSR PUSH        ; DEBUG: Push a value onto the stack
                ; ADD R6, R6, #-1 ; PROD: Push: Decrement
                ; STR R0, R6, #0  ; PROD: and Store

                ; Uncomment block to show overflow error
                ; Code attempts to push 5 values onto stack
                ; JSR PUSH      ; Extra push onto stack (SAFE)
                ; JSR PUSH      ; Extra push onto stack (SAFE)
                ; JSR PUSH      ; Extra push onto stack (OVERFLOW)

                ; Uncomment block to show underflow error
                ; Code attempts an extra pop from stack
                ; JSR POP       ; Extra pop from stack (UNDERFLOW)

                ; Pop values and swap locations
                LEA R3, A       ; Load address of A
                JSR POP         ; DEBUG: Pop B from stack
                ; LDR R0, R6, #0  ; PROD: Pop: Load
                ; ADD R6, R6, #1  ; PROD: and Increment
                STR R0, R3, #0  ; Store B in A

                LEA R3, B       ; Load address of B
                JSR POP         ; DEBUG: Pop A from stack
                ; LDR R0, R6, #0  ; PROD: Pop: Load
                ; ADD R6, R6, #1  ; PROD: and Increment
                STR R0, R3, #0  ; Store A in B

                ; normal termination
NORM            LEA R0, NORMAL
                PUTS       
EXIT            HALT

; stack_lib:
; ************** STACK LIBRARY CODE **************************************                
; Library file, use for stack push and pop
; Requires additional code, stack functionality only

; Usage:
;   1. JSR STK_INIT - setup stack, must be performed
;   2. JSR PUSH - R0 will be pushed onto stack
;   3. JSR POP - R0 will return w/ top of stack

; Registers:
; R0: Returns pop value, receives push value
; R1: temp register, saved and restored
; R6: Stack pointer

; Memory:
; USER_STACK - top of stack (TOS)
; STACK_SIZE - number of locations in stack
; EMPTY: (- USER_STACK) => stack empty 
; FULL: -( USER_STACK + STACK_SIZE) => stack full
; SAVE_R1: x0000: Save register R1

STK_INIT        ; Stack initialization, call prior to using stack
                ; R1 is temp register, save it
                ; Initialize stack pointer (TOS)
                ; Change sign of stack pointer and save as EMPTY 
                ST R1, SAVE_R1          
                LD R6,USER_STACK        ; setup stack pointer (TOS)
                LD R1, USER_STACK  
                NOT R1,R1 
                ADD R1,R1,#1
                ST R1, EMPTY            ; save -TOS as EMPTY
                
                ; get size of stack (number of entries)
                ; calculate last stack memory location
                ; change sign and save as FULL
                LD R1, STACK_SIZE
                NOT R1,R1       ; 
                ADD R1,R1,#1    ; 
                ADD R1, R6, R1  ; last stack location
                NOT R1, R1      ; change sign and save
                ADD R1, R1, #1  ; 
                ST R1, FULL     ; change -last stack location as FULL
                RET

PUSH            ; put R0 on top of stack
                ; R1 is temp register, save it
                ; R4 contains condition code, non-zero is error
                ST R1,SAVE_R1   ; save R1, use as temp reg
                LD R1, FULL     ; check for full stack
                ADD R1,R6,R1    ; 
                BRz FAIL_PUSH   ; Branch if stack is full

                ADD R6,R6,#-1   ; Decrement
                STR R0,R6, #0   ; and store (push)
                BRnzp SUCCESS

POP             ; POP - return top of stack in R0
                ; R1 is temp register, save it
                ; R4 contains condition code, non-zero is error
                ST R1,SAVE_R1   
                LD R1,EMPTY     
                ADD R1,R6,R1     
                BRz FAIL_POP    

                LDR R0,R6, #0   ; Load
                ADD R6,R6, #1   ; and increment (POP)
SUCCESS         LD R1,SAVE_R1   ; Restore original
                AND R4,R4,#0    ; R4 <-- success
                RET

FAIL_PUSH       ; print error message and exit
                LEA R0, ERR_STACK_FULL
                PUTS
                BR ERR_TERM

FAIL_POP        ; print error message and exit
                LEA R0, ERR_STACK_EMPTY
                PUTS
                BR EXIT

ERR_TERM        HALT
                ; stack data
USER_STACK      .FILL x4000     ; Top of stack
STACK_SIZE      .FILL x04       ; number of entries in stack, used to calc FULL
FULL            .FILL x0000     ; calculated, negative of last legal entry
EMPTY           .FILL x0000     ; calculated, negative top of stack
SAVE_R1         .FILL x0000     ; Used to save and restore R1
ERR_STACK_FULL  .STRINGZ "ERROR: Stack full"
ERR_STACK_EMPTY .STRINGZ "ERROR: Stack empty"
NORMAL          .STRINGZ "Normal Termination"
; ************** END OF STACK LIBRARY CODE **************************************                

                .END
