#!/bin/bash

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

# Fonction pour afficher la grille avec dialog
display_grid() {
    local display_grid

    grille="-"
    # Boucle pour initialiser la limite haute de la grille
    for((z=0;z<grille_x;z++));do
        grille+="--"
    done
    # Boucle pour afficher les lignes de la grille
    for((y=0;y<grille_y;y++));do
        grille+="\n| |"
        # Boucle pour afficher les colonnes de la grille
        for((i=1;i<grille_x;i++));do
                grille+=" |"
        done
        grille+="\n-"
        # Boucle pour afficher la séparation entre chaque ligne
        for((z=0;z<grille_x;z++));do
                grille+="--"
        done
    done

    dialog --clear --title "Grille de Jeu" --msgbox "$grille" 30 30
    jouer
}

jouer() {
        local jouer
        dialog --inputbox "Sur quel ligne voulez-vous jouer ?" 8 40 2>output.txt
        ligne=$(<output.txt)
        dialog --msgbox "Case saisie : $ligne" 6 40
        # Soustrait -1 car c'est un tableau
        ((ligne--))
        rm -f output.txt
        dialog --inputbox "Sur quel colonne voulez-vous jouer ?" 8 40 2>output.txt
        colonne=$(<output.txt)
        dialog --msgbox "Case saisie : $colonne" 6 40
        # Soustrait -1 car c'est un tableau
        ((colonne--))
        rm -f output.txt


                grille="-"
                for((z=0;z<grille_x;z++));do
                        grille+="--"
                done
                for((y=0;y<grille_y;y++));do
                        grille+="\n|"
                        for((i=0;i<grille_x;i++));do
                                # If pour identifier quel case a été selectionné par l'utilisateur
                                if [ "$i" -eq "$colonne" ] && [ "$y" -eq "$ligne" ]; then
                                        # Rempli la case sélectionné
                                        grille+="█|"
                                else
                                        grille+=" |"
                                fi
                        done
                        grille+="\n-"
                        for((z=0;z<grille_x;z++));do
                                grille+="--"
                        done
                done
        # Affiche la nouvelle grille
        dialog --clear --title "Grille de Jeu" --msgbox "$grille" 30 30
}

sous_menu2() {
        local sous_menu2
        # Boucle infinie
        while true; do
                # Affichage du menu
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

# Exécute les fonctions ci dessous
display_grid
sous_menu2
