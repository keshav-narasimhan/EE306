; Program5.asm
; Name: Keshav Narasimhan
; UT Eid: ____________
; Continuously reads from x3600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
    .ORIG x3000
; set up the keyboard interrupt vector table entry
;M[x0180] <- x2600
    LD      R0, KBISR
    STI     R0, KBINTVec      ; stores x2600 in x0180
; enable keyboard interrupts
; KBSR[14] <- 1 ==== M[xFE00] = x4000
    LD      R0, KBINTEN
    STI     R0, KBSR
    ; global variable to ensure that start of Loop will continue looping due to the 0
    AND     R0, R0, #0
    STI     R0, GLOB
    
    AND     R3, R3, #0      ; counter var
    ST      R3, UCount
    ST      R3, ASCII_Total
    ST      R3, CharCounter

; This loop is the proper way to read an input
Loop
    LDI R0,GLOB
    BRz Loop             
; Process it
    
    ; at this point in the program, we know that x3600 has a valid char stored in it
    OUT     ; display char on console
    
    ; check start codon
    LD      R4, GLOB        ; used to clear x3600 after processing each char
    AND     R5, R5, #0      ; used to put 0 into x3600 after each char
    AND     R2, R2, #0      ; use to check which char has been typed
    
    AND     R6, R6, #0      ; used to check state of counter
    ADD     R6, R3, #0
    BRz     A_START
    AND     R6, R6, #0
    ADD     R6, R3, #-1
    BRz     U_START
    AND     R6, R6, #0
    ADD     R6, R3, #-2
    BRz     G_START
    BRp     LOOK_FOR_STOP
    
    
A_START
    AND     R2, R2, #0
    LD      R1, UpA         ; load negative upper case A ASCII val in R1
    ADD     R2, R0, R1
    BRnp    RESTART_START
    ADD     R3, R3, #1      ; increment counter
    STR     R5, R4, #0
    BR      Loop
U_START
    LD      R1, UpU
    ADD     R2, R0, R1
    BRnp    DO_FIRST;A_START;RESTART_START
    ADD     R3, R3, #1      ; increment counter
    STR     R5, R4, #0
    BR      Loop
G_START
    LD      R1, UpG
    ADD     R2, R0, R1
    BRnp    DO_FIRST;A_START;RESTART_START
    BRz     VERT_LINE

DO_FIRST
    AND     R3, R3, #0
    BR      A_START
    
RESTART_START
    AND     R3, R3, #0      ; reset counter
    STR     R5, R4, #0      ; put 0 into x3600
    BR      Loop
    
VERT_LINE
    LD      R0, EndStart
    OUT
    ADD     R3, R3, #1      ; increment counter so that R3 should have a val of 3 at the end of start codon
    STR     R5, R4, #0
    BR      Loop
    
LOOK_FOR_STOP
    ; keep R3 held at 3 so that it will continue coming to this part of the code
    ; STOP codon can be either UAG, UGA, or UAA
    ; for UAG and UGA, I can check to see if first is a U, then add the next 2 chars
;    AND     R6, R6, #0
 ;   LD      R5, UCount
  ;  ADD     R6, R5, #0
 ;   BRz     U_DONE
  ;  BR      NEXT_TWO_CHARS
    
;U_DONE
;    LD      R1, UpU
;    ADD     R2, R0, R1
;    BRz     RESTART_END
;    LD      R5, UCount
;    ADD     R5, R5, #1
;    ST      R5, UCount
    
;RESTART_END
;    AND     R5, R5, #0
;    ST      R5, UCount
;    LD      R4, GLOB
;    STR     R5, R4, #0
    
;NEXT_TWO_CHARS
    AND     R2, R2, #0
    LD      R1, UpU
    ADD     R2, R0, R1
    BRz     U_END
    BRnp    CHECK_COUNTER
    
U_END
    ; know that the char typed is a U
    AND     R5, R5, #0
    ADD     R5, R5, #1
    ST      R5, UCount              ; signifies that a U has been reached
    AND     R5, R5, #0
    ST      R5, ASCII_Total         ; since U has been reached, the next 2 chars' sum has to be reinitialized to 0 (begin again)
    ST      R5, CharCounter         ; since U has been reached, the num of chars that haven't be U's afterwards has to be back to 0
    LD      R4, GLOB
    STR     R5, R4, #0              ; set x3600 to 0 since we processed the char
    BR      Loop
    
CHECK_COUNTER
    AND     R5, R5, #0
    LD      R4, UCount
    ADD     R5, R4, #-1
    BRz     SUM_CHARS               ; there has been a U AND the next char is not a U
    AND     R5, R5, #0
    LD      R4, GLOB
    STR     R5, R4, #0
    BR      Loop
    
SUM_CHARS 
    LD      R6, ASCII_Total
    ADD     R6, R6, R0
    ST      R6, ASCII_Total         ; add R0's ASCII val in ASCII_Total
    LD      R6, CharCounter
    ADD     R6, R6, #1              ; increment CharCounter
    ST      R6, CharCounter
    ADD     R6, R6, #-2             
    BRz     CHECK_SUM               ; if there have been 2 chars after the U that haven't been U, check the ASCII sum
    AND     R6, R6, #0
    LD      R4, GLOB                ; set x3600 to 0 since we have processed the char
    STR     R6, R4, #0
    BR      Loop

CHECK_SUM
    LD      R5, Sum_AA
    LD      R4, ASCII_Total
    ADD     R5, R4, R5
    BRz     FINISH_PROGRAM
    LD      R5, Sum_AG
    ADD     R5, R4, R5
    BRz     FINISH_PROGRAM
    ; at this pt we know that the 2 chars after U were not AG, GA, or AA
    AND     R5, R5, #0
    ST      R5, CharCounter
    ST      R5, ASCII_Total
    ST      R5, UCount
    LD      R4, GLOB
    STR     R5, R4, #0
    BR      Loop
    
; Repeat unil Stop Codon detected
FINISH_PROGRAM
    HALT
KBINTVec  .FILL x0180
KBSR   .FILL xFE00
KBISR  .FILL x2600
KBINTEN  .FILL x4000
GLOB   .FILL x3600
EndStart
    .FILL x7C
UpA
    .FILL x-41
UpC
    .FILL x-43
UpG
    .FILL x-47
UpU
    .FILL x-55
UCount
    .BLKW #1
ASCII_Total
    .BLKW #1
CharCounter
    .BLKW #1
Sum_AA
    .FILL #-130
Sum_AG
    .FILL  #-136

	.END

; Interrupt Service Routine
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x3600
        .ORIG x2600
        ST      R0, SVISR0
        ST      R1, SVISR1
        ST      R2, SVISR2
        ; callee saves
        AND     R2, R2, #0      ; will store sum of KBDR & ASCII vals
        LDI     R0, KBDR        ; load contents of KBDR (ASCII val of key hit) into R0
        
        LD      R1, UpperA
        ADD     R2, R0, R1
        BRz     ValidTypedChar
        AND     R2, R2, #0
        
        LD      R1, UpperC
        ADD     R2, R0, R1
        BRz     ValidTypedChar
        AND     R2, R2, #0
        
        LD      R1, UpperG
        ADD     R2, R0, R1
        BRz     ValidTypedChar
        AND     R2, R2, #0
        
        LD      R1, UpperU
        ADD     R2, R0, R1
        BRz     ValidTypedChar
        BRnp    ISRDone
        
    ValidTypedChar
        NOT     R1, R1
        ADD     R1, R1, #1      ; reverse the val of R1 to get the true ASCII val of the char
        LD      R2, GLOBAL
        STR     R1, R2, #0      ; store typed char ASCII val at x3600
        BR      ISRDone

    ISRDone        
        LD      R0, SVISR0
        LD      R1, SVISR1
        LD      R2, SVISR2
        RTI
        
KBDR  .FILL xFE02
GLOBAL  .FILL x3600
SVISR0
    .BLKW #1
SVISR1
    .BLKW #1
SVISR2
    .BLKW #1
UpperA
    .FILL x-41
UpperC
    .FILL x-43
UpperG
    .FILL x-47
UpperU
    .FILL x-55
		.END
