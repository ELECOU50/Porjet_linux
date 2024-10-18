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
                8 "Constructeurs universels" \
                9 "Quitter" \
                2>&1 >/dev/tty)

        case $choix in
            1) ./Structures_stables.sh ;;
            2) ./oscillateur.sh ;;
            3) ./vaisseaux.sh ;;
            4) ./Mathusalems.sh ;;
            5) ./Puffeurs.sh ;;
            6) ./Canon.sh ;;
            7) ./Jardin_Eden.sh ;;
            8) ./Constructeurs_Universels.sh ;;
            9) dialog --clear
                break ;;
            *) dialog --clear --msgbox "Option invalide" 5 40 ;;
        esac
    done
}

# Lancer le menu principal
menu_principal
