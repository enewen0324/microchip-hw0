How to test
1. select the portal position
    - change mov 30H,#XH; X form #00h to #1FH
2. select current position
    - change mov 31H/35H,#XH; X form #00h to #1FH
3. select target position (In read, means read and store here. In write, means )
    - change mov 32H/36H,#XH; X form #00h to #FFH
4. set default value in bit addressing memory
    - change mov 20-2FH,#XH; X form #00h to FFH
5. select read or write
    - ACALL read/write

| byte |  | 
| -------- | -------- | 
| 20 | 7 6 5 4 3 2 1 0 (target position) |
| 21 | 15 14 13 12 11 10 9 8 |
| 22 | ....... |
|......|......|
| 30 | bit address of portal position(from 0-31) |
| 31 | bit address of read current position(from 0-31) |
| 32 | bit address of read target position(from 0-256) |
|......|.......|
| 35 | bit address of write current position(from 0-31) |
| 36 | bit address of write target position(from 0-256) |
| ...... | ...... |
| 40 | 7 6 5 4 3 2 1 0 (the ring structure,portal or current position) |
| 41 | 15 14 13 12 11 10 9 8 (the ring structure,portal or current position) |
|......|.......|