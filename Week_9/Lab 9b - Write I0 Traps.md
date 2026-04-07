# Lab 9b - Writing I/O Traps

## 1. Write a Trap to Output a Prompt Character

Following the example in Lecture 9b, write a trap which will output a prompt in R0. While this is a duplicate of the OUT trap, it will serve as the base prompt in SMC.

Be sure to write all three parts:
1. Initialize the trap vector
2. Trap execution code
3. Trap example usage

## 2. Write a Trap to Input a Number

Following the example in Lecture 9b, write a trap which will input *ONLY* a number and will return the binary value in R0. Ignore all other characters other than 0-9, be sure to convert the number to binary before returning from the trap.

Be sure to write all three parts:
1. Initialize the trap vector
2. Trap execution code
3. Trap example usage