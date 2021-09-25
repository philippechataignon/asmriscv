#include "puts.h"

void num_print(long num){
    unsigned int base = 10;
    int sign_bit = 0;

    char string[20];
    char* end = string + 19;
    char* p   = end;
    *p = '\n';

    if (num < 0){
        num = 0 - num;
        sign_bit = 1;
    }

    do {
        *(--p) = (num % base) + '0';
        num /= base;
    } while (num);

    if (sign_bit)
        *(--p) = '-';

    long len = end - p;
    asm_puts(p, len + 1);
}

int main(){
    int arr[3] = {12345678, -12345678, 0};
    for (int i=0; i < 3; i++){
        num_print(arr[i]);
    }
    return 0;
}
