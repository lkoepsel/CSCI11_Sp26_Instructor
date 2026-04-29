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
;   0 elements (local)
;   -5 max (local)
;   -6 i (local)
;   -7 RESULT (local)

; function body:
    ADD R6, R6, #-5           ; Allocate 5 slots for "elements"
    AND R0, R0, #0
    ADD R0, R0, #3
    STR R0, R5, #0            ; Initialize "elements"[0]
    AND R0, R0, #0
    ADD R0, R0, #7
    STR R0, R5, #-1           ; Initialize "elements"[1]
    AND R0, R0, #0
    ADD R0, R0, #2
    STR R0, R5, #-2           ; Initialize "elements"[2]
    AND R0, R0, #0
    ADD R0, R0, #9
    STR R0, R5, #-3           ; Initialize "elements"[3]
    AND R0, R0, #0
    ADD R0, R0, #4
    STR R0, R5, #-4           ; Initialize "elements"[4]

    ADD R6, R6, #-1           ; Allocate space for "max"
    ADD R0, R5, #0            ; address of "elements"[0]
    AND R1, R1, #0
    NOT R1, R1
    ADD R1, R1, #1
    ADD R0, R0, R1            ; address of "elements"[i]
    LDR R0, R0, #0            ; load "elements"[i]
    STR R0, R5, #-5           ; Initialize "max"

; for loop initiailization
    ADD R6, R6, #-1           ; Allocate space for "i"
    AND R0, R0, #0
    ADD R0, R0, #1
    STR R0, R5, #-6           ; Initialize "i"
main_for_0
; test condition
    AND R0, R0, #0
    ADD R0, R0, #4
    LDR R1, R5, #-6           ; load local variable "i"
    NOT R0, R0                ; two's complement of right operand
    ADD R0, R0, #1
    ADD R1, R1, R0            ; left - right; sets NZP
    BRp main_for_0_end        ; if false (>), skip
    LDR R0, R5, #-5           ; load local variable "max"
    ADD R1, R5, #0            ; address of "elements"[0]
    LDR R2, R5, #-6           ; load local variable "i"
    NOT R2, R2
    ADD R2, R2, #1
    ADD R1, R1, R2            ; address of "elements"[i]
    LDR R1, R1, #0            ; load "elements"[i]
    NOT R0, R0                ; two's complement of right operand
    ADD R0, R0, #1
    ADD R1, R1, R0            ; left - right; sets NZP
    BRnz main_if_0_end        ; if false (<=), skip

    ADD R0, R5, #0            ; address of "elements"[0]
    LDR R1, R5, #-6           ; load local variable "i"
    NOT R1, R1
    ADD R1, R1, #1
    ADD R0, R0, R1            ; address of "elements"[i]
    LDR R0, R0, #0            ; load "elements"[i]
    STR R0, R5, #-5           ; assign to variable "max"

main_if_0_end

; increment expression
    LDR R0, R5, #-6           ; load local variable "i" for increment
    ADD R1, R0, #0            ; save original value for postfix
    ADD R0, R0, #1
    STR R0, R5, #-6           ; store incremented value
    BR main_for_0             ; test loop condition again
main_for_0_end

    ADD R6, R6, #-1           ; Allocate space for "RESULT"
    LDR R0, R5, #-5           ; load local variable "max"
    STR R0, R5, #-7           ; Initialize "RESULT"

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
