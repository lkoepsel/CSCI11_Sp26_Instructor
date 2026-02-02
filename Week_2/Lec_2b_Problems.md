# Problems **Lecture 2b: Transistors, Gates, and  Boolean Logic**
## Digital Logic Exercises
For these exercises, use [Digital Logic Simulator](www.logic.ly), to create the desired circuit. Once you are convinced the circuit works as desired, take a screenshot and paste onto this sheet.

### Idempotent

A fundamental law in binary logic where an operation repeated on itself yields the same result. For example:
- A AND A = A
- A OR A = A
This means performing the same logical operation multiple times doesn't change the outcome.
```

Paste screenshot here



```
### Annulment

Also known as the dominance law, this principle states that:
- A AND 0 = 0
- A OR 1 = 1
When combined with these special values, the result is predetermined regardless of the other operand.
```

Paste screenshot here



```

<div style="page-break-after: always;"></div>

### Identity


The identity law states that certain operations with specific values leave the operand unchanged:
- A AND 1 = A
- A OR 0 = A
These values (1 for AND, 0 for OR) act as neutral elements in the operation.
```

Paste screenshot here



```
### Complement Law of Switches

This law deals with complementary operations:
- A AND (NOT A) = 0
- A OR (NOT A) = 1
When a value is combined with its complement using AND or OR, the result is always definite.
```

Paste screenshot here



```
### Double Complement Law

States that negating a value twice returns the original value:
- NOT(NOT A) = A
This is similar to how two negatives make a positive in regular mathematics.
```

Paste screenshot here



```

<div style="page-break-after: always;"></div>

### Commutative Law

The order of operands doesn't affect the result:
- A AND B = B AND A
- A OR B = B OR A
You can swap the position of values and get the same outcome.
```

Paste screenshot here



```
### Distributive Law

Similar to algebra, one operation distributes over another:
- A AND (B OR C) = (A AND B) OR (A AND C)
- A OR (B AND C) = (A OR B) AND (A OR C)
This allows for restructuring complex expressions.
```

Paste screenshot here



```
### Absorptive Law

Describes how certain combinations of operations can be simplified:
- A AND (A OR B) = A
- A OR (A AND B) = A
The additional term gets "absorbed" into the expression.
```

Paste screenshot here



```

<div style="page-break-after: always;"></div>

### Associative Law

The grouping of operations doesn't affect the result:
- (A AND B) AND C = A AND (B AND C)
- (A OR B) OR C = A OR (B OR C)
You can regroup terms without changing the outcome.
```

Paste screenshot here



```
### De Morgan's Theorem

A fundamental principle for simplifying logical expressions:
- NOT(A AND B) = (NOT A) OR (NOT B)
- NOT(A OR B) = (NOT A) AND (NOT B)
This law shows how negation distributes across AND/OR operations.
```

Paste screenshot here


```
