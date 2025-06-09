#!/bin/bash

# Directorio para almacenar el mes y año actuales
CAL_DIR="/tmp/polybar-calendar"
mkdir -p "$CAL_DIR"
CAL_FILE="$CAL_DIR/current_date"

# Inicializar si no existe el archivo
if [ ! -f "$CAL_FILE" ]; then
    date +%Y-%m > "$CAL_FILE"
fi

# Leer el mes y año actuales
read -r YEAR MONTH < "$CAL_FILE"

# Manejar la navegación (clics en Polybar)
case "$1" in
    "prev")
        MONTH=$((MONTH - 1))
        if [ "$MONTH" -eq 0 ]; then
            MONTH=12
            YEAR=$((YEAR - 1))
        fi
        echo "$YEAR $MONTH" > "$CAL_FILE"
        ;;
    "next")
        MONTH=$((MONTH + 1))
        if [ "$MONTH" -eq 13 ]; then
            MONTH=1
            YEAR=$((YEAR + 1))
        fi
        echo "$YEAR $MONTH" > "$CAL_FILE"
        ;;
    *)
        # Si no hay argumentos o un argumento desconocido, simplemente muestra el calendario
        ;;
esac

# Formatear el mes para cal/ncal (sin ceros iniciales para cal, con para ncal)
# Para 'cal', el mes debe ser un número sin ceros iniciales
MONTH_NOCEROS=$(echo "$MONTH" | sed 's/^0*//')

# Obtener el nombre del mes
MONTH_NAME=$(date -d "$YEAR-$MONTH_NOCEROS-01" +%b)

# Imprimir el formato para Polybar
# Aquí puedes personalizar el texto que se muestra en Polybar
echo "📅 $MONTH_NAME $YEAR"

# Mostrar el calendario completo en una ventana emergente (opcional, pero recomendado para la navegación)
# Esta parte se ejecutará cuando hagas clic en el módulo de Polybar
if [ "$1" == "show" ]; then
    # Usar `yad` o `rofi` para mostrar el calendario completo en una ventana
    # Si no tienes yad o rofi, puedes usar un terminal como urxvt, alacritty, kitty, etc.
    # Asegúrate de instalar `yad` o `rofi` si los quieres usar.
    # sudo apt install yad (para Debian/Ubuntu)
    # sudo apt install rofi (para Debian/Ubuntu)

    # Opción 1: Usar `yad` (más simple para popups)
    # Si no tienes yad, descomenta la opción 2 y ajusta tu terminal
    if command -v yad &> /dev/null; then
        yad --text="$(cal -h $MONTH_NOCEROS $YEAR)" \
            --title="Calendario" \
            --width=250 --height=200 \
            --center \
            --button="Anterior":1 \
            --button="Siguiente":2 \
            --on-top \
            --skip-taskbar & # para que no aparezca en la barra de tareas

        # Manejar la respuesta de yad
        case $? in
            1) "$0" prev show ;; # Botón "Anterior"
            2) "$0" next show ;; # Botón "Siguiente"
        esac
    else
        # Opción 2: Abrir en un terminal (requiere un terminal que soporte -e o -hold)
        # Reemplaza 'urxvt' con tu terminal preferido (alacritty, kitty, gnome-terminal, etc.)
        # Asegúrate de que tu terminal pueda ejecutar un comando y mantenerse abierto (-hold)
        # Ejemplo para alacritty: alacritty -e bash -c "cal -h $MONTH_NOCEROS $YEAR; read"
        # Ejemplo para urxvt: urxvt -e bash -c "cal -h $MONTH_NOCEROS $YEAR && read"
        # Ejemplo para gnome-terminal: gnome-terminal -- bash -c "cal -h $MONTH_NOCEROS $YEAR; read"
        urxvt -e bash -c "cal -h $MONTH_NOCEROS $YEAR && echo 'Presiona Enter para cerrar' && read" &
    fi
fi
