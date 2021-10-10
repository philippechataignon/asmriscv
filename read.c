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
        if (*q == 0 && *q == *r) {
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

    int i = 0;
    int totword = 0;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    fp = fopen(argv[1], "r");
    if (fp == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    i = 0;
    while ((nread = getline(&line, &len, fp)) != EOF) {
        if (line[nread - 1] == '\n') {
            line[nread - 1] = '\0';
            nread -= 1;
        }
        strncpy(p, line, nread + 1);
        dico[i++] = p;
        p += nread + 1;
    }
    totword = i;
    printf("Total word: %d\n", totword);
    free(line);
    fclose(fp);

    // for(i = 0; i < totword; i++) {
    //     printf("%d %p %s\n", i, dico[i], dico[i]);
    // }

    printf("%d\n", search("pipo", dico, totword));
    printf("%d\n", search("qslkjdqslkjd", dico, totword));
    printf("%d\n", search("constitution", dico, totword));
    printf("%d\n", search("zythums", dico, totword));
    printf("%d\n", search("aa", dico, totword));

    free(buffer);
    exit(EXIT_SUCCESS);
}

