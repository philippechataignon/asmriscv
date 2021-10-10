int search(char* target, char* buffer, char* dico[], int len) {
    int found = -1;
    int n = 0;
    int i,j;
    while(target[n++]);
    for(i = 0; i < len; i++) {
        for(j = 0; j < n; j++) {
            if (target[j] != dico[i][j])
                break;
        }
        if (j == n) {
            found = i;
            break;
        }
    }
    return found;
}
