; Encrypts a string using a Caesar cipher.
; CSC 225, Assignment 3

            .ORIG x3000
            
            ; clear all registers before startings 
            AND R0, R0, #0 
            AND R1, R1, #0 
            AND R2, R2, #0 
            AND R3, R3, #0 
            AND R4, R4, #0 
            AND R5, R5, #0 
            AND R6, R6, #0 
            AND R7, R7, #0 

            ; Prompt for the key.
            LEA R0, KEY_PROMPT  ; Load the prompt.
            LD  R1, NEW_OFFSET  ; Load a "negative newline" into R1.
            PUTS                ; Print the prompt.

            ; Read the encryption key from the keyboard, echo it, and
            ; convert it into an integer. Save the encryption key in R3.
WHILE       GETC                ; While the user types characters...
            OUT                 ; ...echo the character...
            ADD R4, R0, R1      ; ...and the character...
            BRz NEWLINE         ; ...is not the newline...
			    ADD R3, R0, #-15    ; ...put R0 in R3, subtract 15... 
			    ADD R3, R3, #-15 
			    ADD R3, R3, #-15 
			    ADD R3, R3, #-3     ; ...keep subtracting until reached -48 (48 is the ASCII for 0)... 
			    BRnzp WHILE         ; ...loop back 
			
            AND R1, R1, #0      ; clear R1 
            AND R4, R4, #0      ; clear R4 
            
            ; Prompt for the string.
NEWLINE     LEA R0, STR_PROMPT  ; Load the prompt.
            LD  R1, NEW_OFFSET  ; Load a "negative newline" into R1.
            LEA R2, STRING      ; Load the address of the string into R2.
            PUTS                ; Print the prompt.

            ; Get and encrypt the string.
LOOP        GETC                ; While the user types characters...
            OUT                 ; ...echo the character...
            ADD R4, R0, R1      ; ...and the character...
                BRz DONE            ; ...is not the newline...

            
                ;Apply the encryption key, which is in R3, to the character,
                ;which is in R0. Replace unprintable characters with '?'.
                AND R5, R5, #0      ; ...clear R5... 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #15 
                ADD R5, R5, #8      ; ...add until 128 is reached... 
            
                ADD R0, R0, R3      ; ...apply the encryption key... 
            
                NOT R6, R0         
                ADD R6, R6, #1      ; ...negate R6 and store in R6... 
            
                ADD R5, R5, R6      ; ...128 - R6... 
                BRp OFFSET          ; ...if R0 - 128 > 0 then its a valid character... 
                    AND R0, R0, #0      ; ...clear R0... 
                    ADD R0, R0, #15
                    ADD R0, R0, #15
                    ADD R0, R0, #15
                    ADD R0, R0, #15
                    ADD R0, R0, #3      ; ...add until R0 == 63, the ASCII value of '?'... 

OFFSET      STR R0, R2, #0      ; ...store the character...
            ADD R2, R2, #1      ; ...increment the address...
            BRnzp LOOP          ; ...loop back.

            ; Print the result.
DONE        AND R4, R4, #0      ; Get the null char.
            STR R4, R2, #0      ; Store the null char.
            
            LEA R0, RES_PROMPT  ; Load the prompt.
            PUTS                ; Print the prompt.
            LEA R0, STRING      ; Load the string.
            PUTS                ; Print the string.
            
            HALT                ; Halt.
			

NEW_OFFSET  .FILL x-0A
KEY_PROMPT  .STRINGZ "Encryption key (0-9): "
STR_PROMPT  .STRINGZ "Unencrypted string: "
RES_PROMPT  .STRINGZ "Encrypted string: "
STRING      .BLKW #33
            .END
