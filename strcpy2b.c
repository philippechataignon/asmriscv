int asm_strlen(char*);
int asm_print(char*);
int asm_strcpy(char*, char*);
char* src="source";
char* dest="aaaaaa";

int _start()
{
//    asm_strcpy(src, dest);
    asm_print(src);
    return 0;
}
