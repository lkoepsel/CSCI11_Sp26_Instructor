# Test 2 — Answer Key

---

## Multiple Choice Answers

1. C — The address of the instruction immediately after JSR. JSR stores PC+1 (the instruction the caller will return to) in R7.
2. C — LDR. LDR uses `BaseR + offset6` addressing. LD uses PC-relative, LDI uses PC-relative indirect, LEA loads an address.
3. C — An unconditional `BR` targeting the first real instruction. Without it, the CPU fetches and executes the data words at x3000 as instructions.
4. C — User mode. PSR bit 15 = 1 means user mode. PSR bit 15 = 0 means supervisor mode.
5. D — x0000. A null-terminated string ends with a word containing x0000 (not space, not xFFFF).
6. C — It pops both PC and PSR from the supervisor stack, restoring privilege, priority, and condition codes. RET (JMP R7) only changes PC.
7. B — Save R7 on the stack or in memory. JSR overwrites R7; the outer subroutine must preserve the original return address.
8. C — x0000–x00FF. This range is the trap vector table. The interrupt vector table is x0100–x01FF.
9. B — Address x5000. `STI R0, PTR` stores R0 at the address held in PTR. PTR contains x5000, so R0 is stored at x5000.
10. B — PC-relative. `LD R0, LABEL` computes the address as PC + sign-extended offset9.

---

## Assembly Language Answers

### Problem 1 — Read character, print "Digit" or "Other"

**Pseudo-code:**
```
R0 ← GETC
if R0 >= '0' AND R0 <= '9':
    PUTS "Digit"
else:
    PUTS "Other"
HALT
```

Since `imm5` is limited to −16..+15, subtract x30 (48) and x3A (58) using the negate-then-add pattern.

**LC-3 Solution:**
```lc3
            .ORIG x3000
            GETC                ; R0 = ASCII of key pressed

            ; Check R0 >= x30 ('0')
            LD   R1, ZERO_CHR   ; R1 = x30
            NOT  R1, R1
            ADD  R1, R1, #1     ; R1 = -x30
            ADD  R2, R0, R1     ; R2 = R0 - x30
            BRn  OTHER          ; if negative, below '0' → not digit

            ; Check R0 < x3A (one past '9')
            LD   R1, TEN_CHR    ; R1 = x3A
            NOT  R1, R1
            ADD  R1, R1, #1     ; R1 = -x3A
            ADD  R2, R0, R1     ; R2 = R0 - x3A
            BRzp OTHER          ; if >= 0, at '9'+1 or above → not digit

            LEA  R0, DIGIT_STR
            PUTS
            BR   DONE
OTHER       LEA  R0, OTHER_STR
            PUTS
DONE        HALT
ZERO_CHR    .FILL x0030         ; ASCII '0'
TEN_CHR     .FILL x003A         ; ASCII '9' + 1
DIGIT_STR   .STRINGZ "Digit"
OTHER_STR   .STRINGZ "Other"
            .END
```

---

### Problem 2 — Multiply by repeated addition

**Pseudo-code:**
```
product ← 0
counter ← FACTOR_B   ; 7
while counter > 0:
    product ← product + FACTOR_A
    counter ← counter - 1
PRODUCT ← product    ; expected: 42
```

**LC-3 Solution:**
```lc3
            .ORIG x3000
            AND  R0, R0, #0     ; R0 = product = 0
            LD   R1, FACTOR_A   ; R1 = 6 (value to add each iteration)
            LD   R2, FACTOR_B   ; R2 = 7 (loop counter)
LOOP        ADD  R0, R0, R1     ; product += FACTOR_A
            ADD  R2, R2, #-1    ; decrement counter
            BRp  LOOP           ; loop while counter > 0
            ST   R0, PRODUCT
            HALT
FACTOR_A    .FILL #6
FACTOR_B    .FILL #7
PRODUCT     .BLKW 1
            .END
```

**Expected result:** `PRODUCT = 42`

---

### Problem 3 — Subroutine STRLEN

**Pseudo-code:**
```
STRLEN(R0 = string address):
    save R1, R2
    R1 ← R0            ; pointer
    R2 ← 0             ; length counter
    loop:
        R0 ← M[R1]
        if R0 == 0: break
        R2 ← R2 + 1
        R1 ← R1 + 1
    R0 ← R2             ; return length
    restore R2, R1
    RET
```

**LC-3 Solution:**
```lc3
; --- Test program ---
            .ORIG x3000
            LD   R6, STK_INIT
            LEA  R0, TESTSTR    ; R0 = address of "Hello"
            JSR  STRLEN
            ST   R0, LENGTH
            HALT
STK_INIT    .FILL x4000
LENGTH      .BLKW 1
TESTSTR     .STRINGZ "Hello"

; --- Subroutine STRLEN ---
; Input:  R0 = address of null-terminated string
; Output: R0 = length (chars before null)
; Saves:  R1, R2
STRLEN      ADD  R6, R6, #-1
            STR  R1, R6, #0     ; push R1
            ADD  R6, R6, #-1
            STR  R2, R6, #0     ; push R2
            ADD  R1, R0, #0     ; R1 = string pointer
            AND  R2, R2, #0     ; R2 = length = 0
SL_LOOP     LDR  R0, R1, #0     ; R0 = current character
            BRz  SL_DONE        ; null terminator?
            ADD  R2, R2, #1     ; length++
            ADD  R1, R1, #1     ; advance pointer
            BR   SL_LOOP
SL_DONE     ADD  R0, R2, #0     ; R0 = length (return value)
            LDR  R2, R6, #0
            ADD  R6, R6, #1     ; pop R2
            LDR  R1, R6, #0
            ADD  R6, R6, #1     ; pop R1
            RET
            .END
```

**Expected result:** `LENGTH = 5`

---

### Problem 4 — Trap NON_PRINT at vector x0027

**LC-3 Solution:**
```lc3
; User-defined trap at vector `x0027` 
; Converts the value in R0 from a non-printable character to an ASCII "*" x2A
; Assume non-printable characters have an ASCII value of x00 - x0F. 
; If Line Feed x0A or Carriage Return x0D, then keep that value. 
; If the ASCII value is greater than x0F, then keep the value, unchanged.

; Section 1 — Trap vector table entry
            .ORIG x0026
            .FILL NON_PRT
            .END

; Section 2 — Handler code (supervisor space)
            .ORIG x0300
; save registers
NON_PRT
            ADD R6, R6, #-1
            STR R1, R6, #0
            ADD R6, R6, #-1
            STR R2, R6, #0
; is it a LF, exit
            LD   R1, LF
            ADD  R2, R0, R1
            BRz  EXIT
; is it a CR, exit
            LD   R1, CR
            ADD  R2, R0, R1
            BRz  EXIT
; is it > x0F, exit
            LD   R1, NP
            ADD  R2, R0, R1
            BRzp EXIT
; < x0f and not LF or CR, load "*"
            LD   R0, STAR            

; restore registers and exit
EXIT        LDR R2, R6, #0
            ADD R6, R6, #1
            LDR R1, R6, #0
            ADD R6, R6, #1
            RTI
LF          .FILL   x-0A
CR          .FILL   x-0D
NP          .FILL   x-0F
STAR        .FILL   x2A
            .END

; Section 3 — Test program
            .ORIG x3000
            LD   R0, TEST_C    
            TRAP x26
            ST   R0, RESULT
            HALT
TEST_C      .FILL x02 
RESULT      .BLKW 1
            .END
```

**Expected result:** `RESULT = x42` ('B'). x62 − x20 = x42.

---

## Debugging Answers

### D1 — Missing HALT before string data

**Bug:** There is no `HALT` instruction between `PUTS` and `GREETING`. After `PUTS` returns, the program counter points to `GREETING` (the `.STRINGZ` data). The CPU starts fetching and executing the string's ASCII values as instructions. Because all printable ASCII bytes have opcode bits 0000 (BR), the processor executes a series of branch instructions, eventually wandering into undefined memory or producing incorrect behavior. Execution never reaches a clean stop.

**Fix:** Add `HALT` (or `TRAP x25`) immediately before the label `GREETING`:
```lc3
            PUTS
            HALT
GREETING    .STRINGZ "Welcome!"
```

---

### D2 — JSR inside GREET overwrites R7 (infinite loop)

**Bug:** When `GREET` calls `JSR NEWLINE`, R7 is overwritten with the address of GREET's `RET` instruction. The original return address (placed in R7 by the caller's `JSR GREET`) is destroyed. NEWLINE's `RET` returns to GREET's `RET`. GREET's `RET` then jumps back to itself — an infinite loop. GREET never returns to the original caller.

**Fix:** Save R7 on the stack at the start of GREET and restore it before `RET`:
```lc3
GREET       ADD  R6, R6, #-1
            STR  R7, R6, #0     ; save return address before JSR NEWLINE
            LEA  R0, HI_MSG
            PUTS
            JSR  NEWLINE
            LDR  R7, R6, #0
            ADD  R6, R6, #1     ; restore return address
            RET
```

---

### D3 — HALT inside trap handler instead of RTI

**Bug:** `HALT` is `TRAP x25`. When executed inside a trap handler (which is already in supervisor mode), it invokes the HALT service routine, which prints a halt message and terminates simulation. The user program never gets control back. A trap handler must end with `RTI` to pop the saved PC and PSR from the supervisor stack and return to the interrupted code.

**Fix:** Replace `HALT` with `RTI`:
```lc3
CLEAR_TRAP  AND  R0, R0, #0
            RTI
```

---

### D4 — BRn never taken; loop runs once

**Bug:** `BRn LOOP` branches when the counter (R1) is **negative**. R1 starts at 8 and decrements toward 0. After the first iteration, R1 = 7, CC = P (positive). BRn is not taken — the loop exits immediately with only the first element (10) accumulated. R1 goes from 8 to 7 and never becomes negative during normal counting.

**Fix:** Change `BRn LOOP` to `BRp LOOP`. BRp continues the loop while R1 > 0, running all 8 iterations before stopping when R1 reaches 0 (CC = Z).
