#!/bin/bash

# Dimensions par défaut
ROWS=20
COLS=50

# Grille principale et nouvelle grille pour l'évolution
declare -A grid
declare -A newGrid

# Fonction pour initialiser la grille avec des valeurs aléatoires (0 ou 1)
InitGrid(){
    for ((i=0; i<$ROWS; i++)); do
        for ((j=0; j<$COLS; j++)); do
            grid[$i,$j]=0
        done
    done
}

# Fonction pour afficher la grille dans une boîte de dialogue
DisplayGrid() {
    local output=""

    # Dessiner la ligne supérieure de la grille
    output+="+"
    for ((j=0; j<$COLS; j++)); do
        output+="-"
    done
    output+="+\n"

    # Dessiner les lignes de la grille avec les cellules
    for ((i=0; i<$ROWS; i++)); do
        output+="|"
        for ((j=0; j<$COLS; j++)); do
            if [[ ${grid[$i,$j]} -eq 1 ]]; then
                output+="█"  # Cellule vivante
            else
                output+=" "  # Cellule morte (espace vide)
            fi
        done
        output+="|\n"
    done

    # Dessiner la ligne inférieure de la grille
    output+="+"
    for ((j=0; j<$COLS; j++)); do
        output+="-"
    done
    output+="+\n"

    dialog --yesno "$output" 26 56
    response=$?
}

# Fonction pour compter les voisins vivants d'une cellule
CompteurCellule() {
    local x=$1
    local y=$2
    local count=0

    for ((i=-1; i<=1; i++)); do
        for ((j=-1; j<=1; j++)); do
            if [[ $i -eq 0 && $j -eq 0 ]]; then
                continue
            fi
            local ni=$((x+i))
            local nj=$((y+j))

            if [[ $ni -ge 0 && $ni -lt $ROWS && $nj -ge 0 && $nj -lt $COLS ]]; then
                count=$((count + grid[$ni,$nj]))
            fi
        done
    done

    echo $count
}

# Fonction pour appliquer les règles du Jeu de la Vie et générer la nouvelle grille
NextGen() {
    for ((i=0; i<$ROWS; i++)); do
        for ((j=0; j<$COLS; j++)); do
            local cellule=$(CompteurCellule $i $j)

            if [[ ${grid[$i,$j]} -eq 1 ]]; then
                if [[ $cellule -lt 2 || $cellule -gt 3 ]]; then
                    newGrid[$i,$j]=0  # Meurt
                else
                    newGrid[$i,$j]=1  # Survit
                fi
            else
                if [[ $cellule -eq 3 ]]; then
                    newGrid[$i,$j]=1  # Naît
                else
                    newGrid[$i,$j]=0
                fi
            fi
        done
    done

    # Mise à jour de la grille
    for ((i=0; i<$ROWS; i++)); do
        for ((j=0; j<$COLS; j++)); do
            grid[$i,$j]=${newGrid[$i,$j]}
        done
    done
}

sous_menu2() {
    while true; do
        choix=$(dialog --clear --title "Sous-Menu" \
                --menu "Choisissez une option:" 15 50 2 \
                1 "Placer les cellules vivantes" \
                2 "But du jeu" \
                3 "Retourner au menu" \
                2>&1 >/dev/tty)

        case $choix in
            1) dialog --clear --intputbox "Affichage de la grille" 5 40
               # Exécution du script avec dialogue
               InitGrid
	       DisplayGrid
	       reponse=0
	       while [ $response -eq 0 ]; do
	       		dialog --clear --inputbox "Sur quel ligne voulez-vous jouer ?" 8 40 2>valeur.txt
	       		ligne=$(<valeur.txt)
			((ligne--))
	       		rm -f valeur.txt
			while [ $ligne -lt 0 ] || [ $ligne -gt 19 ]; do
				dialog --clear --msgbox "La grille de jeu ne contient pas cette ligne" 10 40
				dialog --clear --inputbox "Sur quel ligne voulez-vous jouer ?" 8 40 2>valeur.txt
                        	ligne=$(<valeur.txt)
                        	rm -f valeur.txt
			done
	       		dialog --clear --inputbox "Sur quel colonne voulez-vous jouer ?" 8 40 2>valeur.txt
	       		colonne=$(<valeur.txt)
			((colonne--))
	       		rm -f valeur.txt
			while [ $colonne -lt 0 ] || [ $colonne -gt 49 ]; do
				dialog --clear --msgbox "La grille de jeu ne contient pas cette colonne" 10 40
				dialog --clear --inputbox "Sur quel colonne voulez-vous jouer ?" 8 40 2>valeur.txt
				colonne=$(valeur.txt)
				rm -f valeur.txt
			done
			grid[$ligne,$colonne]=1
                        DisplayGrid
	       		dialog --yesno "Voulez-vous placer une autre cellule vivante ?" 8 40
	       		response=$?
	       done
	       while true; do
               		DisplayGrid
               		NextGen
               		sleep 0.1  # Pause de 0.1 seconde entre chaque génération pour une meilleure visualisation
                	if [ $response -ne 0 ]; then
                        	dialog --clear --msgbox "Retour au menu" 10 40
                        	sous_menu2
                        	break
                        fi
               done
	       ;;
            2) dialog --clear --msgbox "Dans ce mode, il faut placer soit-même les cellules vivantes pour réussir à former une forme" 10 40
	       sous_menu2 ;;
            3) break ;;
            *) dialog --clear --msgbox "Option invalide" 5 40 ;;
        esac
    break
    done
}

sous_menu2
