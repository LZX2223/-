ORG 0000H
    AJMP MAIN         
ORG 0030H
    MAIN:
        MOV 30H,#66H    
        MOV A, 30H     
        MOV B, #64H     

        DIV AB       
        MOV 32H,A    
        MOV A,B       
        MOV B,#0AH      
        DIV AB         
        
        MOV R1,#04H     
    LOOP:
        RLC A        
        DJNZ R1,LOOP    

        SJMP PLACE    

    PLACE:        
        ANL A,#0F0H     
        ORL A,B      
        MOV 31H,A       
    END             