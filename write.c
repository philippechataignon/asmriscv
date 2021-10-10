#include <stdio.h>
char* str = "Hello World!\n";
int main(){
    fwrite(str,13,1,stdout);
    return 0;
}
