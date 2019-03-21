# Imagen Docker para los proyectos de Ingeniería Web

Esta imagen de Docker incluye Java 8, maven y git ya configurados y listos para usar, y adminte además acceso SSH (con contraseña) para realizar tareas de administración. Está construida a partir del Dockerfile de java/lamp y adaptada para su uso en la Facultad de Informática de la FDI.

El servidor está basado en Debian 9 (stretch), y todo el software se instala a partir de los repositorios de Debian.

La imagen únicamente expone los puertos 22, 8080 y 9001 (para acceder a SSH, un servidor Tomcat típico, y HSQLDB, respectivamente).

## Instrucciones para lanzar el contenedor

Al lanzar el contenedor sin instrucciones adicionales se configuran todos los servicios, incluyendo un password por defecto (user:pass) para acceso vía SSH.

También es posible configurar qué puertos estarán disponibles al lanzarlo con run

* `-p "127.0.0.1:2222:22"` (expone el puerto ssh del contenedor sólo a tu máquina local, y en tu puerto 2222)
* `-p 8080:8080` (expone el puerto 8080 del contenedor en tu puerto 8080)
* `-p "127.0.0.1:9001:9001"` (expone el puerto 9001 del contenedor, del servidor hsqldb, en tu puerto 9001, accesible sólo en tu máquina local)

Ejemplo:

```
docker run -d --name=MiContenedor -p "127.0.0.1:2222:22" -p 8080:8080 -p "127.0.0.1:9001:9001" mfreire/iw-docker
```

... y el servidor quedaría accesible vía ssh a través de 

```
ssh -p 2222 user@127.0.0.1
```

... con contraseña `pass`. Cámbiala tras arrancarlo usando `passwd`

## Instrucciones de uso

En el momento de lanzar el contenedor, se activan los siguientes servicios y funciones:

* Servidor SSH: Se puede acceder directamente como el usuario y password elegidos al ejecutar el contenedor.

La idea es pasar el código del proyecto, vía git, scp ó sftp, al contenedor; y luego ejecutarlo allí con `mvn spring-boot:run`, lo cual permitirá acceder a la aplicación web resultante en el puerto 8080. El contenedor viene con el proyecto de plantilla pre-copiado a `/app/iw1819`, e incluye también los scripts de lanzamiento de la base de datos correspondientes.

## Licencia

Esta imagen se distribuye bajo Licencia GPL v3 ó posterior. 

La imagen está construida a partir del Dockerfile y archivos de configuración de la imagen openjdk:8-jdk, y adaptada para su uso en la Facultad de Informática de la FDI.

> Original credits: [openjdk/8-jdk](https://github.com/docker-library/openjdk/blob/master/8/jdk/Dockerfile) contributors [yosifkit](https://github.com/yosifkit) and [Tianon Gravi](https://github.com/tianon)

[![](https://images.microbadger.com/badges/image/mfreire/iw-docker.svg)](https://microbadger.com/images/mfreire/iw-docker "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/mfreire/iw-docker.svg)](https://microbadger.com/images/mfreire/iw-docker "Get your own version badge on microbadger.com")
