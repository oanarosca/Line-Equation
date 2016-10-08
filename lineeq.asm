.STACK 100H
.DATA
	A DB 0  
	B DB 0
	C DB 0    
	AUX DW 0
	MULT DW 19
	MSGA DB "ENTER A: $"
	MSGB DB 0AH, 0DH, "ENTER B: $"
	MSGC DB 0AH, 0DH, "ENTER C: $"
	
.CODE       
	MOV AX, @DATA
	MOV DS, AX
	
	LEA DX, MSGA
	MOV AH, 9
	INT 21H
	MOV AH, 1 ;input
	INT 21H
	MOV A, AL
           
  LEA DX, MSGB
	MOV AH, 9
	INT 21H
	MOV AH, 1 ;input
	INT 21H
	MOV B, AL
	
	LEA DX, MSGC
	MOV AH, 9
	INT 21H
	MOV AH, 1 ;input
	INT 21H
	MOV C, AL       
	         
	MOV AH, 00h ; set video mode
	MOV AL, 12h ; graphics 640x480
  INT 10h
	
	MOV CX, 320 ; column
	MOV DX, 0 ; row
	MOV AX, 0C35h ; AH=0Ch and AL = pixel color   
	
	MOV BX, 12 ; impartitor

	OY:
		INT 10h ; draw pixel
		INC DX 
		CMP DX, 480
		JL OY            
             
  OYUNIT:  
  	FORWARDY:
  		MOV DX, AUX
  		INC DX
  	MOV AUX, DX
  	MOV AX, AUX ; impartit
  	XOR DX, DX
  	DIV BX
  	CMP DX, 0
  	JG 	FORWARDY
  	MOV DX, AUX
  	CALL OYDRAW  
  	CMP DX, 480
  	JL OYUNIT          
                         
  MOV CX, 0
  MOV DX, 240     
       
	OX:
		INT 10h
		INC CX
		CMP CX, 640
		JL OX  
		    
	MOV CX, 0	    
		    
	OXUNIT:
		FORWARDX:
			INC CX
		MOV AX, CX
		XOR DX, DX   
		DIV BX
		CMP DX, 8
		JNE FORWARDX
		CALL OXDRAW
		CMP CX, 640
		JL OXUNIT  
		
	MOV AX, 0C04H     
	MOV CX, 39
	NEG BX
	
	FINDX:
		MOV AX, MULT
		MUL BX
		MOV DX, AX
		mov aux, dx
		ADD DX, 240
		MOV AUX, CX
		MOV CX, 100 
		MOV AX, 0C04H
		INT 10H  
		MOV CX, AUX
		DEC MULT
		LOOP FINDX
	          
	MOV AH, 07h ; wait for key press to exit program
	INT 21h
	
	MOV AX, 4C00H ; Exit to DOS function
	INT 21H   
	
	OYDRAW PROC         	
		MOV AX, 0C35H
		MOV CX, 319
		INT 10H
		MOV CX, 321
		INT 10H 
		RET           
  OYDRAW ENDP
	  
	OXDRAW PROC
		MOV AX, 0C35H
		MOV DX, 239
		INT 10H
		MOV DX, 241
		INT 10H
		RET
	OXDRAW ENDP
END