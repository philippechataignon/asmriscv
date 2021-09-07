# strcpy en assembleur Risc-V, d’après Patterson et Hennessy
#

.globl strcpy  # adresse de démarrage du programme pour l’éditeur de liens

strcpy:
    addi sp, sp, -4   # accroît la pile pour un nouvel élément
    sw   x19, 0(sp)   # sauvegarde x19
    add  x19, x0, x0  # i <- 0+0
    la   x10, destination
    la   x11, origine
L1: add  x5, x19, x11 # adresse de y[i] dans x5
    lbu  x6, 0(x5)    # x6 <- y[i]
    add  x7, x19, x10 # adresse de x[i] dans x7
    sb   x6, 0(x7)    # x[i] <- y[i]
    beq  x6, x0, L2   # si caractère NULL, c’est fini
    addi x19, x19, 1  # sinon i <- i+1
    jal  x0, L1       # on va à L1
L2: lw   x19, 0(sp)   # restauration de x19
    addi sp, sp, 4    # étête la pile d’un mot
    addi a0, x0, 1    # 1 = StdOut
    la   a1, destination # charger l’adresse
    addi a2, x0, 12   # longueur de la chaîne
    addi a7, x0, 64   # appel système Linux write
    ecall             # appel Linux écriture de la chaîne

    addi a0, x0, 0    # code de retour 0
    addi a7, x0, 93   # le code de commande 93 
    ecall             # Appel Linux pour finir

.data

destination:	.string "destination\n"	

origine:	.string	"initiations\n"
