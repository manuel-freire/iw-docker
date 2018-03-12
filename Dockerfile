FROM java:openjdk-8-jdk

MAINTAINER Manuel Freire <manuel.freire@fdi.ucm.es>

ENV DEBIAN_FRONTEND noninteractive

# update & cleanup
RUN apt-get update \
  && apt-get install -y openssh-server git \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install latest maven version
RUN mkdir /opt/maven \
  && cd /opt/maven \
  && wget http://apache.rediris.es/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
  && tar -xvzf apache-maven-3.5.3-bin.tar.gz \
  && ln -s $(pwd)/apache-maven-3.5.3/bin/mvn /usr/local/bin

# drop privileges and prime maven
ENV USER_NAME="user" \
  WORK_DIR="/app"
RUN mkdir ${WORK_DIR} \
  && groupadd -r ${USER_NAME} \
  && useradd -r -d ${WORK_DIR} -g ${USER_NAME} ${USER_NAME} \
  && chown -R ${USER_NAME}:${USER_NAME} ${WORK_DIR}
RUN mkdir /var/run/sshd \
  && echo 'user:user' | chpasswd \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
    -i /etc/pam.d/sshd
USER ${USER_NAME}
WORKDIR ${WORK_DIR}

RUN git clone https://github.com/manuel-freire/iw-base 
RUN cd iw-base \
  && mvn package \
  && cd ${WORK_DIR}

# limit maven's memory consumption
ENV MAVEN_OPTS="-Xmx256m -XX:ErrorFile=log.log"
  
# built-in tomcat webserver
EXPOSE 8080
# hsqldb default port
EXPOSE 9001

# end by launching SSH as root
EXPOSE 22
USER root
CMD /usr/sbin/sshd -D


  