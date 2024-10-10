#!/bin/bash

# Fonction pour afficher la grille avec dialog
display_grid() {
    local display_grid

    # Demande à l'utilisateur de saisir une valeur
    dialog --inputbox "Longueur du plateau de jeu :" 8 40 2>output.txt

    # Récupère la valeur saisie
    grille_x=$(<output.txt)

    # Affiche la valeur saisie dans une boîte de message
    dialog --msgbox "Valeur saisie : $grille_x" 6 40

    # Nettoie le fichier temporaire
    rm -f output.txt

    # Demande à l'utilisateur de saisir une valeur
    dialog --inputbox "Hauteur du plateau de jeu :" 8 40 2>output.txt

    # Récupère la valeur saisie
    grille_y=$(<output.txt)

    # Affiche la valeur saisie dans une boîte de message
    dialog --msgbox "Valeur saisie : $grille_y" 6 40

    # Nettoie le fichier temporaire
    rm -f output.txt

    grille=""
    for((y=0;y<grille_y;y++));do
        grille+="\n${grid[j]} |"
        for((i=1;i<grille_x;i++));do
                grille+="${grid[i]} |"
        done
    done

    dialog --clear --title "Grille de Jeu" --msgbox "$grille" 10 30
    jouer
}

jouer() {
        local jouer
        dialog --inputbox "Sur quel case voulez-vous jouer ?" 8 40 2>output.txt
        i=$(<output.txt)
        dialog --msgbox "Case saisie : $i" 6 40
        rm -f output.txt
        dialog --inputbox "Sur quel case voulez-vous jouer ?" 8 40 2>output.txt
        j=$(<output.txt)
        dialog --msgbox "Case saisie : $j" 6 40
        rm -f output.txt
        grille+=""
        for((y=j;y=j;y++));do
                grille+="\n${grid[y]}█|"
                for((x=i;x=i;x++));do
                        grille+="${grid[i]}█|"
                done
        done
        dialog --clear --title "Grille de Jeu" --msgbox "$grille" 10 30
}

sous_menu2() {
        local sous_menu2
        while true; do
                choix=$(dialog --clear --title "Voulez vous quitter le jeu ?" \
                        --menu " " 17 50 4 \
                        1 "Oui" \
                        2 "Non" \
                        2>&1 >/dev/tty)

                        case $choix in
                        1) dialog --msgbox "Retour au menu principal" 5 40 ; clear
                           menu_principal ;;
                        2) dialog --msgbox "Retour au jeu" 5 40
                           display_grid ;;
                        *) dialog --msgbox "Option invalide" 5 40 ;;
                esac
        done
}

display_grid
sous_menu2
