# LC-3 Assembly Programming Cookbook

A collection of common programming patterns in LC-3 assembly. Each recipe states the problem, explains the approach, and provides working code.

---

## Recipe 1: Test if Two Values Are Equal

**Problem:** Branch to different code depending on whether value A equals value B.

**Approach:** LC-3 has no compare instruction. Negate B using 2's complement (`NOT` then `ADD #1`), then `ADD` it to A. If the result is zero, the Z condition code is set and `BRz` branches to the equal path.

```lc3
; equal_test
; Demonstrates:
; how to compare two values for equality
; how to branch based on the result

; Registers:
; R0 - holds value A
; R1 - holds value B (negated for subtraction)
; R2 - holds result of A - B

        .ORIG x3000
        LD  R0, A       ; load first value
        LD  R1, B       ; load second value
        NOT R1, R1      ; invert B (step 1 of 2's complement)
        ADD R1, R1, #1  ; complete 2's complement negation
        ADD R2, R0, R1  ; R2 = A + (-B) = A - B
        BRz EQUAL       ; if result is 0, A == B

        ; not-equal path
        LEA R0, NOT_EQ  ; load address of message
        PUTS            ; display message
        BR  DONE

EQUAL   LEA R0, EQ_MSG  ; load address of message
        PUTS            ; display message

DONE    HALT

; Data Section
A       .FILL #7        ; first value to compare
B       .FILL #7        ; second value (change to test not-equal)
EQ_MSG  .STRINGZ "Values are equal\n"
NOT_EQ  .STRINGZ "Values are not equal\n"
        .END
```

**Key points:**
- Subtraction in LC-3 is always done as `A + (-B)`.
- The condition codes N, Z, P are set by the `ADD` instruction automatically.
- `BRnp` ("branch if not zero") is the inverse of `BRz` and branches when the values are *not* equal.

<div class="page"/>

## Recipe 2: Count-Controlled Loop (Loop N Times)

**Problem:** Execute a block of code exactly N times.

**Approach:** Load the count N into a register. At the end of each iteration, decrement with `ADD R_count, R_count, #-1` and use `BRp` to loop while the counter remains positive.

```lc3
; count_loop
; Demonstrates:
; how to loop a fixed number of times
; how to accumulate a result inside a loop

; Registers:
; R1 - loop counter (counts down from N to 0)
; R2 - accumulator (sum of iterations)

        .ORIG x3000
        LD  R1, COUNT   ; load loop count
        AND R2, R2, #0  ; clear accumulator to 0

LOOP    ADD R2, R2, #1  ; body of loop: increment accumulator
        ADD R1, R1, #-1 ; decrement counter
        BRp LOOP        ; repeat while counter > 0

        ST  R2, RESULT  ; store final result
        HALT

; Data Section
COUNT   .FILL #5        ; number of iterations
RESULT  .BLKW 1         ; storage for result
        .END
```

**Key points:**
- `AND R2, R2, #0` is the idiomatic way to clear a register to zero.
- `BRp` continues only while the counter is strictly positive; it stops when the counter reaches 0.
- To loop at least once regardless of N, place the boundary check *after* the loop body.
- After this program runs, `RESULT` in memory will hold `5`.

<div class="page"/>

## Recipe 3: Display a Single Character (OUT)

**Problem:** Write one character to the console.

**Approach:** `OUT` (TRAP x21) reads the ASCII value from **R0** and prints it. Load or compute the ASCII value into R0 before calling `OUT`.

```lc3
; display_char
; Demonstrates:
; how to display a single character using OUT (TRAP x21)

; Registers:
; R0 - ASCII value of character to display (required by OUT)

        .ORIG x3000
        LD  R0, CHAR    ; load ASCII value into R0
        OUT             ; display character (TRAP x21)
        HALT

; Data Section
CHAR    .FILL x0041     ; ASCII x41 = 'A'
        .END
```

**Key points:**
- `OUT` is shorthand for `TRAP x21`. Both forms work identically.
- R0 must hold the ASCII value *before* calling `OUT`.
- Common ASCII values: `x0041`='A', `x0061`='a', `x0030`='0', `x000A`=newline (CR).
- To display a newline, load `x000A` into R0 and call `OUT`.

<div class="page"/>

## Recipe 4: Display a String (PUTS)

**Problem:** Write a string of characters to the console.

**Approach:** `PUTS` (TRAP x22) reads the **address** of a null-terminated string from **R0** and prints every character until it reaches the null terminator (`x0000`). Use `LEA` (not `LD`) to get the address.

```lc3
; display_string
; Demonstrates:
; how to display a string using PUTS (TRAP x22)
; how to use LEA to load the address of a label

; Registers:
; R0 - address of string to display (required by PUTS)

        .ORIG x3000
        LEA R0, MSG     ; load address of MSG into R0
        PUTS            ; display string (TRAP x22)
        HALT

; Data Section
MSG     .STRINGZ "Hello, LC-3!"  ; .STRINGZ adds a null terminator automatically
        .END
```

**Key points:**
- `LEA` loads the *address* of a label. `LD` loads the *contents* at a label. For `PUTS`, always use `LEA`.
- `.STRINGZ` automatically appends a null terminator (`x0000`) after the string.
- To print multiple strings in sequence, `LEA R0` to each label and call `PUTS` each time.

<div class="page"/>

## Recipe 5: Read a Character from the Keyboard (GETC)

**Problem:** Wait for the user to press a key and capture that character.

**Approach:** `GETC` (TRAP x23) waits for one keypress and places its ASCII value into **R0**. It does *not* echo the character automatically. Call `OUT` immediately after if you want the user to see what they typed.

```lc3
; read_char
; Demonstrates:
; how to read one character from the keyboard using GETC (TRAP x23)
; how to echo the character back using OUT (TRAP x21)

; Registers:
; R0 - receives ASCII value of key pressed (set by GETC)

        .ORIG x3000
        LEA R0, PROMPT  ; load address of prompt
        PUTS            ; display prompt to user
        GETC            ; wait for keypress; result placed in R0
        OUT             ; echo the character back to console
        HALT

; Data Section
PROMPT  .STRINGZ "Press any key: "
        .END
```

**Key points:**
- `GETC` is shorthand for `TRAP x23`. After it executes, R0 holds the ASCII value of the key pressed.
- `GETC` does **not** echo — the user sees nothing until you call `OUT`.
- To read a digit and convert it to an integer, subtract the ASCII value of `'0'` (x0030): `ADD R1, R0, NEG_ASCII_0`.
- To validate that input is a digit, check `x0030 <= R0 <= x0039` using two comparisons (see `Lectures/Unit 9/code/in.asm` for a complete example).

<div class="page"/>

## Recipe 6: Convert an ASCII Digit to Decimal

**Problem:** A character read from the keyboard (e.g., `'7'`) arrives as its ASCII value (x0037). Convert it to the integer `7`.

**Approach:** ASCII digits `'0'`–`'9'` are stored as x0030–x0039. Subtracting x0030 from the ASCII value yields the decimal integer. Subtraction in LC-3 is done by adding the 2's complement: load the pre-computed value `#-48` (which is `-x0030`) and add it to the character.

```lc3
; ascii_to_dec
; Demonstrates:
; how to convert an ASCII digit character to its decimal integer value

; Registers:
; R0 - ASCII character value from GETC
; R1 - decimal integer result

        .ORIG   x3000
        LEA     R0, PROMPT  ; load address of prompt
        PUTS            ; display prompt
        GETC            ; read ASCII digit into R0
        OUT             ; echo the character

        LD      R1, ASCII_0 ; ASCII '0'
        NOT     R1, R1
        ADD     R1, R1, #1  ; -ASCII_0
        ADD R1, R0, R1  ; R1 = ASCII_char - "0" = decimal value
        ST  R1, RESULT  ; store decimal result
        HALT

; Data Section
PROMPT  .STRINGZ "Enter a digit (0-9): "
ASCII_0 .FILL x30       ; ASCII '0'
RESULT  .BLKW 1         ; stores the decimal result
        .END
```

**Key points:**
- `#-48` is the decimal form of `-x0030`. The assembler accepts either `#-48` or `xFFD0`; `#-48` is more readable.
- This only works correctly for digit characters `'0'`–`'9'`. Input outside that range produces an incorrect result.
- To validate before converting, check that `R0 >= x0030` and `R0 <= x0039`
- After this runs, `RESULT` in memory holds the integer `0`–`9`.

<div class="page"/>

## Recipe 7: Convert a Decimal Digit to ASCII

**Problem:** You have an integer `0`–`9` in a register and need to display it as a character.

**Approach:** Adding x0030 to a decimal digit produces the corresponding ASCII character. Load the digit, add x0030, then call `OUT`.

```lc3
; dec_to_ascii
; Demonstrates:
; how to convert a single decimal digit (0-9) to its ASCII character
; how to display the result with OUT

; Registers:
; R0 - ASCII character result, loaded into R0 for OUT
; R1 - decimal digit value (input)

        .ORIG x3000
        LD  R1, DIGIT   ; load decimal digit (must be 0-9)
        LD  R0, ASCII_0 ; load x0030 (ASCII '0')
        ADD R0, R1, R0  ; R0 = digit + x0030 = ASCII character
        OUT             ; display the character (TRAP x21)
        HALT

; Data Section
DIGIT   .FILL #7        ; decimal digit to convert (change to test)
ASCII_0 .FILL x0030     ; ASCII value of '0'
        .END
```

**Key points:**
- `ADD R0, R1, R0` adds the digit to x0030 in a single instruction. The result in R0 is ready for `OUT`.
- Only valid for decimal digits `0`–`9`. Adding x0030 to `7` gives x0037, which is `'7'`.
- Recipes 6 and 7 are inverses: ASCII → decimal subtracts x0030; decimal → ASCII adds x0030.
- To display a multi-digit number, extract each digit separately (using division or repeated subtraction) and convert each one.

<div class="page"/>

## Recipe 8: Declare an Array with `.BLKW` and Fill It from a String

**Problem:** Reserve a block of memory with `.BLKW`, then copy a null-terminated string into it character by character.

**Approach:** Use `LEA` to get a pointer to the source string and a pointer to the destination array. Loop with `LDR` and `STR` using the register pointers. The null terminator (`x0000`) both gets copied and signals the end of the loop — check the condition codes set by `LDR` before advancing the pointers.

```lc3
; fill_array
; Demonstrates:
; how to declare an array with .BLKW
; how to copy a null-terminated string into the array using a loop
; how to use LDR and STR with register-based addressing

; Registers:
; R0 - current character being copied
; R1 - source pointer (walks through SRC)
; R2 - destination pointer (walks through DEST)

        .ORIG x3000
        LEA R1, SRC     ; R1 points to start of source string
        LEA R2, DEST    ; R2 points to start of destination array

COPY    LDR R0, R1, #0  ; load character from source; sets CC
        STR R0, R2, #0  ; store character to destination (CC unchanged)
        BRz DONE        ; if null terminator was copied, stop
        ADD R1, R1, #1  ; advance source pointer
        ADD R2, R2, #1  ; advance destination pointer
        BR  COPY        ; next character

DONE    HALT

; Data Section
SRC     .STRINGZ "Hello" ; source string (5 chars + 1 null = 6 locations)
DEST    .BLKW 6          ; destination array (sized to hold SRC + null)
        .END
```

**Key points:**
- `LDR R0, R1, #0` loads from the address in R1 and sets condition codes. `STR` stores to memory and does **not** change condition codes, so `BRz` after `STR` still reflects the character just loaded.
- The null terminator is copied into `DEST` before the loop exits, so `DEST` is a proper null-terminated string.
- Size `DEST` to at least `len(string) + 1` to include the null terminator. `"Hello"` needs `.BLKW 6`.
- After this program runs, `DEST` in memory contains `H`, `e`, `l`, `l`, `o`, `x0000`.
- To walk `DEST` later (e.g., to print it), `LEA R0, DEST` then call `PUTS`.

<div class="page"/>

## Quick Reference: Common TRAP Calls

| Mnemonic | TRAP | R0 before call | Effect |
|----------|------|----------------|--------|
| `GETC`   | x23  | —              | R0 ← ASCII of key pressed (no echo) |
| `OUT`    | x21  | ASCII value    | Print character in R0 |
| `PUTS`   | x22  | Address of string | Print null-terminated string |
| `IN`     | x24  | —              | Print prompt, R0 ← ASCII of key (with echo) |
| `HALT`   | x25  | —              | Stop the program |

## Quick Reference: Condition Code Branches

| Branch | Condition Codes | When to Use |
|--------|----------------|-------------|
| `BRz`  | Z=1            | Result was zero / values were equal |
| `BRn`  | N=1            | Result was negative |
| `BRp`  | P=1            | Result was positive |
| `BRnz` | N=1 or Z=1     | Result was zero or negative (≤ 0) |
| `BRzp` | Z=1 or P=1     | Result was zero or positive (≥ 0) |
| `BRnp` | N=1 or P=1     | Result was not zero (≠) |
| `BRnzp`| always         | Unconditional branch (same as `BR`) |
