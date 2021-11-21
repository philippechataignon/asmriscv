#include <stdlib.h>

int asm_strlen(char*);
int asm_print(char*);
int asm_strcpy(char*, char*);

int main()
{
    char* str = "Essai de copie d'une chaîne\n";
    char* dest = (char*) malloc(256);
    asm_strcpy(str, dest);
    asm_print(dest);
    free(dest);
    return 0;
}
