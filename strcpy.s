# strcpy en assembleur Risc-V,d'après Patterson et Hennessy
#

    .global strcpy  # adresse de démarrage du programme pour 'editeur de liens
    .equ    write,64
    .equ    exit,93

    .text

strcpy:
    li   t0,0          # i <- 0+0
    la   x10,destination
    la   x11,origine
L1: add  x5,t0,x11     # adresse de y[i] dans x5
    lbu  x6,0(x5)       # x6 <- y[i]
    add  x7,t0,x10     # adresse de x[i] dans x7
    sb   x6,0(x7)       # x[i] <- y[i]
    beq  x6,x0,L2       # si caractère NULL,c’est fini
    addi t0,x19,1      # sinon i <- i+1
    j    L1             # on va en L1
L2: lw   t0,0(sp)      # restauration de x19
    addi sp,sp,4        # étête la pile d’un mot
    addi a0,x0,1        # 1 = StdOut
    la   a1,destination # charger l’adresse
    li   a2,%lo(len)       # longueur de la chaîne
    li   a7,write       # appel système Linux write
    ecall               # appel Linux écriture de la chaîne

    li   a0,0           # code de retour 0
    li   a7,exit       # le code de commande 93 
    ecall             # Appel Linux pour finir

    .data

destination:
    .string "destination\n"	

origine:
    .string	"initiations\n"
    .equ    len,. - origine
