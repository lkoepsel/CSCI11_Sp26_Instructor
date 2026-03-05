; simple comment to describe code
            .ORIG x3000
            LD R0, LD_ADDR
            LDI R1, LDI_ADDR
            LDR R2, R0, #2
            LEA R3, LEA_ADDR
            HALT
LD_ADDR     .fill   x300A
LDI_ADDR    .fill   x300B
LEA_ADDR     .fill  x300C
            .END
