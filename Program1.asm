; Programming Project 1 starter file
; Student Name: Keshav Narasimhan 
; UTEid: ___________
; Modify this code to satisfy the requirements of Project 1
; left-rotate a 16-bit number N by B bit positions. 
; N is at x30FF; B is is x3100; put result at x3101
; Read the complete Project Description on Canvas

	.ORIG	x3000
;---- Your Solution goes here	
    LD R0, xFE          ; x3000   x3001 + FE = x30FF --> R0 will store the given value of N
    BRz #13             ; x3001   if the value in R0 is 0, it doesn't require a shift so you can just store it in x3101
    LD R1, xFD          ; x3002   x3003 + FD = x3100 --> R1 will store the given value of B from x3100
    BRz #11             ; x3003   if B is 0, then the number doesn't need to shift and can be immediately stored in x3101
    ADD R2, R0, #0      ; x3004   stores R0 in R2 --> in the PSR, N will tell if it is positive or neg. number
    BRn #1              ; x3005   if R2 is negative, we know that MSB is 1, so we need to add 1 when we shift (separate code)
    BRp #3              ; x3006   if R2 is positive, we'll perform some separate code on it
    ADD R2, R0, R0      ; x3007   R2 is negative --> first add N together and store in R2 to shift left once
    ADD R2, R2, #1      ; x3008   R2 is negative --> add 1 to the R2 to represent MSB becoming the LSB
    BR #2               ; x3009   the code to process negative numbers is complete
    ADD R2, R0, R0      ; x300A   R2 is positive --> simply add N together and store in R2 to shift left once
    BR #0               ; x300B   the code to process positive numbers is complete
    ADD R0, R2, #0      ; x300C   rewrite shifted value of N within R2 to R0
    ADD R1, R1, #-1     ; x300D   R1 holds B (num times to shift), we need to decrease its value by 1 since we went through the process 1 time
    BR #-12             ; x300E   go back to the check if the process needs to be repeated, since it must continue to loop till B is 0
    ST R0, xF1          ; x300F   x3010 + x00F1 = x3101 --> store the final left rotated number in x3101
    
;---- Done
	TRAP	x25
;---- You may declare addresses and such here

	.END
;   Test Cases:
;	.ORIG x30FF      
;	.FILL x0    ;test value of N
;	.FILL #4       ;test value of B
;	.END

