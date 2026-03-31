; rpn:
; Demonstrates:
; A single digit RPN calculator

; Usage:
; Enter a number 0-9, or an operator +, -, *, or /
; Calculator will use Reverse Polish Notation to calculate
; If there is only one number on stack, operation will fail
; and program will terminate
; "." will copy the top of the RPN stack into result and terminate
; If stack is empty, operation will fail and program will terminate

; ## Algorithm

; 1. Initialize RPN stack and test values 0, 9, +, -, *, /, and . 
; 2. Print title and instructions
; 3. Read character from keyboard
; 4. If operator, load operator vector, check stack for two numbers 
; 5.    If so, execute operator vector and push result on stack, if not, error
; 6. If number, push number onto stack
; 7. If ".", check if stack is empty, if not copy TOS to result, if so, error
; 8. Loop back to 3

; Registers:
; R0 - primary register for operations
; R1 - temp register
; R2 - temp register
; R3 - operator vector for JSRR
; R4 - RPN stack pointer

            .ORIG x3000
            br start

; data section for constants

            ; Setup test values for 0, 9, +, -, *, /, . and RPN stack

            ; Print title and instructions
    
            ; Read character from keyboard

            ; check for valid characters
            ; 2a <= char <= 39 are possibly valid
            ; char x2c "," is invalid, rest are valid
            
            ; input must be >= x2a, "*"
            ; if not, go get another char
            
            ; input must be <= x39, "9"
            ; if not, go get another char

            ; x2c ",", is undefined, while valid, ignore
            ; go get another char

            ; == x2D "."
            ; yes, check if TOS valid (atleast one number on stack)
            ;   yes, copy TOS to result and quit
            ;   no, print error out 

            ; R0 contains a valid char (operator or number)
            ; check which operator (+, -, *, /)
            ; and put operator vector in R3
            
            ; ADD operator
            ; if "+" operator, add vector -> R3

            ; MINUS operator
            ; if "-" operator, minus vector -> R3

            ; MULTIPLY operator
            ; if "*" operator, multiply vector -> R3

            ; DIVIDE operator
            ; if "/" operator, divide vector -> R3
        
            ; not an operator, therefor a number
            ; convert number to decimal
            ; place on RPN stack
            ; go get another char

            ; operator section, all operators go through this check
            ; operators require two numbers on RPN stack
            ; if only one number on stack, error out and terminate

            ; valid operator with 2 numbers on stack
            ; echo operator
            ; pop stack twice, into R1 and into R2
            ; go to operator vector to complete operation
            ; on return, go get another char
      
            ; add two numbers on stack
            ; result in R0

            ; subtract two numbers on stack
            ; result in R0

            ; multiply two numbers on stack
            ; result in R0

            ; integer divide two numbers on stack
            ; result in R0
        
            ; push result onto stack
            ; go get another char

            ; get error message and terminate
            
            ; copy TOS to result, get normal message and terminate

            ; terminate
            
; Message Section
            .END
