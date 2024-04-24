#!/bin/bash



SCRIPT_DIR=$(dirname "$0")  # Obtiene el directorio del script

# Verifica si el contenedor está corriendo y detenerlo si es necesario 1
if [ $(docker ps -q -f name=streaminghub) ]; then
    echo "Deteniendo y eliminando el contenedor actual..."
    docker stop streaminghub
    docker rm streaminghub
else
    echo "No existe el contenedor streaminghub, se creará uno nuevo."
fi

# Verificar si la imagen existe y eliminarla si es necesario 1
if [ $(docker images -q myrestreamer) ]; then
    echo "Eliminando la imagen Docker..."
    docker rmi myrestreamer
else
    echo "No existe la imagen myrestreamer, se creará una nueva."
fi

# Verificar si la imagen existe y eliminarla si es necesario 2
if [ $(docker images -q myrsui) ]; then
    echo "Eliminando la imagen Docker..."
    docker rmi myrsui
else
    echo "No existe la imagen myrsui, se creará una nueva."
fi

# Actualizar el código fuente
echo "Actualizando el código fuente desde Git..."
cd $SCRIPT_DIR
git pull

# Reconstruir la imagen Docker 1
echo "Construyendo la nueva imagen Docker..."
docker build -t myrsui .

# Reconstruir la imagen Docker 2
echo "Construyendo la nueva imagen Docker..."
docker build --build-arg FFMPEG_IMAGE=myffmpeg --build-arg CORE_IMAGE=mycore --build-arg RESTREAMER_UI_IMAGE=myrsui -t myrestreamer .

# Iniciar el nuevo contenedor
echo "Iniciando el nuevo contenedor..."
docker run -it --rm --name streaminghub --restart=always -p 8080:8080 -p 1935:1935 -p 1936:1936-p 6000:6000 myrestreamer

# Limpiar imágenes "dangling"
echo "Limpiando imágenes sin usar..."
docker image prune -f

echo "Actualización completada y contenedor reiniciado."


