# Practice Problems for LC3 Assembly

## Basic Exercises:

1. **Variable Declaration and Access**
   Write LC-3 assembly code to:
   - Declare a variable named ```COUNT``` with initial value 5
   - Load this value into R0
   - Increment it by 1
   - Store the result back in ```COUNT```
   
### Place screenshot over this line.

2. **Case Sensitivity Practice**
   Determine if these labels refer to the same variable:
   ```assembly
   TOTAL   .FILL   #10
   total   .FILL   #20
   Total   .FILL   #30
   ```
   Explain your answer.
   
   ```
   
   
   
   ```

### Place screenshot over this line.

3. **Pointer Usage**
   Write code to:
   - Create a pointer variable ```PTR``` that points to a value
   - Use LDI to load the value it points to into R1
   - Use STI to store a new value through the pointer

### Place screenshot over this line.

## Intermediate Exercises:

4. **Structure Access**
   Given this structure:
   ```assembly
   DATE    .FILL   #1    ; day
          .FILL   #3    ; month
          .FILL   #2025 ; year
   ```
   Write code to:
   - Load the month value into R0 using an offset
   - Increment it
   - Store it back [^1]

### Place screenshot over this line.

5. **Array Manipulation**
   Create an array of 5 integers and write code to:
   - Initialize all elements to 0
   - Load the third element into R2
   - Use proper offset calculations

### Place screenshot over this line.

## Advanced Exercises:

6. **Loop Variable Optimization**
   Write a loop that:
   - Counts from 1 to 5
   - Keeps the counter in a register
   - Demonstrates efficient register usage without unnecessary loads/stores

### Place screenshot over this line.

7. **Combined Concepts**
   Create a program that:
   - Declares an array of 3 numbers
   - Uses a loop to sum them
   - Stores the result in a variable named ```TOTAL```

### Place screenshot over this line.