# Problems **Lecture 2a: Bits, Data Types, and Operations**
## 1. Base Notation
Using the base notated, write the value for the decimal number given in the base using weighted positional notation:
* **Example:** decimal 17 in base 3
* Base 3: See table in Lecture pdf.

* **Answer: , decimal 17 = 8 + 9 so base 3 = 22 + 100 or 122**
  
### 1.1: decimal 22 in base 3
```


```
### 1.2: decimal 15 in base 4
```


```
## 2. **Unsigned Binary** Additional and Subtraction
## Example: Binary Addition

```
  1011
+ 1101
------
11000
```

## Problems

### 2.1: Binary Addition (**Unsigned Binary**)

```
  1110
+ 1011
------

```

### 2.2: Binary Subtraction (**Unsigned Binary**)

```
  1101
- 1011
------

```

## Problem 3 Binary Representations
### 3.1 How do we add two **sign-magnitude** numbers? – e.g., try 2 + (-3)
```


```
### 3.2 How do we add two **1's complement** numbers? – e.g., try 4 + (-3)
```


```
### 3.3 Demonstrate adding a positive and negative **2's complement** number equals 0. Use numbers greater than decimal 32
```


```
<div style="page-break-after: always;"></div>

## Problem 4 **2's Complement** Binary to Decimal Conversion
### Example 1: Positive Number

Convert the **2's complement** binary number ```0101``` to decimal.

Since the most significant bit (MSB) is 0, the number is positive. We can convert it to decimal by evaluating the powers of 2:

```python
(0 * 2^3) + (1 * 2^2) + (0 * 2^1) + (1 * 2^0) = 0 + 4 + 0 + 1 = 5
```

The decimal equivalent of the **2's complement** binary number ```0101``` is 5.

## Example 2: Negative Number

Convert the **2's complement** binary number ```1011``` to decimal.

Since the MSB is 1, the number is negative. We need to find the **2's complement** of the number to determine its decimal value:

1. Invert the bits: ```0100```
2. Add 1: ```0101```

Now, we can convert the resulting binary number to decimal:

```python
(0 * 2^3) + (1 * 2^2) + (0 * 2^1) + (1 * 2^0) = 0 + 4 + 0 + 1 = 5
```

Since the original number was negative, we negate the result: -5.

The decimal equivalent of the 2's complement binary number ```1011``` is -5.

### 4.1 Convert the 2's complement binary number ```0110``` to decimal.
```


```
### 4.2 Convert the 2's complement binary number ```1101``` to decimal.
```


```

<div style="page-break-after: always;"></div>

## Problem 5. Decimal to Binary Conversion - Division Method
### Example 1: Positive Number 7 to Binary

1. Change to positive decimal number: 7 (already positive)
2. Divide by two – remainder is least significant bit:
   - 7 ÷ 2 = 3 remainder 1
   - 3 ÷ 2 = 1 remainder 1
   - 1 ÷ 2 = 0 remainder 1
3. Record remainders from right to left: 111
4. Prepend a zero as the MS bit: 0111

The binary equivalent of the decimal number 7 is 0111.

## Example 2: Negative Number -5 to Binary

1. Change to positive decimal number: 5
2. Divide by two – remainder is least significant bit:
   - 5 ÷ 2 = 2 remainder 1
   - 2 ÷ 2 = 1 remainder 0
   - 1 ÷ 2 = 0 remainder 1
3. Record remainders from right to left: 101
4. Prepend a zero as the MS bit and take two's complement:
   - Original binary: 0101
   - Invert bits: 1010
   - Add 1: 1011

The binary equivalent of the decimal number -5 is 1011.

## Problems

### 5.1.1. Convert the decimal number 25 to binary using the division method.
```


```

### 5.1.2 Convert the decimal number -3 to binary using the division method.
```



```

<div style="page-break-after: always;"></div>

## 6: Decimal to Binary Conversion
### Example 1: Positive Number

Convert the decimal number 9 to binary using the second method.

1. Change to positive decimal number: 9 (already positive)
2. Subtract largest power of two less than or equal to number: 8 (2^3)
3. Put a one in the corresponding bit position: ```1000```
4. Keep subtracting until result is zero:
	* 9 - 8 = 1
	* 1 - 1 = 0 (2^0)
	* Put a one in the corresponding bit position: ```1001```
5. Append a zero as MS bit (not needed for positive numbers)

The binary equivalent of the decimal number 9 is ```1001```.

## Example 2: Negative Number

Convert the decimal number -5 to binary using the second method.

1. Change to positive decimal number: 5
2. Subtract largest power of two less than or equal to number: 4 (2^2)
3. Put a one in the corresponding bit position: ```100```
4. Keep subtracting until result is zero:
	* 5 - 4 = 1
	* 1 - 1 = 0 (2^0)
	* Put a one in the corresponding bit position: ```101```
5. Append a zero as MS bit and take two's complement (for negative numbers):
	* ```101``` -> ```011``` (invert bits)
	* ```011``` + 1 = ```100``` (add 1)

The binary equivalent of the decimal number -5 is ```1111``` (in two's complement form).

<div style="page-break-after: always;"></div>

## 6 Problems

### 6.1 Convert the decimal number 12 to binary.
```


```
### 6.2 Convert the decimal number -3 to binary.
```


```
### 6.3 Convert the decimal number 7 to binary.
```


```
### 6.4 Convert the decimal number -9 to binary.
```


```

<div style="page-break-after: always;"></div>

## Problem 7 Binary Logic

### AND Operations

### 7.1 Perform the AND operation: ```10101010``` AND ```11001100```
```


```
### 7.2 Perform the AND operation: ```11110000``` AND ```10101010```
```


```
## OR Operations

### 7.5 Perform the OR operation: ```10101010``` OR ```11001100```
```


```
### 7.6 Perform the OR operation: ```11110000``` OR ```10101010```
```


```
## NOT Operations

### 7.9 Perform the NOT operation: NOT ```10101010```
```


```
### 7.10 Perform the NOT operation: NOT ```11110000```
```


```

## 8. Binary Arithmetic (**2's complement**)

8.1.1. **Add** the following binary numbers:
   ```
      1101
   +  0111
   ------

   ```

8.1.2. **Add** the following binary numbers:
   ```
      0110
   +  1101
   -------

   ```

8.2.1. **Subtract** the following binary numbers:
   ```
      1101
   -  0111
   ------
    
   ```

8.2.2. **Subtract** the following binary numbers:
   ```
      10110
   -  01101
   -------
   
   ```
