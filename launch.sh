#!/bin/bash

# Termina todas las instancias de Polybar
killall -q polybar

# Espera hasta que Polybar se haya cerrado completamente
while pgrep -u $UID -x polybar >/dev/null; do
    sleep 1
done

# Lanza Polybar
polybar
