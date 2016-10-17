.STACK 100H
.DATA
	A DW 0  
	B DW 0
	C DW 0         
	X DW 0
	Y DW 0
	AUX DW 0
	COUNT DW 0
	MSGA DB "ENTER A: $"
	MSGB DB 0AH, 0DH, "ENTER B: $"
	MSGC DB 0AH, 0DH, "ENTER C: $"
	
.CODE       
	MOV AX, @DATA
	MOV DS, AX
	          	          
	LEA DX, MSGA
	MOV AH, 9
	INT 21H
	MOV AH, 1 ; input
	INT 21H  
	SUB AL, '0'
	CBW ;convert byte to word
	MOV A, AX
             
  CALL DEFINECOUNT
             
  LEA DX, MSGB
	MOV AH, 9
	INT 21H
	MOV AH, 1
	INT 21H  
	SUB AL, '0'
	CBW
	MOV B, AX
	
	LEA DX, MSGC
	MOV AH, 9
	INT 21H
	MOV AH, 1
	INT 21H
	SUB AL, '0'
	CBW
	MOV C, AX       
	         
	MOV AH, 00h ; set video mode
	MOV AL, 12h ; graphics 640x480
  INT 10h
	
	MOV CX, 320 ; column
	MOV DX, 0 ; row
	MOV AX, 0C35h ; AH=0Ch and AL = pixel color   
	
	MOV BX, 12 ; impartitor

	OY: ; draw OY axis
		INT 10h ; draw pixel
		INC DX 
		CMP DX, 480
		JL OY            
     
  MOV DX, 0   
             
  OYUNIT: ; draw units on the OY axis 
  	CALL OYDRAW
  	ADD DX, 10
  	CMP DX, 480
  	JL OYUNIT          
                         
  MOV CX, 0
  MOV DX, 240     
       
	OX: ; draw OX axis
		INT 10h
		INC CX
		CMP CX, 640
		JL OX  
	      
	MOV CX, 0      
	      
	OXUNIT: ; draw units on the OX axis
		CALL OXDRAW
		ADD CX, 10
		CMP CX, 640
		JL OXUNIT
		
	MOV AX, 0C04H     
	MOV CX, AUX
	
	; formulas (one unit consists of 12px) v1.0:
	; on the y-axis: 240-12*y
	; on the x-axis: 320+12*x
	    
	DRAWLINE:
		MOV AUX, CX
		NEG BX
		CALL FINDY
		NEG BX
		CALL FINDX
		MOV DX, Y
		MOV CX, X
		CALL DRAW
		MOV CX, AUX
		DEC COUNT
		LOOP DRAWLINE
	          
	MOV AH, 07h ; wait for key press to exit program
	INT 21h
	
	MOV AX, 4C00H ; exit to DOS function
	INT 21H   
	
	EXIT:
		RET
	  
	DRAW PROC ; checks whether the x coordinate is within [0, 640] or not, and then draws the point if not out of range
		CMP X, 0
		JL EXIT    
		CMP X, 640
		JG EXIT
		MOV AX, 0C04H
		INT 10H
		RET
	DRAW ENDP  
	  	
	DEFINECOUNT PROC ; defines the count and aux variables depending on the value of A
		CMP A, 0
		JE ZERO
		MOV COUNT, 240
		MOV AUX, 481
		RET          
		ZERO:
			MOV COUNT, 320
			MOV AUX, 641
			RET
	DEFINECOUNT ENDP
	
	OYDRAW PROC ; draws OY units        	
		MOV AX, 0C35H
		MOV CX, 319
		INT 10H
		MOV CX, 321
		INT 10H 
		RET           
  OYDRAW ENDP
	  
	OXDRAW PROC ; draws OX units
		MOV AX, 0C35H
		MOV DX, 239
		INT 10H
		MOV DX, 241
		INT 10H
		RET
	OXDRAW ENDP 
	
	FINDY PROC  
		CMP A, 0
		JE YZERO
		MOV AX, COUNT
		NEG AX
		ADD AX, 240
		MOV Y, AX
		RET
		YZERO: ; in case A=0, y is uniquely determined
			MOV AX, C
			MOV BX, B
			XOR DX, DX
			DIV BX   
			MOV BX, 12
			ADD AX, 240
			MOV Y, AX
			RET
	FINDY ENDP
	         
	; the formula for x: (-c-b*y)/a 
	 
	FINDX PROC 
		MOV AX, COUNT
		CMP A, 0
		JE XZERO
		MOV AX, COUNT
		MOV BX, B
		MUL BX
		ADD AX, C 
		CALL MINUS
		XOR DX, DX
		MOV BX, A
		DIV BX 
		MOV BX, 12 
		CALL MINUS
		ADD AX, 320
		MOV X, AX
		RET
		XZERO:
			ADD AX, 320
			MOV X, AX
			RET 
	FINDX ENDP  
	
	MINUS PROC ; NEGs the BX register
		CMP COUNT, -1
		JG ELSE
		CMP BX, 12
		JE ELSE
		NEG AX
		RET
		ELSE:  ; if count > 0 or bx != 12
			CMP COUNT, 0
			JL EXIT
			CMP BX, 12
			JNE EXIT
			NEG AX
			JMP EXIT
	MINUS ENDP
END