; Programming Assignment 2
; Student Name: _____________
; UT Eid: ____________
; Linked List creation from array. Insertion into the list
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6000, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x5FFF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x5FFF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.

	.ORIG	x3000
; Your code goes here

    ; Initialize all registers first 
    AND     R0, R0, #0      
    AND     R1, R1, #0      
    AND     R2, R2, #0      
    AND     R3, R3, #0      
    AND     R4, R4, #0      
    AND     R5, R5, #0      
    AND     R6, R6, #0      
    AND     R7, R7, #0      
    
    ; Let's find the number of elements that are in the array first
    LD      R0, Records     ; loads the location of the array in R0
CountAgain
    LDR     R1, R0, #0      ; loads first array element in R1 (scores come before name)
    BRn     CountDone       ; if the sentinel is reached, you're done counting; else continue to iterate and find the num of elements
    ADD     R2, R2, #1      ; increment R2 as it acts as the counter variable
    ADD     R0, R0, #2      ; increment R1 (score location) by 2 since we skip over the name because score+name make up one array element
    BR      CountAgain      ; go back and repeat the process to count the number of elements
CountDone

    ; now that the counting process is done, we know how many elements are in the array
    ; we can know begin the sorting process (I will use the bubble sort algorithm)
    ; before we begin, we can recognize that if there are 0 elements in the array, we don't have to do the process that follows
    ; therefore, if the counter variable (R2) has a value of 0, we can just skip to the end
    
    ADD     R2, R2, #0      ; adding 0 to R2 to generate the correct NZP bits
    BRz     Finish          ; if R2 is 0, there are no elements in the array...can just proceed to finish
    ADD     R2, R2, #1
    
    ; At this moment, we can begin the sort
    ; I've implemented bubble sort algorithms in higher level of languages like Java
    ; in those languages, there is a nested for-loop in play
    ; within the nested for-loop, the swapping of the two values occurs
    ; therefore, we need two loops occuring in our code, one that loops (R2 - 1) times, and another inner loop that loops per each element in the array
    ; within the inner loop is where we will write the code to swap the array elements --> we'll prob have to use 2 registers to hold the temp. values
    ; Let's Begin to Sort!

LoopOne
    LD      R0, Records      
    ADD     R2, R2, #-1      
    BRnz    Finish 
    ADD     R3, R2, #0      ;  we need another register to keep track of the iterations for the inner loop, while R2 does the outer loop
LoopTwo
    ; At this point, R0 holds the address of the array (x3500)
    ; to achieve bubble sort, we need to be able to compare the current score with the next score
    ; let's have R1 hold the CURRENT score and R4 hold the NEXT score
    LDR     R1, R0, #0      ; CURRENT score stored in             R1
    LDR     R6, R0, #1      ; CURRENT string location stored in   R6
    LDR     R4, R0, #2      ; NEXT score stored in                R4
    LDR     R7, R0, #3      ; NEXT string location stored in      R7
    
    ; Since we are sorting in decreasing order, we want the smallest values at the bottom, and the larger values on top
    ; we should attempt to move the smallest value to the right in the first iteration, second smallest in the second iteration, etc.
    ; therefore we should check to see if the NEXT score is greater than the CURRENT score
    ; if so, we will swap the values... if not, then we will keep them the same & move to the next element (iterate again if necessary)
    
    NOT     R5, R4          ; swap the value in R4
    ADD     R5, R5, #1      ; swap the value in R4
    ADD     R5, R5, R1      ; add the the negative NEXT score & the positive CURRENT score
    BRzp    NoSwap          ; only if the outcome is negative, we know that the NEXT score is larger than the CURRENT & need to swap
    STR     R4, R0, #0      ; NEXT score put in CURRENT score location
    STR     R7, R0, #1      ; NEXT name put in CURRENT name location
    STR     R1, R0, #2      ; CURRENT score put in NEXT score location
    STR     R6, R0, #3      ; CURRENT name put in NEXT name location
NoSwap
    ADD     R0, R0, #2      ; increment the array pointer by 2 (points to the next score to compare in the next iteration)
    ADD     R3, R3, #-1     ; decrement the loop counter to signify that we have incremented once (to avoid infinite loop)
    BRp     LoopTwo         ; as long as the inner loop counter is still positive, we can loop again
    BR      LoopOne         ; once inner loop is finished, we go back and do the next outer loop iteration and go through process again
Finish   

    ; At this point, the array has been sorted!
    ; We can now move on to Task 2 of the assignment!
    
    LD      R0, Lookup      ; memory location of name
    LD      R1, Records     ; memory location of array
NextName
    LDR     R2, R1, #1      ; location of name in array
    LDR     R6, R1, #0      ; location of that specific name's grade
    BRn     NeverFound
NextLetter
    LDR     R5, R2, #0      ; character of name in array
    LDR     R3, R0, #0      ; character of name
    BRz     CheckName       ; if sentinel for string array has been reached, you have likely found a name ---> need to check edge case
    NOT     R4, R5          ; swap value of R5
    ADD     R4, R4, #1      ; swap value of R5
    ADD     R4, R4, R3      ; check to see if the two characters match
    BRz     IfZero          ; if they do match, continue and check next letter... if not, then you can move on to the next name
    ADD     R1, R1, #2      ; prep for next iteration
    LD      R0, Lookup  ; TEST
    BR      NextName
IfZero
    ADD     R2, R2, #1      ; prep for next iteration
    ADD     R0, R0, #1      ; prep for next iteration
    BR      NextLetter
CheckName
    ADD     R5, R5, #0
    BRz     Found
    ADD     R1, R1, #2      ; prep for next iteration since the name violates the edge case
    LD      R0, Lookup; TEST
    BR      NextName
    
NeverFound                  ; since no name was found, store -1 to x5FFF
    LD      R0, Lookup
    AND     R7, R7, #0
    ADD     R7, R7, #-1
    STR     R7, R0, #-1
    BR      Complete

Found                       ; since a name was found, store the grade of that student to x5FFF
    LD      R0, Lookup
    STR     R6, R0, #-1
    
Complete
	TRAP	x25             ; HALT
	
; Your .FILLs go here
Records
    .FILL   x3500           
Lookup
    .FILL   x6000           
	.END                   

; Student records are at x3500
    .ORIG x3500
    .FILL #85     ; [score]
    .FILL x4000   ; Steven
    .FILL #91     ; [score]
    .FILL x4100   ; John
    .FILL #97     ; [score]
    .FILL x4200   ; Ming
    .FILL #88     ; [score]
    .FILL x4300   ; Mihiri
    .FILL #67     ; [score]
    .FILL x4400   ; David
    .FILL #79     ; [score]
    .FILL x4500   ; Hannah
    .FILL #61     ; [score]
    .FILL x4600   ; Ishan
    .FILL #37     ; [score]
    .FILL x4700   ; Karta
    .FILL #58     ; [score]
    .FILL x4800   ; Huy
    .FILL #31     ; [score]
    .FILL x4900   ; Sue
    .FILL #-1
    .END

.ORIG x4000
.STRINGZ "Steven"
.END

.ORIG x4100
.STRINGZ "John"
.END

.ORIG x4200
.STRINGZ "Ming"
.END

.ORIG x4300
.STRINGZ "Mihiri"
.END

.ORIG x4400
.STRINGZ "David"
.END

.ORIG x4500
.STRINGZ "Hannah"
.END

.ORIG x4600
.STRINGZ "Ishan"
.END

.ORIG x4700
.STRINGZ "Karta"
.END

.ORIG x4800
.STRINGZ "Huy"
.END

.ORIG x4900
.STRINGZ "Sue"
.END

; Person to Lookup	
	.ORIG   x6000
;       The following lookup should give score of 
	.STRINGZ  "Mihiri"
;       The following lookup should give score of
;	.STRINGZ  "Bat Man"
;       The following lookup should give score of -1 because Bat man is 
;           spelled with lowercase m; There is no student with that name 
;	.STRINGZ  "Bat man"
;   .STRINGZ  "Wonder Woman" ; --> should give 65
;   .STRINGZ  "Wonder woman" ; --> should give -1
;   .STRINGZ  "Joel" ; --> should give -1
;   .STRINGZ  "Jo" ; --> should give -1
;   .STRINGZ "Programming is Funn" ; --> should give -1
;   .STRINGZ "Keshav"  ; --> should give 98
	.END
	
