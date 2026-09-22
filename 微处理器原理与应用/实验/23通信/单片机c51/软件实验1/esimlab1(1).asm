ORG 0000H  ;设置程序起始地址
   AJMP MAIN 
   ORG 0030H  
MAIN:       
   MOV SP,#60H  
   MOV A,#0H    
   MOV R1,#30H 
   MOV R7,#10H  
LOOP1:        
   MOV @R1,A  
   INC R1       
   DJNZ R7,LOOP1  
   NOP           
   MOV R1,#30H   
   MOV R7,#10H  
LOOP:            
   MOV @R1,A    
   INC R1         
   INC A      
   DJNZ R7,LOOP 
   SJMP $     
END   