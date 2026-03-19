# Lab 7: Recursive Maximum

## Overview

You are given `sum_r.asm`, a working recursive sum of an integer list.
Your task is to adapt it into `max_r.asm` — a recursive maximum finder.

The recursive *structure* will be identical.

---

## Hints: Peek at the Next Element

Instead of detecting the sentinel on the **current** element, look ahead
one position. If the **next** element is the sentinel, the current element
is the last real value — return it directly as `R5`. The comparison then
always runs between two real list elements, so the overflow never occurs.


## Hints: Accumulation

In `sum_r.asm`, the unwind step adds the current element to the running sum:

```lc3
        ADD R5, R5, R1      ; R5 = lst[0] + sum(lst[1:])
```

For max, keep whichever is larger — `R1` (current element) or `R5`
(max of the rest). 

## Test Case

```lc3
LIST    .FILL #3
        .FILL #1
        .FILL #4
        .FILL #1
        .FILL #5
        .FILL xFFFF         ; sentinel
```

Expected result: memory location `MAX` = **5**

Verify in the LC-3 simulator by inspecting the memory address of label `MAX`
after the program halts.

# Lab Exercise 2: Recursive Sorted Check

## Overview

You have now seen one and written one, recursive function that traverse a list:

| Function | Operation | Base case returns |
|----------|-----------|-------------------|
| `sum_r`  | Accumulates a running sum  | `0` (additive identity) |
| `max_r`  | Tracks a running maximum   | Last real element |

This exercise asks you to write `is_sorted`, which checks whether an
integer list is sorted in **non-decreasing** (ascending) order, returning
`0` for sorted and `1` for unsorted.

The recursive structure is the same, but three new ideas appear:

1. **Two base cases** — there are two ways to stop recursing:
   - The end of the list is reached → sorted so far → return `0`
   - An out-of-order pair is found → definitely unsorted → return `1`

2. **Early termination** — when an out-of-order pair is detected, the
   function returns `1` *immediately*, without pushing anything onto the
   stack and without recursing further.

3. **No element saved on the stack** — because the result from the
   recursive call passes through unchanged (we just return whatever the
   deeper call returns), only `R7` is pushed before `JSR IS_SRT` —
   not the current element.

## Strategy

### The three-way branch

After loading the current element (`R1`) and peeking at the next (`R2`),
there are three possible outcomes — handled in this order:

```
A) next element is xFFFF (sentinel)  →  BRz TRUE   (base case: list ends)
B) current > next                    →  BRp FALSE  (base case: unsorted)
C) current ≤ next                    →  fall through to recursive case
```

### Hints: Stack frame — save only R7

Because the unwind step simply returns `R5` as-is, there is nothing to
restore from the stack. Only `R7` is pushed:

```
sum_r / max_r              is_sorted
──────────────────         ──────────────────
push R7                    push R7
push R1    ← current       (not needed)
JSR ...                    JSR IS_SRT
pop  R1                    (nothing to pop)
pop  R7                    pop  R7
accumulate result          RET  ← pass R5 through unchanged
RET
```

---

### Hints: — Three-way branch after the peek

After the two load lines, add the following logic. Handle case (A) first, then (B), then let case (C) fall through:

### Hints: Base case labels 

Add two labels (and code) after the `RET` at the end of the recursive block, to indicate returning True (R5 = 0) or False (R5 = 1):

## Test Cases

Load an **unsorted** list so you can verify the `FALSE`
path works first:

```lc3
;   list = [1, 3, 2, 4, 5]     expected result: RESULT = 1
```

Once that passes, change the list to verify the `TRUE` path:

```lc3
;   list = [1, 2, 3, 4, 5]     expected result: RESULT = 0
```

Also test the **equal-elements** case — equal adjacent values are
allowed (non-decreasing, not strictly increasing):

```lc3
;   list = [1, 3, 3, 5]        expected result: RESULT = 0
```

---
