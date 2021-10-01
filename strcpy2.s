#   .globl _start
    .globl asm_strlen
    .globl asm_print
    .globl asm_strcpy

    .text
 
#_start:
#    la     a0,dest
#    jal    asm_print   
   
#    la     a0,src
#    la     a1,dest
#    jal    asm_strcpy
## 
##    la     a0,dest
##    jal    asm_print    
##   
#    li     a0,0    
#    li     a7,93  
#    ecall         
 
#####
# fonction asm_strlen : calcule la longueur d' chaîe
#  a0 : pointeur sur le début de la chaîne
#  a0 : renvoyé avec la longueu
asm_strlen:
    li      t0,-1            # a2 <- -1
loop:
    lbu     t2,0(a0)         # caractère courant
    addi    a0,a0,1         # un caractère de plus
    addi    t0,t0,1         # pointer sur le caractère suivant
    bnez    t2,loop          # encore ?
    mv      a0,t0            # renvoit len
    ret

#####
# fonction asm_print : affiche une chaîne
#  a0 : pointeur sur la chaîne
asm_print:
    addi    sp,sp,-16     # cree 2 x 64 bits dans pile
    sd      ra,0(sp)      # sauvegarde ra sur la pile
    sd      a0,8(sp)      # sauvegarde a0 utilis� retour asm_strlen
    jal     asm_strlen    # fonction de calcul de la longueur
    mv      a2,a0         # longueur dans a2
    li      a0,1          # 1 = StdOut
    ld      a1,8(sp)      # ptr chaine
    li      a7,64         # appel système Linux write
    ecall                 # appel Linux écriture de la chaîne
    ld      ra,0(sp)      # restauration de ra depuis la pile
    addi    sp,sp,16      # remet la pile
    li      a0,0          # renvoit 0 
    ret
 
#####
# fonction asm_strcopy : copie une chaîne
#  a0 : pointeur sur la chaînesource
#  a1 : pointeur sur la chaîn destination
asm_strcpy:
L1:
    lbu     t0,(a0)       # t0 <- origine[i]
    sb      t0,(a1)       # destination[i] <- t0
    beqz    t0,L2         # si octet nul -> fin
    addi    a0,a0,1       # caract�re suivant
    addi    a1,a1,1       #
    j       L1
L2:
    li      a0,0          # renvoit 0 
    ret

#######

.data
src:    .string    "source"
dest:    .string    "abcdefghijklmn"
