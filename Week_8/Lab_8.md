# Lab 8: Manual RPN

## Overview

Implement a single-digit Reverse Polish Notation (*post-fix notation*) calculator by reading numbers and operators from the console. The calculator will accept a number 0-9 and put it on the RPN stack or an operator (+, -, *, /), which will calculate its operation using two numbers on the stack and push the result onto the stack. A fifth operator, ".", will copy the top of stack to a variable RESULT and terminate the program. Successful operation will be indicated by a correct result in RESULT.

## ASCII Values

| Character | Decimal | Hexadecimal |
|-----------|---------|-------------|
| 0         | 48      | 0x30        |
| 9         | 57      | 0x39        |
| +         | 43      | 0x2B        |
| -         | 45      | 0x2D        |
| *         | 42      | 0x2A        |
| /         | 47      | 0x2F        |
| .         | 46      | 0x2E        |

## Assignment

1. Use rpn.md as a guide to writing the code. The comments describe a working program.
2. Write the code to accomplish the algorithm and call the file *rpn.asm*.

## Test Values:

* 3 9 + 12
* 3 9 + 4 5 * + 32
* 3 9 + 4 5 * + 2 / 16
* 1 2 3 4 5 * * * * 120