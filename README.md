# Imagen Docker para los proyectos de Ingeniería Web

Esta imagen de Docker incluye Java 8, maven y git ya configurados y listos para usar, y adminte además acceso SSH (con contraseña) para realizar tareas de administración. Está construida a partir del Dockerfile de java/lamp y adaptada para su uso en la Facultad de Informática de la FDI.

El servidor está basado en Ubuntu 18.04 (LTS), y todo el software se instala a partir de los repositorios de Ubuntu.

La imagen únicamente expone los puertos 80 y 22 (para acceder a otros puertos, se pueden establecer túneles SSH).


## Instrucciones para lanzar el contenedor

Al lanzar el contenedor sin instrucciones adicionales se configuran todos los servicios, incluyendo un password por defecto (user:pass) para acceso vía SSH.

Es posible configurar el acceso ssh al crear el contenedor:

* -e USER_NAME=X
* -e USER_PASS=X

Ejemplo:

```
docker run -d --name=MiContenedor -e USER_NAME=juan -e USER_PASS=secreto123 mfreire/iw-docker
```

## Instrucciones de uso

En el momento de lanzar el contenedor, se activan los siguientes servicios y funciones:

* Servidor SSH: Se puede acceder directamente como el usuario y password elegidos al ejecutar el contenedor.
* Subida de archivos: para subir archivos al servidor, se puede utilizar el protocolo SFTP sobre el servidor SSH.

## Licencia

Esta imagen se distribuye bajo Licencia GPL v3 ó posterior. 

La imagen está construida a partir del Dockerfile y archivos de configuración de la imagen openjdk:8-jdk, y adaptada para su uso en la Facultad de Informática de la FDI.

> Original credits: [openjdk/8-jdk](https://github.com/docker-library/openjdk/blob/master/8/jdk/Dockerfile) contributors [yosifkit](https://github.com/yosifkit) and [Tianon Gravi](https://github.com/tianon)

[![](https://images.microbadger.com/badges/image/mfreire/iw-docker.svg)](https://microbadger.com/images/mfreire/iw-docker "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/mfreire/iw-docker.svg)](https://microbadger.com/images/mfreire/iw-docker "Get your own version badge on microbadger.com")
