#!/bin/bash

jouer() {
        local jouer

        # On vérifie que la case ciblé est contenu dans la grille de jeu
        while [[ "$ligne" != +([1-"$grille_x"]) ]] || [ "$ligne" -gt "$grille_x" ]; do
                dialog --inputbox "Sur quel ligne voulez-vous jouer ?" 8 40 2>output.txt
                ligne=$(<output.txt)
                if [[ "$ligne" != +([1-"$grille_x"]) ]] || [ "$ligne" -gt "$grille_x" ]; then
                        dialog --title "Error" --msgbox "La valeur $ligne n'est pas valide" 6 40
                else
                        dialog --msgbox "Ligne de la case saisie : $ligne" 6 40
                         # Soustrait -1 car c'est un tableau
                        ((ligne--))
                fi
                rm -f output.txt
        done

        while [[ "$colonne" != +([1-"$grille_y"]) ]] || [ "$colonne" -gt "$grille_y" ]; do
                dialog --inputbox "Sur quel colonne voulez-vous jouer ?" 8 40 2>output.txt
                colonne=$(<output.txt)
                if [[ "$colonne" != +([1-"$grille_y"]) ]] || [ "$colonne" -gt "$grille_y" ]; then
                        dialog --title "Error" --msgbox "La valeur $colonne n'est pas valide" 6 40
                else
                        dialog --msgbox "Ligne de la case saisie : $colonne" 6 40
                         # Soustrait -1 car c'est un tableau
                        ((colonne--))
                fi
                rm -f output.txt
        done

        # Création de nouvelle grille
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

#Execute les fonctions ci-dessous
jouer
