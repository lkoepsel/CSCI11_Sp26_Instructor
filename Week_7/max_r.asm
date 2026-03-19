; Lab:         Unit 7 Lab — Recursive Maximum
; Module:      max_r
; Name:
; -----------------------
; Description: Find the MAXIMUM value in an integer list using recursion.
;              Start from sum_r.asm and adapt it.
;
; Strategy:
;   The base case returns the "identity" for the operation:
;     - sum_r uses  0      because any number + 0       = that number
;     - max_r needs current number as it needs to start with an element
;
;   The accumulation step uses comparison instead of addition.
;
; Note:        The list is terminated by sentinel xFFFF (-1).
;              The recursive structure (push/pop of R7 and R1) is
;              identical to sum_r.asm

; Registers:
; R0: address of current list element — argument to MAX_R
; R1: value of current list element (scratch within MAX_R)
; R2: scratch for sentinel test
; R3: scratch for max comparison
; R5: return value — max of list[current..end]
; R6: stack pointer, grows downward from x4000
; R7: return address — DO NOT use elsewhere

        .ORIG x3000

        LD R6, TOS          ; initialize stack pointer
        LEA R0, LIST        ; R0 = address of first list element
        JSR MAX_R           ; recursive max — result returned in R5
        ST R5, MAX          ; save result
        HALT

;End of Program

;Data Declarations-------------

;   list = [3, 1, 4, 1, 5]     expected result: MAX = 5
MAX     .BLKW #1            ; maximum of list
LIST    .FILL #5            ; list[0]
        .FILL #3            ; list[1]
        .FILL #3            ; list[2]
        .FILL #1            ; list[3]
        .FILL #-2            ; list[4]
        .FILL xFFFF         ; sentinel: end of list (xFFFF = -1)
TOS     .FILL x4000         ; one past the last valid stack entry

; -----------------------------------------------------------------
; MAX_R  Recursive maximum of an integer list
;
; Entry: R0 = address of current list element
; Exit:  R5 = maximum of list[current..end]
;
; Each non-base-case call pushes two words onto the stack:
;     [ R7 — return address  ]  <- R6 after saves
;     [ R1 — current element ]
; and pops them on return before comparing with R5.
; -----------------------------------------------------------------

MAX_R   LDR R1, R0, #0      ; load the current element *R0
        LDR R2, R0, #1      ; peek at next element
        ADD R2, R2, #1      ; xFFFF + 1 = 0 next is sentinel (-1)
        BRz BASE            ; sentinel found → base case

        ;--Recursive case (identical to sum_r.asm)
        ADD R6, R6, #-1
        STR R7, R6, #0      ; push return address
        ADD R6, R6, #-1
        STR R1, R6, #0      ; push current element

        ADD R0, R0, #1      ; advance pointer: equivalent to lst[1:]
        JSR MAX_R           ; recurse — R5 = max(lst[1:])

        ;--Unwind: restore state
        LDR R1, R6, #0      ; pop current element
        ADD R6, R6, #1
        LDR R7, R6, #0      ; pop return address
        ADD R6, R6, #1

        NOT R3, R5          ; R3 = ~R5
        ADD R3, R3, #1      ; R3 = -R5
        ADD R3, R1, R3      ; R3 = R1 - R5
        BRp KEEP_R1         ; if positive, R1 > R5
        BR  DONE            ; else R5 is already the max
KEEP_R1 ADD R5, R1, #0      ; R5 = R1
DONE    RET

BASE    ADD R5, R1, #0      ; if base case, start w last element
        RET

        .END
