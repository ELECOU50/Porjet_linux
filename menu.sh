#!/bin/bash

# Fonction pour le menu principal
menu_principal() {
    local menu_principal
    while true; do
        choix=$(dialog --clear --title "Menu Principal" \
                --menu "Choisissez une option:" 19 50 10 \
                1 "Structures stables" \
                2 "Oscillateurs" \
	        3 "Vaisseaux" \
		4 "Mathusalems" \
		5 "Puffeurs" \
		6 "Canons" \
		7 "Jardins d'Eden" \
		8 "Constructeur Universel" \
		9 "Figure personnalisée" \
		10 "Quitter" \
                2>&1 >/dev/tty)

        case $choix in
            1)source ./Structures_stables.sh ;;
	    2)source ./oscillateur.sh ;;
	    3)source ./vaisseaux.sh ;;
            4)source ./Mathusalems.sh ;;
	    5)source ./Puffeurs.sh ;;
	    6)source ./Canon.sh ;;
	    7)source ./Jardin_Eden.sh ;;
	    8)source ./Constructeurs_Universels.sh ;;
	    9)source ./Figure.sh ;;
            10) dialog --clear
		clear
		break ;;
            *) dialog --clear --msgbox "Option invalide" 5 40 ;;
        esac
    done
}

# Lancer le menu principal
menu_principal
