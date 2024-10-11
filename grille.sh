#!/bin/bash

# Initialisation des variables
grille_x=0
grille_y=0
ligne=0
colonne=0

# On vérifie que les valeurs saisies pour créer la grille sont entre 1 et 9
while [[ "$grille_x" != +([1-9]) ]] || [ "$grille_x" -gt 9 ]; do
        # Demande à l'utilisateur de saisir une valeur
        dialog --inputbox "Longueur du plateau de jeu :" 8 40 2>output.txt

        # Récupère la valeur saisie
        grille_x=$(<output.txt)

        if [[ "$grille_x" != +([1-9]) ]] || [ "$grille_x" -gt 9 ]; then
                dialog --title "Error" --msgbox "La valeur $grille_x n'est pas valide" 6 40
        else
                # Affiche la valeur saisie dans une boîte de message
                dialog --msgbox "Valeur saisie : $grille_x" 6 40
        fi

        # Nettoie le fichier temporaire
        rm -f output.txt
done

while [[ "$grille_y" != +([1-9]) ]] || [ "$grille_y" -gt 9 ]; do
        # Demande à l'utilisateur de saisir une valeur
        dialog --inputbox "Hauteur du plateau de jeu :" 8 40 2>output.txt

        # Récupère la valeur saisie
        grille_y=$(<output.txt)

        if [[ "$grille_y" != +([1-9]) ]] || [ "$grille_y" -gt 9 ]; then
                dialog --title "Error" --msgbox "La valeur $grille_y n'est pas valide" 6 40
        else
                # Affiche la valeur saisie dans une boîte de message
                dialog --msgbox "Valeur saisie : $grille_y" 6 40
        fi

        # Nettoie le fichier temporaire
        rm -f output.txt
done

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

    # Affichage de la grille
    dialog --clear --title "Grille de Jeu" --msgbox "$grille" 30 30
    source ./jouer.sh
}

sous_menu2() {
        local sous_menu2
        # Boucle infinie
        while true; do
                # Affichage du menu
                choix=$(dialog --clear --title "Voulez vous quitter le jeu ?" \
                        --menu " " 17 50 2 \
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
