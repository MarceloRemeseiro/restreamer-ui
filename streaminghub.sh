#!/bin/bash

# Detener y eliminar el contenedor si está corriendo
if [ "$(docker ps -q -f name=streaminghub)" ]; then
    echo "Deteniendo y eliminando el contenedor actual..."
    docker stop streaminghub
    docker rm streaminghub
else
    echo "No existe el contenedor streaminghub, se creará uno nuevo."
fi

# Función para eliminar una imagen Docker si existe
remove_docker_image() {
    if [ "$(docker images -q "myrsui")" ]; then
        echo "Eliminando la imagen Docker myrsui..."
        docker rmi "myrsui"
    else
        echo "No existe la imagen myrsui, se procederá a crearla."
    fi
}

# Verificar la existencia del directorio y actualizar el código fuente
if [ -d "/home/mabedev/restreamer-ui" ]; then
    echo "Actualizando el código fuente desde Git en /home/mabedev/restreamer-ui..."
    cd /home/mabedev/restreamer-ui
    git pull
    if [ $? -ne 0 ]; then
        echo "Fallo al actualizar el código fuente, abortando..."
        exit 1
    fi

    # Reconstruir la imagen Docker para myrsui
    echo "Construyendo la nueva imagen Docker myrsui..."
    docker build -t myrsui .
else
    echo "El directorio /home/mabedev/restreamer-ui no existe."
    exit 1
fi

# Verificar la existencia del directorio y construir la imagen de myrestreamer
if [ -d "/home/mabedev/restreamer" ]; then
    cd /home/mabedev/restreamer
    echo "Construyendo la nueva imagen Docker myrestreamer..."
    docker build --build-arg FFMPEG_IMAGE=myffmpeg --build-arg CORE_IMAGE=mycore --build-arg RESTREAMER_UI_IMAGE=myrsui -t myrestreamer .
else
    echo "El directorio /home/mabedev/restreamer no existe."
    exit 1
fi

# Iniciar el nuevo contenedor
echo "Iniciando el nuevo contenedor streaminghub..."
docker run -d -it --rm --name streaminghub -p 8080:8080 -p 1935:1935 -p 1936:1936 -p 6000:6000 myrestreamer

# Limpiar imágenes "dangling"
echo "Limpiando imágenes sin usar..."
docker image prune -f

echo "Actualización completada y contenedor reiniciado."
