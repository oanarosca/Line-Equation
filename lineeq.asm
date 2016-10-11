.STACK 100H
.DATA
	A DW 1  
	B DW 2
	C DW 1         
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
	          	          
	;LEA DX, MSGA
	;MOV AH, 9
	;INT 21H
	;MOV AH, 1 ;input
	;INT 21H  
	;SUB AX, '0'
	;MOV A, AX
             
  CALL DEFINECOUNT
             
  ;LEA DX, MSGB
	;MOV AH, 9
	;INT 21H
	;MOV AH, 1 ;input
	;INT 21H  
	;SUB AX, '0'
	;MOV B, AX
	
	;LEA DX, MSGC
	;MOV AH, 9
	;INT 21H
	;MOV AH, 1 ;input
	;INT 21H
	;SUB AX, '0'
	;MOV C, AX       
	         
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
     
  MOV DX, 0   
             
  OYUNIT:  
  	CALL OYDRAW
  	ADD DX, 12
  	CMP DX, 480
  	JL OYUNIT          
                         
  MOV CX, 0
  MOV DX, 240     
       
	OX:
		INT 10h
		INC CX
		CMP CX, 640
		JL OX  
		    
	MOV CX, 8	    
	
	OXUNIT:
		CALL OXDRAW
		ADD CX, 12
		CMP CX, 640
		JL OXUNIT
		
	MOV AX, 0C04H     
	MOV CX, AUX
	    
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
	
	MOV AX, 4C00H ; Exit to DOS function
	INT 21H  
	  
	DRAW PROC
		CMP X, 0
		JL EXIT    
		CMP X, 640
		JG EXIT
		MOV AX, 0C04H
		INT 10H
		RET
		EXIT:
			RET
	DRAW ENDP  
	  	
	DEFINECOUNT PROC
		CMP A, 0
		JE ZERO
		MOV COUNT, 19
		MOV AUX, 39
		RET          
		ZERO:
			MOV COUNT, 26
			MOV AUX, 53
			RET
	DEFINECOUNT ENDP
	
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
	
	FINDY PROC  
		CMP A, 0
		JE YZERO
		MOV AX, COUNT
		MUL BX 
		ADD AX, 240
		MOV Y, AX
		RET
		YZERO:
			MOV AX, C
			MOV BX, 12
			MUL BX
			MOV BX, B
			XOR DX, DX
			DIV BX   
			MOV BX, 12
			ADD AX, 240
			MOV Y, AX
			RET
	FINDY ENDP
	
	FINDX PROC 
		MOV AX, COUNT
		CMP A, 0
		JE XZERO
		MOV AX, COUNT
		MOV BX, B
		MUL BX
		ADD AX, C  
		MOV BX, 12
		MUL BX
		XOR DX, DX
		MOV BX, A
		DIV BX 
		MOV BX, 12
		NEG AX 
		ADD AX, 320
		MOV X, AX
		RET
		XZERO:
			MOV BX, 12
			MUL BX
			ADD AX, 320
			MOV X, AX
			RET
	FINDX ENDP
END