#    .globl _start
#    .globl asm_strlen
#    .globl asm_print
#    .globl asm_strcpy

    .set    write,64
    .equ    exit,93

#######
    .text
    .align  1
 
start:
    la      a0,dest
    jal     asm_print   
  
    la      a0,src
    la      a1,dest
    jal     asm_strcpy
 
    la      a0,dest
    jal     asm_print    
   
    li      a0,0        # exit code 0
    li      a7,93
    ecall         
 
#####
# fonction asm_strlen : calcule la longueur d'une chaine
#  a0 : pointeur sur le début chaine
#  a0 : retour longueur chaine
asm_strlen:
    li      t0,-1            # i <- -1
L1:
    lbu     t2,0(a0)         # caractère courant
    addi    a0,a0,1          # pointer sur le caractÃ¨re suivan
    addi    t0,t0,1          # i++ 
    bnez    t2,L1          # si char non nul = encore
    mv      a0,t0            # renvoit i=len dans a0
    ret

#####
# fonction asm_print : affiche une chaine
#  a0 : pointeur sur la chaine
asm_print:
    addi    sp,sp,-8     # cree 2 x 32 bits dans pile
    sw      ra,0(sp)      # sauvegarde ra sur la pile
    sw      a0,4(sp)      # sauvegarde a0 utilise pour asm_strlen
    jal     asm_strlen    # fonction de calcul de la longueur
    mv      a2,a0         # longueur copiee de a0 dans a2
    li      a0,1          # 1 = StdOut
    lw      a1,4(sp)      # ptr chaine
    li      a7,64      # appel système Linux write
    ecall                 # appel Linux écriture de la chaÃ®ne
    lw      ra,0(sp)      # restauration de ra depuis la pile
    addi    sp,sp,8      # remet la pile
    li      a0,0          # renvoit 0 
    ret
 
#####
# fonction asm_strcopy : copie une chaÃ®ne
#  a0 : pointeur sur la source
#  a1 : pointeur sur la destination
asm_strcpy:
L2:
    lbu     t0,(a0)       # t0 <- origine[i]
    sb      t0,(a1)       # destination[i] <- t0
    beqz    t0,L3         # si octet nul -> fin
    addi    a0,a0,1       # caractère suivant
    addi    a1,a1,1       
    j       L2
L3:
    li      a0,0          # renvoit 0 
    ret

#######
    .data
    .align  3
src:    
    .string    "chainesource\n"
dest:
    .string    "abcdefghijklmn\n"

