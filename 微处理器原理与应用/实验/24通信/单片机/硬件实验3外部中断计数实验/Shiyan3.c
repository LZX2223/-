#include <reg52.h>  

sbit key = P3^2; 
unsigned int count = 0; 
unsigned char code led_table[] = {0xc0,0xf9,0xa4,0xb0, 0x99,0x92,0x82,0xf8,0x80,0x90};

int a[4]= {0x00,0x00,0x00,0x00}; 


void delay(unsigned int t) {
    unsigned int i, j;
    for (i = 0; i < t; i++) {
        for (j = 0; j < 10; j++); 
    }
}


void external_interrupt() interrupt 0 {
    unsigned int i, j;
    EX0 = 0; 

    if (count > 9999) {
        count = 0;
    }
    count++; 
    j = 10000; 

    for (i = 0; i < 4; i++) {
        a[i] = count % j; 
        j = j / 10;       
        a[i] = a[i] / j;  
    }
    
    EX0 = 1; 
}


void main() {
    unsigned int i;
    
    IT0 = 1;
    EX0 = 1; 
    EA = 1;  

    while (1) {
        for (i = 0; i < 4; i++) {
            P1 = 0x00; 
            P0 = led_table[a[i]]; 
            P1 = (1 << i); 
            delay(10); 
        }
    }
}