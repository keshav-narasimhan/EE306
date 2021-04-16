;;***********************************************************
; Programming Assignment 3
; Student Name: Keshav Narasimhan
; UT Eid: ____________
; Simba in the Jungle
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.
; Note: Remember "Callee-Saves" (Cleans its own mess)

;***********************************************************

.ORIG x3000

;***********************************************************
; Main Program
;***********************************************************
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_INITIAL
    TRAP  x22 
    LDI   R0,BLOCKS
    JSR   LOAD_JUNGLE
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_LOADED
    TRAP  x22                        ; output end message
    TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
BLOCKS          .FILL x5000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
                   

;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE
    ST      R0, SV1R0
    ST      R1, SV1R1
    ST      R2, SV1R2
    ST      R3, SV1R3
    ST      R4, SV1R4
    ST      R5, SV1R5
    ST      R6, SV1R6
    
    LD      R0, Enterer
    OUT
    LEA     R1, First
    ADD     R1, R1, #-1
FirstAgain
    ADD     R1, R1, #1
    LDR     R0, R1, #0
    BRz     Cont
    OUT
    BR      FirstAgain
; have finished outputting the column numbers
Cont
    LD      R0, Enterer
    OUT
    LD      R3, GridInit                ; holds location of the grid
    AND     R6, R6, #0
    AND     R5, R5, #0
    LD      R5, Nums                    ; ASCII val of 0
    AND     R1, R1, #0
    ADD     R1, R1, #1                  ; will act as bit mask to check if R0 is even or odd
    AND     R2, R2, #0
Again
    LD      R0, Offsetter
    NOT     R0, R0
    ADD     R0, R0, #1                  ; add
    ADD     R0, R0, R6                  ; add 
    BRz    Finish1
    ADD     R6, R6, #0
    AND     R2, R6, R1                  ; check if even or odd using bit mask
    ADD     R2, R2, #0
    BRz     Even                        ; if number is even, go to "Even"
    LD      R0, Numss
    NOT     R0, R0
    ADD     R0, R0, #1
    ADD     R0, R5, R0
    BRp     Finish1
    AND     R0, R0, #0
    ADD     R0, R5, R0
    OUT
    LD      R0, Spacebutton
    OUT
    AND     R0, R0, #0
    ADD     R5, R5, #1
OddAgain   
    LDR     R4, R3, #0
    BRnp    DoOdd
    LD      R0, Enterer
    OUT
    ADD     R3, R3, #1
    ADD     R6, R6, #1
    BR      Again
DoOdd
    ADD     R0, R4, #0
    OUT
    ADD     R3, R3, #1
    BR      OddAgain
Even
    LD      R0, Spacebutton
    OUT
    OUT
    AND     R0, R0, #0
EvenAgain   
    LDR     R4, R3, #0
    BRnp    DoEven
    LD      R0, Enterer
    OUT
    ADD     R3, R3, #1
    ADD     R6, R6, #1
    BR      Again
DoEven
    ADD     R0, R4, #0
    OUT
    ADD     R3, R3, #1
    BR      EvenAgain
Finish1
    LD      R0, SV1R0
    LD      R1, SV1R1
    LD      R2, SV1R2
    LD      R3, SV1R3
    LD      R4, SV1R4
    LD      R5, SV1R5
    LD      R6, SV1R6
    JMP     R7
SV1R0
    .BLKW #1
SV1R1
    .BLKW #1
SV1R2
    .BLKW #1
SV1R3
    .BLKW #1
SV1R4
    .BLKW #1
SV1R5
    .BLKW #1
SV1R6
    .BLKW #1
GridInit
    .FILL   GRID
SpaceButton
    .FILL   x20
Offsetter
    .FILL   #19
Enterer
    .FILL   xA
Nums
    .FILL   x30
Numss
    .FILL   x37
First
    .STRINGZ "   0 1 2 3 4 5 6 7"      ; Column Numbers

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
    ST      R0, SV2R0
    ST      R1, SV2R1
    ST      R2, SV2R2
    ST      R3, SV2R3
    ST      R4, SV2R4
    ST      R5, SV2R5
    ST      R6, SV2R6
    
    AND     R0, R0, #0
    AND     R2, R2, #0
    LD      R3, SV2R0               ; loc of head address
AnotherRep
    LDR     R1, R3, #3              ; check if it's a possible ASCII char or not
    ; is it a #?
    LD      R2, Hashtag             ; ASCII value of '*'
    NOT     R2, R2
    ADD     R2, R2, #1
    ADD     R2, R2, R1
    BRz     FoundValid
    ; or a H
    LD      R2, HOME
    NOT     R2, R2
    ADD     R2, R2, #1
    ADD     R2, R2, R1
    BRz     FoundValid
    ; or a I
    LD      R2, CapI
    NOT     R2, R2
    ADD     R2, R2, #1
    ADD     R2, R2, R1
    BRnp    JumpToEnd
    
FoundValid
    AND     R2, R2, #0
    LD      R6, Asterisk
    LD      R5, CapI                ; ASCII value of 'I'
    NOT     R5, R5
    ADD     R5, R5, #1              ; R5 <-- negative value of 'I' to check later on if it is the initial pos.
   
    LDR     R1, R3, #1              ; row
    LDR     R2, R3, #2              ; col
    ST      R7, SV2R7
    JSR     GRID_ADDRESS
    LD      R7, SV2R7
    ; R0 should have loc of where to put char after calling GRID_ADDRESS
    LDR     R4, R3, #3
    ADD     R4, R4, R5              ; checking if char is a 'I'
    BRz     ChangeToAsterisk
    LDR     R4, R3, #3
    STR     R4, R0, #0
    BR      CheckHome
ChangeToAsterisk
    STR     R6, R0, #0
    ST      R1, CURRENT_ROW
    ST      R2, CURRENT_COL
    BR      JumpToEnd
CheckHome
    LD      R5, HOME
    NOT     R5, R5
    ADD     R5, R5, #1
    ADD     R4, R4, R5
    BRnp    JumpToEnd
    ST      R1, HOME_ROW
    ST      R2, HOME_COL
JumpToEnd
    LDR     R0, R3, #0
    BRz     Finish2
    LDR     R3, R3, #0
    BR      AnotherRep  

Finish2  
    LD      R0, SV2R0
    LD      R1, SV2R1
    LD      R2, SV2R2
    LD      R3, SV2R3
    LD      R4, SV2R4
    LD      R5, SV2R5
    LD      R6, SV2R6
    JMP     R7
SV2R0
    .BLKW #1
SV2R1
    .BLKW #1
SV2R2
    .BLKW #1
SV2R3
    .BLKW #1
SV2R4
    .BLKW #1
SV2R5
    .BLKW #1
SV2R6
    .BLKW #1
SV2R7
    .BLKW #1
CapI
    .FILL   x49
HOME
    .FILL   x48
Asterisk
    .FILL   x2A
HashTag
    .FILL   x23

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS     
    ; make sure to store (callee saves)
    ST      R1, SV3R1
    ST      R2, SV3R2
    ST      R3, SV3R3
    ST      R4, SV3R4
    ST      R5, SV3R5
    ; start the subroutine implementation
    ; equation should be ArrayBase + (r*m + c)
    ; R1 = r, R2 = c
    LD      R3, GridInit                ; ArrayBase
    LD      R4, IncrementPos            ; m
    AND     R5, R5, #0
    AND     R0, R0, #0
    ADD     R1, R1, R1
    ADD     R1, R1, #1
MultAgain
    ADD     R5, R5, R1                  ; R5 <-- r*m
    ADD     R4, R4, #-1
    BRp     MultAgain
    ADD     R2, R2, R2
    ADD     R2, R2, #1
    ADD     R5, R5, R2                  ; R5 <-- r*m + c
    ADD     R0, R5, R3
    
    LD      R1, SV3R1
    LD      R2, SV3R2
    LD      R3, SV3R3
    LD      R4, SV3R4
    LD      R5, SV3R5
    JMP     R7
SV3R1
    .BLKW #1
SV3R2
    .BLKW #1
SV3R3
    .BLKW #1
SV3R4
    .BLKW #1
SV3R5
    .BLKW #1
IncrementPos
    .FILL   #18


          .END

; This section has the linked list for the
; Jungle's layout
	.ORIG	x5000
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
    .FILL	#1
	.FILL   #1
	.FILL   x23

Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #4
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #2
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #5
	.FILL   x23
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x23
	.END	

