# **Simple Math Calculator** (**SMC**)

I am deliberately leaving some of the details vague. My goal is to see how well thought out your solution is, as well as the user interface and the repository in which the SMC resides.

Some thoughts which might help you:
1) If you have an error or capability, which you are unable to solve, make a note. It is better to state what can and can not happen, vs having the user discover it.
2) A slightly working program which is well-documented will be scored higher than a program which works well, however, is poorly documented.
3) Have a friend attempt to use the calculator with minimal instruction, document what they find to ensure you have good instructions.

## Description

### Operators
This LC3-based Reverse Polish Notation (RPN) calculator will accept numbers with up to 4 digits and perform operations:
* \+ - add two numbers on the stack and place the result on the stack
* \- - add two numbers on the stack and place the result on the stack
* \* - add two numbers on the stack and place the result on the stack
* / - add two numbers on the stack and place the result on the stack
* . - print the number on the top of stack

### Prompts
The calculator will show the following prompts:
* \> - ready to accept a new number
* ? - error occurred, input doesn't make sense
* $ - stack error occurred
* ! - numeric overflow or underflow

### Headings
At the beginning of the program, the calculator will display a title and a short series of subheadings to describe how to use it. As an example:

```
SMC RPN calculator
Enter 0-9 or +, -, *, /, or
. to display result on TOS
```

## Conditions

### Input
1. Only numbers and "." will be recognized, all other characters will be ignored.
2. If only one number on top of stack (*TOS*) then an math operator input, an error prompt will be displayed.
3. The print operator "." will display TOS, even if it is the only number on the stack.
4. After discussion and thought, one will need to indicate that a number has been entered. There are several methods:
    * Use a " " (space x20) - which will allow numbers and operators to remain on one line. This makes it easy to understand what was input, however, this might not be natural for some people to type.
    * Use a "CR" (carriage return x0A) - using *CR* or *Return* or *Enter* (all the same ASCII char), makes it more natural from an input perspective. In other words, "Enter a number hit Enter" then enter the operator, however, this makes it harder to read and it would probably make sense to output the operator and a LF as compared to just printing the operator.
    * Something else, which makes sense to you. What you choose isn't material, why you chose it and how it works from a user experience (UX) will matter.

### Output
1. See Prompts
2. Upon error prompt, reset program to the beginning.

## Code Repository

The code needs to reside in its own repository. Please create one and we'll review the repo in 1:1 discussion. You will want to ensure you cover the following areas with some detail:

1. **README.md** - Introduction, installation steps, usage examples of the Simple Math Calculator
2. **Tool Guidance** - For someone who wishes to start from scratch and use your code
3. **LICENSE** - Clear usage rights for educational materials, when you create a repo, GitHub will guide you as to possible licenses for your code. Pick one.
5. **Organized directories** - Separate folders for source code, documentation, and examples

The intent of having this as a separate repository, is that it provides an example repository for people to see your work. The quality of the work in the repo will be as important as the code working.