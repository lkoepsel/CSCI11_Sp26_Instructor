; Assignment:  Unit 7 Recursion Demo
; Module:      sum_r
; Name:
; -----------------------
; Description: Recursive sum of an integer list, using sentinel xFFFF to
;              mark the end of the list — the same pattern as .STRINGZ
;              uses x0000 to mark the end of a string.
;
;              Python equivalent (sum_r.py):
;                def sum_recursive(lst):
;                    if len(lst) == 1:
;                        return lst[0]
;                    return lst[0] + sum_recursive(lst[1:])
;
;              LC-3 base case: sentinel xFFFF found → return 0
;              (Equivalent: sum([]) = 0, so sum([n]) = n + 0 = n)
;
; Note:        The call stack saves R7 and the current element before
;              each recursive call, then restores them on the way back.
;              This is how recursion "remembers" where it left off.

; Registers:
; R0: address of current list element — the argument to SUM_R
; R1: value of current list element (scratch within SUM_R)
; R2: scratch for sentinel test
; R5: return value — sum of list[current..end]
; R6: stack pointer, grows downward from x4000
; R7: return address — DO NOT use elsewhere

        .ORIG x3000
        LD R6, TOS          ; R6 = x4000 (empty stack sentinel)
        LEA R0, LIST        ; R0 = address of first list element
        JSR SUM_R           ; recursive sum — result returned in R5
        ST R5, SUM          ; save sum in SUM
        HALT
;End of Program

;Data Declarations-------------
;   list = [1, 2, 3, 4]     expected result: SUM = 10
SUM     .BLKW #1            ; sum of list
LIST    .FILL #1            ; list[0]
        .FILL #2            ; list[1]
        .FILL #3            ; list[2]
        .FILL #4            ; list[3]
        .FILL xFFFF         ; sentinel: end of list (xFFFF = -1)
TOS     .FILL x4000         ; one past the last valid stack entry
; -----------------------------------------------------------------
; SUM_R  Recursive sum of an integer list
;
; Entry: R0 = address of current list element
; Exit:  R5 = sum of elements from *R0 through end of list
;
; Each non-base-case call pushes two words onto the stack:
;     [ R7 — return address  ]  <- R6 after saves
;     [ R1 — current element ]
; and pops them on return before adding to R5.
; -----------------------------------------------------------------

SUM_R   LDR R1, R0, #0      ; R1 = *R0, load current element
        ADD R2, R1, #1      ; xFFFF + 1 = 0 if sentinel (-1)
        BRz BASE            ; sentinel found → base case

        ;--Recursive case------------------------------------------
        ADD R6, R6, #-1
        STR R7, R6, #0      ; push return address
        ADD R6, R6, #-1
        STR R1, R6, #0      ; push current element

        ADD R0, R0, #1      ; advance pointer to next element
RECURSE JSR SUM_R           ; recursive call

        ;--Unwind: restore and accumulate sum----------------------
        LDR R1, R6, #0      ; pop current element
        ADD R6, R6, #1
        LDR R7, R6, #0      ; pop return address
        ADD R6, R6, #1

        ADD R5, R5, R1      ; R5 = lst[0] + sum(lst[1:])
        RET

        ;--Base case: sentinel found, return 0---------------------
BASE    AND R5, R5, #0      ; On base case, set R5 to 0
        RET                 ; and begin to sum on every return(rewind)

        .END
