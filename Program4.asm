;***********************************************************
; Programming Assignment 4
; Student Name: Keshav Narasimhan
; UT Eid: ___________
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

;***********************************************************

.ORIG x4000

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
HOMEBOUND
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BR    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   IS_SIMBA_HOME      
        ADD   R2, R2, #0                 ; R2 will be zero if Simba reached Home
        BRnp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
PROMPT .STRINGZ "\nEnter Move \n\t(up(i) left(j),down(k),right(l)): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\nYou Saved Simba !Goodbye!\n"
BLOCKS               .FILL x5000

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
; Your Program 3 code goes here
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
; Your Program 3 code goes here
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
; Your Program 3 code goes here
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

;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
; Your New (Program4) code goes here

    ST      R0, InpVal0
    ST      R1, InpVal1
    ST      R3, InpVal3
    ST      R4, InpVal4
    ST      R5, InpVal5
    ST      R6, InpVal6
    ; finished callee saves
    AND     R6, R6, #0
    AND     R2, R2, #0
    
    LD      R1, LowerI          ; is it an i?
    ADD     R6, R0, R1
    BRz     CompletedInputValid
    AND     R6, R6, #0
    
    LD      R3, LowerJ          ; is it a j?
    ADD     R6, R0, R3
    BRz     CompletedInputValid
    AND     R6, R6, #0
    
    LD      R4, LowerK          ; is it a k?
    ADD     R6, R0, R4
    BRz     CompletedInputValid
    AND     R6, R6, #0
    
    LD      R5, LowerL          ; is it an l?
    ADD     R6, R0, R5
    BRz     CompletedInputValid

    ADD     R2, R2, #-1         ; found an invalid input --> R2 = -1
    
CompletedInputValid
    LD      R0, InpVal0
    LD      R1, InpVal1
    LD      R3, InpVal3
    LD      R4, InpVal4
    LD      R5, InpVal5
    LD      R6, InpVal6
    JMP     R7

; Fill statements 
InpVal0
    .BLKW #1
InpVal1
    .BLKW #1
InpVal3
    .BLKW #1
InpVal4
    .BLKW #1
InpVal5
    .BLKW #1
InpVal6
    .BLKW #1
LowerI
    .FILL #-105
LowerJ
    .FILL #-106
LowerK
    .FILL #-107
LowerL
    .FILL #-108
    
;***********************************************************
; SAFE_MOVE
; Input: R0 has 'i','j','k','l'
; Output: R1, R2 have the new row and col if the move is safe
;         If the move is unsafe, that is, the move would 
;         take Simba to a Hyena or outside the Grid then 
;         return R1=-1 
; Notes: Translates user entered move to actual row and column
;        Also checks the contents of the intended space to
;        move to in determining if the move is safe
;        Calls GRID_ADDRESS
;        This subroutine does not check if the input (R0) is 
;        valid. This functionality is implemented elsewhere.
;***********************************************************

SAFE_MOVE      
; Your New (Program4) code goes here

    ST      R0, SafeMv0
    ST      R1, SafeMv1
    ST      R2, SafeMv2
    ST      R3, SafeMv3
    ST      R4, SafeMv4
    ST      R5, SafeMv5
    ST      R6, SafeMv6
    ; finished callee saves
    
    ; before checking hyenas, let's first check if the move would be invalid due to GRID DIMENSIONS
    LD      R1, CurrRow
    LD      R2, CurrCol
    LDR     R1, R1, #0
    LDR     R2, R2, #0
    ; Row 0 & Up Mvmt
    ADD     R1, R1, #0
    BRnp    CheckIfRow7
    LD      R3, LowerI
    ADD     R3, R3, R0
    BRz     INVALID_MOVE
CheckCols
    ADD     R2, R2, #0
    BRnp    CheckIfCol7
    LD      R3, LowerJ
    ADD     R3, R3, R0
    BRz     INVALID_MOVE
    BR      CheckHyenas

CheckIfRow7
    LD      R4, NegSeven
    ADD     R4, R4, R1
    BRnp    CheckCols
    LD      R4, LowerK
    ADD     R4, R4, R0
    BRz     INVALID_MOVE
    BR      CheckCols
CheckIfCol7
    LD      R4, NegSeven
    ADD     R4, R4, R2
    BRnp    CheckHyenas
    LD      R4, LowerL
    ADD     R4, R4, R0
    BRz     INVALID_MOVE
    BR      CheckHyenas

CheckHyenas
    LD      R1, CurrRow
    LD      R2, CurrCol
    LDR     R1, R1, #0
    LDR     R2, R2, #0
    ST      R7, SafeMv7
    JSR     GRID_ADDRESS
    LD      R7, SafeMv7
    AND     R5, R5, #0
    ADD     R5, R0, #0          ; R5 has the grid loc/array loc of the current loc of Simba
    LD      R0, SafeMv0         ; load R0 back with the ASCII char (i, j, k, l)
    ; at this pt, we know that R0 has a valid input char, due to the first subroutine
    ; just need to add implementation for each of the 4 possible inputs
    AND     R4, R4, #0
    LD      R6, LowerI
    ADD     R4, R0, R6
    BRz     MoveUpImplementation
   
    AND     R4, R4, #0
    LD      R6, LowerJ
    ADD     R4, R0, R6
    BRz     MoveLeftImplementation
    
    AND     R4, R4, #0
    LD      R6, LowerK
    ADD     R4, R0, R6
    BRz     MoveDownImplementation
    
MoveRightImplementation
    ADD     R5, R5, #2
    LDR     R6, R5, #0
    LD      R4, HyenaASCII
    ADD     R4, R4, R6
    BRz     INVALID_MOVE
    ADD     R2, R2, #1
    BR      CompletedSafeMove  
MoveUpImplementation
    LD      R4, MoveI
    ADD     R5, R5, R4
    LDR     R6, R5, #0
    LD      R4, HyenaASCII
    ADD     R4, R4, R6
    BRz     INVALID_MOVE
    ADD     R1, R1, #-1
    BR      CompletedSafeMove
MoveLeftImplementation
    ADD     R5, R5, #-2
    LDR     R6, R5, #0
    LD      R4, HyenaASCII
    ADD     R4, R4, R6
    BRz     INVALID_MOVE
    ADD     R2, R2, #-1
    BR      CompletedSafeMove
MoveDownImplementation
    LD      R4, MoveK
    ADD     R5, R5, R4
    LDR     R6, R5, #0
    LD      R4, HyenaASCII
    ADD     R4, R4, R6
    BRz     INVALID_MOVE
    ADD     R1, R1, #1
    BR      CompletedSafeMove

INVALID_MOVE
    AND     R1, R1, #0
    ADD     R1, R1, #-1
    LD      R2, SafeMv2
    BR      SafeMvDone

CompletedSafeMove
    BR      SafeMvDone
SafeMvDone
    LD      R0, SafeMv0
    LD      R3, SafeMv3
    LD      R4, SafeMv4
    LD      R5, SafeMv5
    LD      R6, SafeMv6
    
    JMP R7

SafeMv0
    .BLKW #1
SafeMv1
    .BLKW #1
SafeMv2
    .BLKW #1
SafeMv3
    .BLKW #1
SafeMv4
    .BLKW #1
SafeMv5
    .BLKW #1
SafeMv6
    .BLKW #1
SafeMv7
    .BLKW #1
MoveI
    .FILL #-36
MoveK
    .FILL #36
NegSeven
    .FILL #-7
HyenaASCII
    .FILL x-23
CurrRow
    .FILL   CURRENT_ROW
CurrCol
    .FILL   CURRENT_COL

;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is safe by calling 
; SAFE_MOVE which returns the coordinates of where the move 
; goes (or -1 if movement is unsafe as detailed below). 
; If the move is Safe then this routine moves the player 
; symbol to the new coordinates and clears any walls (|�s and -�s) 
; as necessary for the movement to take place. 
; If the movement is unsafe, output a console message of your 
; choice and return. 
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
; Notes:  Calls SAFE_MOVE and GRID_ADDRESS
;***********************************************************

APPLY_MOVE   
; Your New (Program4) code goes here
    
    ST      R0, AppMv0
    ST      R1, AppMv1
    ST      R2, AppMv2
    ST      R3, AppMv3
    ST      R4, AppMv4
    ST      R5, AppMv5
    ST      R6, AppMv6
    ; finished callee saves
    
    ST      R7, AppMv7
    JSR     SAFE_MOVE
    LD      R7, AppMv7
    ADD     R1, R1, #0
    BRn     FoundUnsafeMv           ; SAFE_MOVE return R1 = -1 when move isn't safe
    ; if it isn't negative, then you know that SAFE_MOVE actually returned a safe row and col to move to
    ; R1 will hold the new row, and R2 will hold the new col
    LD      R3, CurrRow
    LDR     R3, R3, #0      ; R3 has current row num
    LD      R4, CurrCol
    LDR     R4, R4, #0      ; R4 has current col num
    LD      R5, CurrRow
    STR     R1, R5, #0      ; new row num stored in CURRENT_ROW
    LD      R5, CurrCol
    STR     R2, R5, #0      ; new col num stored in CURRENT_COL
    LD      R5, SpaceChar
    AND     R1, R1, #0
    AND     R2, R2, #0
    ADD     R1, R3, #0      ; R1 <-- current row num
    ADD     R2, R4, #0      ; R2 <-- current col num
    ST      R7, AppMv7
    JSR     GRID_ADDRESS
    LD      R7, AppMv7
    STR     R5, R0, #0      ; stores space char in current loc. 
    LD      R5, Asterisk
    LD      R1, CurrRow     
    LDR     R1, R1, #0      ; R1 = new row num
    LD      R2, CurrCol
    LDR     R2, R2, #0      ; R2 = new col num
    ST      R7, AppMv7
    JSR     GRID_ADDRESS
    LD      R7, AppMv7
    AND     R3, R3, #0
    ADD     R3, R0, #0      ; R3 has new array loc.
    STR     R5, R0, #0      ; store asterisk in new array loc
    ; have now:
        ; updated asterisk position
        ; changed CURRENT_ROW & CURRENT_COL
        ; deleted previous asterisk position
    ; still need to get rid of "walls" in way of the path
    LD      R5, SpaceChar
    LD      R0, AppMv0          ; get move char back into R0
    
    AND     R4, R4, #0
    LD      R6, LowerI
    ADD     R4, R0, R6
    BRz     DeleteUp
   
    AND     R4, R4, #0
    LD      R6, LowerJ
    ADD     R4, R0, R6
    BRz     DeleteLeft
    
    AND     R4, R4, #0
    LD      R6, LowerK
    ADD     R4, R0, R6
    BRz     DeleteDown 
; R3 has the array loc of the new loc.
DeleteRight
    ADD     R3, R3, #-1
    STR     R5, R3, #0
    BR      AppMvFinished
DeleteUp
    LD      R4, IMove
    ADD     R3, R4, R3
    STR     R5, R3, #0
    BR      AppMvFinished
DeleteLeft
    ADD     R3, R3, #1
    STR     R5, R3, #0
    BR      AppMvFinished
DeleteDown
    LD      R4, KMove
    ADD     R3, R4, R3
    STR     R5, R3, #0
    BR      AppMvFinished
FoundUnsafeMv
    LD      R0, EnterChar
    OUT
    LEA     R0, UnsafeMessage
    PUTS
    LD      R0, EnterChar
    OUT
    BR      AppMvFinished
    
AppMvFinished
    LD      R0, AppMv0
    LD      R1, AppMv1
    LD      R2, AppMv2
    LD      R3, AppMv3
    LD      R4, AppMv4
    LD      R5, AppMv5
    LD      R6, AppMv6
    JMP     R7

AppMv0
    .BLKW #1
AppMv1
    .BLKW #1
AppMv2
    .BLKW #1
AppMv3
    .BLKW #1
AppMv4
    .BLKW #1
AppMv5
    .BLKW #1
AppMv6
    .BLKW #1
AppMv7
    .BLKW #1
SpaceChar
    .FILL x20
UnsafeMessage
    .STRINGZ "Unsafe Move!!! Try again!"
IMove
    .FILL #18
KMove
    .FILL #-18
EnterChar
    .FILL   xA

;***********************************************************
; IS_SIMBA_HOME
; Checks to see if the Simba has reached Home.
; Input:  None
; Output: R2 is zero if Simba is Home; -1 otherwise
; 
;***********************************************************

IS_SIMBA_HOME     
    ; Your code goes here
    ST      R0, SimbaSv0
    ST      R1, SimbaSv1
    ST      R3, SimbaSv3
    ST      R4, SimbaSv4
    ST      R5, SimbaSv5
    ; finished callee saves
    AND     R2, R2, #0
    LD      R0, CurrRow
    LDR     R0, R0, #0
    NOT     R0, R0
    ADD     R0, R0, #1
    LD      R1, CurrCol
    LDR     R1, R1, #0
    NOT     R1, R1
    ADD     R1, R1, #1
    LD      R3, HmRow
    LDR     R3, R3, #0
    LD      R4, HmCol
    LDR     R4, R4, #0
    AND     R5, R5, #0
    ADD     R5, R0, R3
    BRnp    NOT_HOME
    AND     R5, R5, #0
    ADD     R5, R1, R4
    BRnp    NOT_HOME
    ADD     R2, R2, #0
    BR      Home_Done
    
NOT_HOME
    ADD     R2, R2, #-1
    BR      Home_Done

Home_Done
    LD      R0, SimbaSv0
    LD      R1, SimbaSv1
    LD      R3, SimbaSv3
    LD      R4, SimbaSv4
    LD      R5, SimbaSv5
    JMP R7

SimbaSv0
    .BLKW #1
SimbaSv1
    .BLKW #1
SimbaSv3
    .BLKW #1
SimbaSv4
    .BLKW #1
SimbaSv5
    .BLKW #1
HmRow
    .FILL   HOME_ROW
HmCol
    .FILL   HOME_COL
    
    .END

; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->#(3,5)->#(4,4)->#(5,6)
;	.ORIG	x5000
;	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
;blk2
;	.FILL   blk4
;	.FILL   #1
 ;   .FILL   #1
;	.FILL   x23

;Head
;	.FILL	blk1
 ;   .FILL   #0
;	.FILL   #1
;	.FILL   x23

;blk1
;	.FILL   blk3
;	.FILL   #4
;	.FILL   #7
;	.FILL   x48

;blk3
;	.FILL   blk2
;	.FILL   #2
;	.FILL   #1
;	.FILL   x49

;blk4
;	.FILL   blk5
;	.FILL   #6
;	.FILL   #3
;	.FILL   x23

;blk7
;	.FILL   #0
;	.FILL   #5
;	.FILL   #6
;	.FILL   x23
;blk6
;	.FILL   blk7
;	.FILL   #4
;	.FILL   #4
;	.FILL   x23
;blk5
;	.FILL   blk6
;	.FILL   #3
;	.FILL   #5
;	.FILL   x23
;	.END
    .ORIG x5000
    .FILL x5400
    .END

    .ORIG x5400
    .FILL x8000
    .FILL #5
    .FILL #6
    .FILL x49
    .END

    .ORIG x8000
    .FILL x8400
    .FILL #2
    .FILL #1
    .FILL x48
    .END

    .ORIG x8400
    .FILL x8150
    .FILL #1
    .FILL #5
    .FILL x23
    .END

    .ORIG x8150
    .FILL x8160
    .FILL #0
    .FILL #0
    .FILL x23
    .END

    .ORIG x8160
    .FILL x8200
    .FILL #3
    .FILL #3
    .FILL x23
    .END

    .ORIG x8200
    .FILL x6300
    .FILL #4
    .FILL #3
    .FILL x23
    .END

    .ORIG x6300
    .FILL x7500
    .FILL #6
    .FILL #4
    .FILL x23
    .END

    .ORIG x7500
    .FILL x0
    .FILL #7
    .FILL #7
    .FILL x23
    .END
