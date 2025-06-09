#!/bin/bash

options="Apagar\nReiniciar\nCerrar Sesión\nCancelar"

selected=$(echo -e "$options" | rofi -dmenu -p "Acciones")

case "$selected" in
    "Apagar")
        systemctl poweroff
        ;;
    "Reiniciar")
        systemctl reboot
        ;;
    "Cerrar Sesión")
        i3-msg exit
        ;;
    "Cancelar")
        exit 0
        ;;
esac 


