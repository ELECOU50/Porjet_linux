#!/bin/bash

# Fonction pour le sous-menu
sous_menu() {
    local sous_menu
    while true; do
        choix=$(dialog --clear --title "Sous-Menu" \
                --menu "Choisissez une option:" 15 50 2 \
                1 "Afficher la grille" \
                2 "Retourner au menu" \
                2>&1 >/dev/tty)

        case $choix in
            1) dialog --msgbox "Affichage de la grille" 5 40
               while true; do
               source ./grille.sh
               done ;;
            2) break ;;
            *) dialog --msgbox "Option invalide" 5 40 ;;
        esac
    done
}

# Fonction pour le menu principal
menu_principal() {
    local menu_principal
    while true; do
        choix=$(dialog --clear --title "Menu Principal" \
                --menu "Choisissez une option:" 17 50 10 \
                1 "Structures stables" \
                2 "Oscillateurs" \
                3 "Vaisseaux" \
                4 "Mathusalems" \
                5 "Puffeurs" \
                6 "Canons" \
                7 "Jardins d'Eden" \
                8 "Constructeurs universels" \
                9 "Dimension et complexité" \
                10 "Quitter" \
                2>&1 >/dev/tty)

        case $choix in
            1) dialog --msgbox "Affichage Structures stables" 5 40
               sous_menu ;;
            2) dialog --msgbox "Affichage Oscillateur" 5 40
               sous_menu ;;
            3) dialog --msgbox "Affichage Vaisseaux" 5 40
               sous_menu ;;
            4) dialog --msgbox "Affichage Mathusalems" 5 40
               sous_menu ;;
            5) dialog --msgbox "Affichage Puffeurs" 5 40
               sous_menu ;;
            6) dialog --msgbox "Affichage Canons" 5 40
               sous_menu ;;
            7) dialog --msgbox "Affichage Jardins d'Eden" 5 40
               sous_menu ;;
            8) dialog --msgbox "Affichage Constructeurs universels" 5 40
               sous_menu ;;
            9) dialog --msgbox "Affichage Dimension et complexité" 5 40
               sous_menu ;;
            10) dialog --msgbox "Au revoir !" 5 40 ; clear ; exit 0
                sous_menu ;;
            *) dialog --msgbox "Option invalide" 5 40 ;;
        esac
    done
}

# Lancer le menu principal

menu_principal
