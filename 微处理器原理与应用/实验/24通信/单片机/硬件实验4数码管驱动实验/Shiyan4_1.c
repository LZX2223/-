#include <reg52.h>

code unsigned char dis_code[] = {
    0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90, 0xff
};


void Delay_ms(unsigned int ms) {
    unsigned int i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 120; j++); 
    }
}

void main() {
    unsigned char i;  
    unsigned char pos_code[] = {
        0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80
    };

    while (1) {
        
        for (i = 0; i < 8; i++) {
              
            P0 = 0xFF; 
            P2 = pos_code[i];      
            P0 = dis_code[i + 1];         
            Delay_ms(1); 
        }
    }
}