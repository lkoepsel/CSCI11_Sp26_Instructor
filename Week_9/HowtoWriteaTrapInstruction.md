# How to Write a Trap Instruction

## Overview

You will need to have three sections of code:
* Trap vector with the address of the trap code (x00-x00ff)
* Trap code with a label for the TRAP (x0100-x1dff)
* Test code at user (x3000)

## Instructions

1. Write the trap code and test it. Once tested, place it in memory above the latest user trap. In this case x0300. Be sure to label it appropriately as in TRAP_label or TRAP_CHS for change sign.
1. Determine the trap number for the vector table. In this case, I used the next number up, or x0026. Use .fill to assign the label to the TRAP.
1. Write the test code in the user space

## Code Example

```lc3
; Trap x26 or TRAP_CHS
; Change the sign of the value in R0
; section one - trap vector
            .ORIG x0026
            .fill TRAP_CHS ; x0026
            .END
; section two - trap code
           .ORIG x300
TRAP_CHS    NOT R0, R0  
            ADD R0, R0, #1
            RTI        ; end program
            .END
; section three - test or example code
; When the example runs, the value in the R0 register will be
; a negative of the value for number i.e; 17 -> -17
            .ORIG x3000
            LD  R0, NUMBER
            TRAP x26
            HALT
NUMBER      .FILL   #17
            .END
```

## Simple methods of adding a TRAP mnemonic:
The trap mnemonics (PUTS, IN, GETC, HALT, etc.) are hardcoded in the lc3-ensemble parser as fixed enum variants. Adding a custom mnemonic like CHS for your TRAP x26 would require modifying and recompiling the lc3-ensemble Rust source, then  building lc3tools — not something practical this course.

What you can do instead:

Use a macro-style comment convention — document it clearly at the top of your file:
; CHS (Change Sign): TRAP x26  — negates R0

