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

    # Placer des planeurs dans la grille
    grid[10,7]=1
    grid[10,8]=1
    grid[11,7]=1
    grid[11,8]=1
    grid[10,16]=1
    grid[11,16]=1
    grid[12,16]=1
    grid[9,17]=1
    grid[13,17]=1
    grid[8,18]=1
    grid[14,18]=1
    grid[8,19]=1
    grid[14,19]=1
    grid[11,20]=1
    grid[9,21]=1
    grid[13,21]=1
    grid[10,22]=1
    grid[11,22]=1
    grid[12,22]=1
    grid[11,23]=1
    grid[8,26]=1
    grid[9,26]=1
    grid[10,26]=1
    grid[8,27]=1
    grid[9,27]=1
    grid[10,27]=1
    grid[7,28]=1
    grid[11,28]=1
    grid[6,30]=1
    grid[7,30]=1
    grid[11,30]=1
    grid[12,30]=1
    grid[8,40]=1
    grid[9,40]=1
    grid[8,41]=1
    grid[9,41]=1
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

    dialog --yesno "$output" "26" "56"
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

sous_menu1() {
    local sous_menu1
    while true; do
        choix=$(dialog --clear --title "Sous-Menu" \
                --menu "Choisissez une option:" 15 50 2 \
                1 "Afficher la grille" \
		2 "A propos" \
                3 "Retourner au menu" \
                2>&1 >/dev/tty)

        case $choix in
            1) dialog --clear --msgbox "Affichage de la grille" 5 40
               # Exécution du script avec dialogue
               InitGrid
               while true; do
               		DisplayGrid
                        NextGen
                        sleep 0.1  # Pause de 0.1 seconde entre chaque génération pour une meilleure visualisation
			if [ $response -ne 0 ]; then
        			dialog --clear --msgbox "Retour au menu" 10 40
				sous_menu1
				break
    			fi
                done ;;
	    2) dialog --clear --msgbox "Les canons sont des configurations qui émettent un autre motif, tel qu'un vaisseau, à intervalles réguliers. Ces vaisseaux sont des motifs qui continuent de se déplacer sur la grille de jeu. La périodicité des canons, soit l'intervalle de temps après lequel ils répètent leur comportement, peut varier." 20 40
	       sous_menu1 ;;
            3) break ;;
            *) dialog --clear --msgbox "Option invalide" 5 40 ;;
        esac
        break
    done
}

sous_menu1
