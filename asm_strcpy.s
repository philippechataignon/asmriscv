# strcpy en assembleur Risc-V,d'après Patterson et Hennessy
    .global main
    .equ    write,64
    .equ    exit,93

    .text

main:
    li   t0,0          # i <- 0+0
    la   a2,origine
    la   a3,destination
L1: add  a0,t0,a2        # adresse de y[i] dans x5
    add  a1,t0,a3        # adresse de x[i] dans x7
    lbu  t1,(a0)        # x6 <- y[i]
    sb   t1,(a1)        # x[i] <- y[i]
    beqz t1,L2        # si caractère NULL,c’est fini
    addi t0,t0,1        # sinon i <- i+1
    j    L1              # on va en L1
L2:
    li   a0,1               # 1 = StdOut
    la   a1,destination     # charger l’adresse
    li   a2,%lo(len)        # longueur de la chaîne
    li   a7,write           # appel système Linux write
    ecall                   # appel Linux écriture de la chaîne

    li   a0,0               # code de retour 0
    li   a7,exit            # le code de commande 93 
    ecall                   # Appel Linux pour finir

    .data

origine:
    .align 2
    .string	"initiations\n"
    .equ    len,. - origine

destination:
    .string "destination\n"	

