ORG 0
start:  
        MOV 30H,#01FH
        MOV 31H,#2H
        MOV 32H,#4H
        MOV 35H,#13H
        MOV 36H,#10H
        MOV 22H,#01H
        MOV 40H,#08H
        MOV 41H,#08H
        MOV 42H,#80H
        MOV 43H,#08H
        MOV SP, #4FH
        ACALL reset
        ACALL write
        LJMP endl
reset:  CLR A
        CLR c
        MOV R0,#00H
        MOV R1,#00H
        MOV R2,#00H
        MOV R3,#00H
        MOV R4,#00H
        MOV R5,#00H
        MOV R6,#00H
        MOV R7,#00H
        RET

read:   MOV R7,30H
        MOV R6,31H
        ACALL cal_index
        MOV R7,32H
        ACALL cal_index2
        MOV R7,37H
        ACALL bit_rotateR
        ACALL bit_read
        MOV R7,37H
        ACALL bit_rotateL
        RET

cal_index:  
        // RESET
        MOV A,R6
        SUBB A, R7
		ANL A,#01FH
        MOV 37H,A
        MOV A,R7
        MOV B,#08H
        DIV AB
        MOV 38H,A
        MOV R0,B
        MOV A,R0
        MOV R1,#01H
TEST1:  JZ TEST1_FI
        MOV A,R1
        RL A
        MOV R1,A
        DEC R0
        MOV A,R0
        AJMP TEST1
TEST1_FI:
        MOV 39H,R1
        RET

cal_index2:  
        MOV A,R7
        MOV B,#08H
        DIV AB
        ADD A,#20H
        MOV 3AH,A //BYTE ADDRESS OF BIT ADDRESS
        MOV R0,B
        MOV A,R0
        MOV R1,#01H
TEST2:  JZ TEST2_FI
        MOV A,R1
        RL A
        MOV R1,A
        DEC R0
        MOV A,R0
        AJMP TEST2
TEST2_FI:
        MOV 3BH,R1 //MASK OF BIT ADDRESS
        RET

bit_rotateR:
        CJNE R7, #00H, F_BYTE_RR
bit_rotaterBACK:
        RET
F_BYTE_RR: 
        PUSH 0
        PUSH 7
        MOV R7,#04H
        MOV R0,#43H
        CLR C
F_BYTE_RR_IN:
        MOV A,@R0
        RRC A
        MOV @R0,A
        DEC R0
        DJNZ R7, F_BYTE_RR_IN
        MOV A,#00H
        ADDC A, #00H
        RR A
        ADD A,43H
		MOV 43H,A
        POP 7
        POP 0
        DJNZ R7,F_BYTE_RR
        AJMP bit_rotaterBACK

bit_read:
        PUSH 0
        PUSH 1
        PUSH 7
        PUSH 6
        MOV R7,39H
        MOV R6,38H
        MOV R0,3AH
        MOV R1,#40h
        CLR C

        MOV A,R1
        ADD A,38H
        MOV R1,A
        
        MOV A,@R1
        ANL A,R7
        ADDC A,#0FFH

        JC READ_ONE
READ_ZERO:
        MOV A,3BH
        XRL A,#0FFH
        ANL A,@R0
        MOV @R0,A
        AJMP READ_FI
READ_ONE:
        MOV A,3BH
        ORL A,@R0
        MOV @R0,A
READ_FI:
        POP 6
        POP 7
        POP 1
        POP 0
        RET

bit_rotateL:
        CJNE R7, #00H, F_BYTE_RL
bit_rotateLBACK:
        RET
F_BYTE_RL: 
        PUSH 0
        PUSH 7
        MOV R7,#04H
        MOV R0,#40H
        CLR C
F_BYTE_RL_IN:
        MOV A,@R0
        RLC A
        MOV @R0,A
        INC R0
        DJNZ R7, F_BYTE_RL_IN
        MOV A,#00H
        ADDC A, #00H
        ADD A,40H
        MOV 40H,A
        POP 7
        POP 0
        DJNZ R7,F_BYTE_RL
        AJMP bit_rotateLBACK

write:  MOV R7,30H
        MOV R6,35H
        ACALL cal_index
        MOV R7,36H
        ACALL cal_index2
        MOV R7,37H
        ACALL bit_rotateR
        ACALL bit_write
        MOV R7,37H
        ACALL bit_rotateL
        RET
bit_write:
        PUSH 0
        PUSH 1
        PUSH 5
        PUSH 6
        PUSH 7

        MOV R7,39H
        MOV R6,38H
        MOV R0,3AH
        MOV R1,#40H
        CLR C

        MOV A,@R0
        ANL A,3BH
        ADDC A,#0FFH
        JC WRITE_ONE
WRITE_ZERO:
        MOV A,R7
        XRL A,#0FFH
        MOV R7,A
        MOV A,R1
        ADD A,38H
        MOV R1,A
        MOV A,@R1
        ANL A,R7
        MOV @R1,A
        AJMP WRITE_FI
WRITE_ONE:
	MOV A,R1
        ADD A,38H
        MOV R1,A
        MOV A,@R1
        ORL A,R7
        MOV @R1,A
WRITE_FI:        
        POP 7
        POP 6
        POP 5
        POP 1
        POP 0
	RET
endl: 
	END