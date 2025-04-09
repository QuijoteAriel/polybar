#!/bin/bash

# Contar actualizaciones del sistema
system_updates=$(checkupdates 2>/dev/null | wc -l)

# Contar actualizaciones de AUR
aur_updates=$(yay -Qua 2>/dev/null | wc -l)

# Sumar y mostrar el total
total_updates=$((system_updates + aur_updates))

if [ "$total_updates" -gt 0 ]; then
  echo "%{F#88c0d0}󰇚: $total_updates"
else
  echo "%{F#ffffff}󰇚"
fi
