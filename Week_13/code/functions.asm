.ORIG x3000
LD R6, USER_STACK
ADD R5, R6, #-1
JSR main
HALT

add_2
; callee setup:
    ADD R6, R6, #-1           ; allocate spot for return value
    ADD R6, R6, #-1
    STR R7, R6, #0            ; push R7 (return address)
    ADD R6, R6, #-1
    STR R5, R6, #0            ; push R5 (caller frame pointer)
    ADD R5, R6, #-1           ; set frame pointer

; stack frame:
;   +4 a (param)
;   +5 b (param)
;   0 c (local)

; function body:
    ADD R6, R6, #-1           ; Allocate space for "c"
    LDR R0, R5, #4            ; load parameter "a"
    LDR R1, R5, #5            ; load parameter "b"
    ADD R0, R0, R1
    STR R0, R5, #0            ; Initialize "c"

    LDR R0, R5, #0            ; load local variable "c"
    STR R0, R5, #3            ; write return value, always R5 + 3
    BR add_2_teardown

add_2_teardown
    ADD R6, R5, #1            ; pop local variables
    LDR R5, R6, #0            ; pop frame pointer
    ADD R6, R6, #1
    LDR R7, R6, #0            ; pop return address
    ADD R6, R6, #1
    RET
; end function

sub_2
; callee setup:
    ADD R6, R6, #-1           ; allocate spot for return value
    ADD R6, R6, #-1
    STR R7, R6, #0            ; push R7 (return address)
    ADD R6, R6, #-1
    STR R5, R6, #0            ; push R5 (caller frame pointer)
    ADD R5, R6, #-1           ; set frame pointer

; stack frame:
;   +4 a (param)
;   +5 b (param)
;   0 c (local)

; function body:
    ADD R6, R6, #-1           ; Allocate space for "c"
    LDR R0, R5, #4            ; load parameter "a"
    LDR R1, R5, #5            ; load parameter "b"
    NOT R1, R1
    ADD R1, R1, #1
    ADD R0, R0, R1
    STR R0, R5, #0            ; Initialize "c"

    LDR R0, R5, #0            ; load local variable "c"
    STR R0, R5, #3            ; write return value, always R5 + 3
    BR sub_2_teardown

sub_2_teardown
    ADD R6, R5, #1            ; pop local variables
    LDR R5, R6, #0            ; pop frame pointer
    ADD R6, R6, #1
    LDR R7, R6, #0            ; pop return address
    ADD R6, R6, #1
    RET
; end function

main
; callee setup:
    ADD R6, R6, #-1           ; allocate spot for return value
    ADD R6, R6, #-1
    STR R7, R6, #0            ; push R7 (return address)
    ADD R6, R6, #-1
    STR R5, R6, #0            ; push R5 (caller frame pointer)
    ADD R5, R6, #-1           ; set frame pointer

; stack frame:
;   0 a (local)
;   -1 b (local)
;   -2 c (local)
;   -3 d (local)

; function body:
    ADD R6, R6, #-1           ; Allocate space for "a"
    LD R0, CONST_0            ; load constant 21
    STR R0, R5, #0            ; Initialize "a"

    ADD R6, R6, #-1           ; Allocate space for "b"
    LD R0, CONST_1            ; load constant 33
    STR R0, R5, #-1           ; Initialize "b"

    ADD R6, R6, #-1           ; Allocate space for "c"
    LDR R0, R5, #-1           ; load local variable "b"
    ADD R6, R6, #-1
    STR R0, R6, #0            ; push argument to stack

    LDR R0, R5, #0            ; load local variable "a"
    ADD R6, R6, #-1
    STR R0, R6, #0            ; push argument to stack

    JSR add_2
    LDR R0, R6, #0            ; load return value
    ADD R6, R6, #1            ; pop return value
    ADD R6, R6, #2            ; pop arguments
    STR R0, R5, #-2           ; Initialize "c"

    ADD R6, R6, #-1           ; Allocate space for "d"
    LDR R0, R5, #-1           ; load local variable "b"
    ADD R6, R6, #-1
    STR R0, R6, #0            ; push argument to stack

    LDR R0, R5, #0            ; load local variable "a"
    ADD R6, R6, #-1
    STR R0, R6, #0            ; push argument to stack

    JSR sub_2
    LDR R0, R6, #0            ; load return value
    ADD R6, R6, #1            ; pop return value
    ADD R6, R6, #2            ; pop arguments
    STR R0, R5, #-3           ; Initialize "d"

    BR main_teardown

main_teardown
    ADD R6, R5, #1            ; pop local variables
    LDR R5, R6, #0            ; pop frame pointer
    ADD R6, R6, #1
    LDR R7, R6, #0            ; pop return address
    ADD R6, R6, #1
    RET
; end function


; ---- Data Section ----
CONST_0                     .FILL x0015
CONST_1                     .FILL x0021

USER_STACK .FILL xFDFF
RETURN_SLOT .FILL xFDFF

.END
