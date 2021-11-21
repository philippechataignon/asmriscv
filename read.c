#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define nbword 400000
#define lenword 16

int search(char* target, char* dico[], int len) {
    int found = -1;
    char* *p;
    char* q;
    char* r;        // current buffer char
    for(p = dico; p < dico + len; p++) {
        for(q = target, r = *p; *q && *r && *q == *r; ++q, ++r); // while same non zero char in target
        if (*q == 0 && *r == 0) {
            found = p - dico;
            break;
        }
    }
    return found;
}

int
main(int argc, char *argv[])
{
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    ssize_t nread;

    char* buffer = malloc(nbword * lenword);
    char* p = buffer;
    char* dico[nbword];

    int totword = 0;
    int bytes = 0;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    bytes = fread(buffer, 1, nbword * lenword, fp);
    printf("Total bytes: %d\n", bytes);
    fclose(fp);

    totword = 0;
    char end = 1;
    for(p = buffer; p < buffer + bytes; p++) {
        if (end) {
            dico[totword++] = p;
            end = 0;
        }
        if (*p == '\n') {
            *p = '\0';
            end = 1;
        }
    }
    printf("Total words: %d\n", totword);

    printf("%d\n", search("pipo", dico, totword));
    printf("%d\n", search("qslkjdqslkjd", dico, totword));
    printf("%d\n", search("constitution", dico, totword));
    printf("%d\n", search("zythums", dico, totword));
    printf("%d\n", search("aa", dico, totword));

    free(buffer);
    exit(EXIT_SUCCESS);
}

