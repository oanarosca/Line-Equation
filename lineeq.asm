.STACK 100H
.DATA
	A DW 1  
	B DW 1
	C DW 0         
	X DW 0
	Y DW 0
	AUX DW 0
	COUNT DW 19
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
	    
	DRAWLINE:
		MOV AUX, CX
		NEG BX
		CALL FINDY
		NEG BX
		CALL FINDX
		MOV DX, Y
		MOV CX, X
		MOV AX, 0C04H
		INT 10H  
		MOV CX, AUX
		DEC COUNT
		LOOP DRAWLINE
	          
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
	
	FINDY PROC
		MOV AX, COUNT
		MUL BX
		MOV Y, AX
		ADD Y, 240
		RET
	FINDY ENDP
	
	FINDX PROC
		MOV AX, COUNT
		MOV BX, B
		MUL BX
		ADD AX, C
		MOV BX, A
		DIV BX   
		NEG AX
		MOV BX, 12
		MUL BX
		ADD AX, 320
		MOV X, AX
		RET
	FINDX ENDP
END