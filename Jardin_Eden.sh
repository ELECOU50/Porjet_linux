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
    for ((i=9; i<42; i++)); do
	grid[5,$i]=1
    done
    grid[6,9]=1
    for((i=10; i<15; i=i+2)); do
	grid[6,$i]=1
    done
    grid[6,15]=1
    grid[6,16]=1
    grid[6,18]=1
    grid[6,19]=1
    grid[6,20]=1
    grid[6,22]=1
    for ((i=23; i<42; i=i+2)); do
	grid[6,$i]=1
    done
    grid[7,9]=1
    grid[7,11]=1
    grid[7,13]=1
    grid[7,14]=1
    grid[7,15]=1
    grid[7,17]=1
    grid[7,18]=1
    grid[7,19]=1
    grid[7,21]=1
    grid[7,22]=1
    grid[7,23]=1
    grid[7,24]=1
    grid[7,26]=1
    grid[7,27]=1
    for ((i=28; i<41; i=i+2)); do
	grid[7,$i]=1
    done
    for ((i=9; i<14; i++)); do
	grid[8,$i]=1
    done
    grid[8,15]=1
    grid[8,16]=1
    grid[8,17]=1
    grid[8,19]=1
    grid[8,20]=1
    grid[8,21]=1
    for ((i=23; i<27; i++)); do
	grid[8,$i]=1
    done
    for ((i=28; i<42; i++)); do
	grid[8,$i]=1
    done
    grid[9,9]=1
    grid[9,11]=1
    grid[9,13]=1
    grid[9,14]=1
    grid[9,16]=1
    grid[9,17]=1
    grid[9,18]=1
    grid[9,20]=1
    grid[9,21]=1
    grid[9,22]=1
    grid[9,24]=1
    grid[9,26]=1
    grid[9,27]=1
    for ((i=28; i<41; i=i+2)); do
	grid[9,$i]=1
    done
    for ((i=9; i<13; i++)); do
	grid[10,$i]=1
    done
    grid[10,14]=1
    grid[10,15]=1
    grid[10,16]=1
    grid[10,18]=1
    grid[10,19]=1
    grid[10,20]=1
    for ((i=22; i<27; i++)); do
	grid[10,$i]=1
    done
    grid[10,28]=1
    for ((i=29; i<42; i=i+2)); do
	grid[10,$i]=1
    done
    grid[11,10]=1
    grid[11,11]=1
    grid[11,13]=1
    grid[11,14]=1
    grid[11,15]=1
    grid[11,17]=1
    grid[11,18]=1
    grid[11,19]=1
    grid[11,21]=1
    grid[11,22]=1
    for ((i=23; i<30; i=i+2)); do
	grid[11,$i]=1
    done
    for ((i=30; i<42; i++)); do
	grid[11,$i]=1
    done
    grid[12,9]=1
    grid[12,10]=1
    grid[12,12]=1
    grid[12,13]=1
    grid[12,15]=1
    grid[12,16]=1
    grid[12,17]=1
    grid[12,19]=1
    grid[12,20]=1
    grid[12,21]=1
    grid[12,23]=1
    grid[12,24]=1
    for ((i=26; i<30; i++)); do
	grid[12,$i]=1
    done
    for ((i=31; i<42; i=i+2)); do
	grid[12,$i]=1
    done
    for ((i=9; i<27; i++)); do
	grid[13,$i]=1
    done
    for ((i=28; i<42; i++)); do
	grid[13,$i]=1
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
	    2) dialog --clear --msgbox "Un jardin d’Éden est une configuration sans passé possible : aucune configuration ne donne à l’étape suivante un jardin d’Éden." 20 40
	       sous_menu1 ;;
            3) break ;;
            *) dialog --clear --msgbox "Option invalide" 5 40 ;;
        esac
        break
    done
}

sous_menu1
