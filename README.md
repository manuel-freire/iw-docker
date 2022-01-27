# Imagen Docker para los proyectos de Ingeniería Web

Esta imagen de Docker incluye Java 11, maven, git, nano y tmux ya configurados y listos para usar, y adminte además acceso SSH (con contraseña) para realizar tareas de administración. Está construida a partir del Dockerfile de java/lamp y adaptada para su uso en la Facultad de Informática de la FDI.

El servidor está basado en Debian Bullseye (11.2), y todo el software se instala a partir de los repositorios de Debian, con la excepción de la JDK 11, que se descarga de OpenJDK; y de Maven, que se descarga del repositorio oficial de Apache Maven.

La imagen únicamente expone los puertos 22 y 8080 (para acceder a SSH y al servidor de aplicaciones embebido de Spring MVC, respectivamente).

## Instrucciones para lanzar el contenedor

Al lanzar el contenedor sin instrucciones adicionales se configuran todos los servicios, incluyendo un password por defecto (user:pass) para acceso vía SSH.

También es posible configurar qué puertos estarán disponibles al lanzarlo con run

* `-p "127.0.0.1:2222:22"` (expone el puerto ssh del contenedor sólo a tu máquina local, y en tu puerto 2222)
* `-p 8080:8080` (expone el puerto 8080 del contenedor en tu puerto 8080)

Ejemplo:

```
docker run -d -p "127.0.0.1:2222:22" -p 8080:8080 mfreire/iw-docker
```

... y el servidor quedaría accesible vía ssh a través de 

```
ssh -p 2222 user@127.0.0.1
```

... con contraseña `pass`. Cámbiala tras arrancarlo usando `passwd`

## Instrucciones de uso

En el momento de lanzar el contenedor, se activan los siguientes servicios y funciones:

* Servidor SSH: Se puede acceder directamente como el usuario y password elegidos al ejecutar el contenedor.

La idea es pasar el código del proyecto, vía git, scp ó sftp, al contenedor; y luego ejecutarlo allí con `mvn spring-boot:run`, lo cual permitirá acceder a la aplicación web resultante en el puerto 8080 (usa `tmux` para preservar tu sesión ssh ([guía de uso](https://tmuxcheatsheet.com/)); y `ctrl+Z` para parar un servidor que se esté ejecutando). Para descargar la aplicación web a lanzar por primera vez, usa `git clone <url-de-repositorio>`; y para refrescarla cuando hagas cambios en el repositorio, usa `git reset --hard && git pull origin main`.

## Licencia

Esta imagen se distribuye bajo Licencia GPL v3 ó posterior. 

La imagen está construida a partir del Dockerfile y archivos de configuración de la imagen openjdk:8-jdk, y adaptada para su uso en la Facultad de Informática de la FDI.

> Basada en: [openjdk/11](https://github.com/docker-library/openjdk/blob/61bfbb30ae5a0395f08d41107b86bcce90d70ba6/11/jdk/bullseye/Dockerfile) 

[![](https://images.microbadger.com/badges/image/mfreire/iw-docker.svg)](https://microbadger.com/images/mfreire/iw-docker "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/mfreire/iw-docker.svg)](https://microbadger.com/images/mfreire/iw-docker "Get your own version badge on microbadger.com")
