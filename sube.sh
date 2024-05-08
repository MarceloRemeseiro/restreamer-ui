#!/bin/bash


PROYECTO=restreamer-ui
HOST="mabedev@192.168.1.113"
PASSWORD="28082003"
SCRIPT_PATH="/home/mabedev/restreamer-ui/streaminghub.sh"

# Usar sshpass para manejar la contraseña. Asegúrate de que sshpass esté instalado.
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no $HOST "bash $SCRIPT_PATH"

