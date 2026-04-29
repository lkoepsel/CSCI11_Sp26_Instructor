.ORIG x3000
LD R6, USER_STACK
ADD R5, R6, #-1
JSR main
HALT

main
; callee setup:
    ADD R6, R6, #-1           ; allocate spot for return value
    ADD R6, R6, #-1
    STR R7, R6, #0            ; push R7 (return address)
    ADD R6, R6, #-1
    STR R5, R6, #0            ; push R5 (caller frame pointer)
    ADD R5, R6, #-1           ; set frame pointer

; stack frame:
;   0 N (local)
;   -1 SUM (local)
;   -2 i (local)

; function body:
    ADD R6, R6, #-1           ; Allocate space for "N"
    AND R0, R0, #0
    ADD R0, R0, #5
    STR R0, R5, #0            ; Initialize "N"

    ADD R6, R6, #-1           ; Allocate space for "SUM"
    AND R0, R0, #0
    STR R0, R5, #-1           ; Initialize "SUM"

; for loop initiailization
    ADD R6, R6, #-1           ; Allocate space for "i"
    AND R0, R0, #0
    ADD R0, R0, #1
    STR R0, R5, #-2           ; Initialize "i"
main_for_0
; test condition
    LDR R0, R5, #0            ; load local variable "N"
    LDR R1, R5, #-2           ; load local variable "i"
    NOT R0, R0                ; two's complement of right operand
    ADD R0, R0, #1
    ADD R1, R1, R0            ; left - right; sets NZP
    BRp main_for_0_end        ; if false (>), skip
    LDR R0, R5, #-1           ; load local variable "SUM"
    LDR R1, R5, #-2           ; load local variable "i"
    ADD R0, R0, R1
    STR R0, R5, #-1           ; assign to variable "SUM"

; increment expression
    LDR R0, R5, #-2           ; load local variable "i" for increment
    ADD R1, R0, #0            ; save original value for postfix
    ADD R0, R0, #1
    STR R0, R5, #-2           ; store incremented value
    BR main_for_0             ; test loop condition again
main_for_0_end

main_teardown
    ADD R6, R5, #1            ; pop local variables
    LDR R5, R6, #0            ; pop frame pointer
    ADD R6, R6, #1
    LDR R7, R6, #0            ; pop return address
    ADD R6, R6, #1
    RET
; end function


; ---- Data Section ----

USER_STACK .FILL xFDFF
RETURN_SLOT .FILL xFDFF

.END
