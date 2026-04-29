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
;   0 number (local)
;   -1 abs (local)

; function body:
    ADD R6, R6, #-1           ; Allocate space for "number"
    AND R0, R0, #0
    ADD R0, R0, #7
    NOT R0, R0
    ADD R0, R0, #1
    STR R0, R5, #0            ; Initialize "number"

    ADD R6, R6, #-1           ; Allocate space for "abs"
    AND R0, R0, #0
    STR R0, R5, #-1           ; Initialize "abs"

    AND R0, R0, #0
    LDR R1, R5, #0            ; load local variable "number"
    NOT R0, R0                ; two's complement of right operand
    ADD R0, R0, #1
    ADD R1, R1, R0            ; left - right; sets NZP
    BRn main_if_0             ; if false (<), skip

    LDR R0, R5, #0            ; load local variable "number"
    STR R0, R5, #-1           ; assign to variable "abs"

    BR main_if_0_end
main_if_0

    LDR R0, R5, #0            ; load local variable "number"
    NOT R0, R0
    ADD R0, R0, #1
    STR R0, R5, #-1           ; assign to variable "abs"

main_if_0_end

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
