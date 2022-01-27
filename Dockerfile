FROM openjdk:11

ARG VCS_REF

LABEL maintainer="Manuel Freire <manuel.freire@fdi.ucm.es>" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/manuel-freire/iw-docker"

ENV DEBIAN_FRONTEND noninteractive

# update, get an ssh server & git & tmux, and cleanup
RUN apt-get update \
  && apt-get install -y openssh-server git nano tmux \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install latest maven version
RUN mkdir /opt/maven \
  && cd /opt/maven \
  && wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz \
  && tar -xvzf apache-maven-3.8.4-bin.tar.gz \
  && ln -s $(pwd)/apache-maven-3.8.4/bin/mvn /usr/local/bin

# create non-root user, allow ssh access
ENV USER_NAME="user" \
  USER_PASS="pass" \
  WORK_DIR="/app"
RUN mkdir ${WORK_DIR} \
  && groupadd -r ${USER_NAME} \
  && useradd -r -d ${WORK_DIR} -g ${USER_NAME} ${USER_NAME} -s /bin/bash \
  && chown -R ${USER_NAME}:${USER_NAME} ${WORK_DIR} \
  && echo 'MAVEN_OPTS="-Xmx256m -XX:ErrorFile=log.log"' >> /etc/environment \
  && echo 'JAVA_HOME="/usr/local/openjdk-11"' >> /etc/environment
RUN mkdir /var/run/sshd \
  && echo "${USER_NAME}:${USER_PASS}" | chpasswd \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
    -i /etc/pam.d/sshd

# drop privileges
USER ${USER_NAME}
WORKDIR ${WORK_DIR}

# limit memory consumption for maven
RUN mkdir ${WORK_DIR}/.m2
COPY settings.xml ${WORK_DIR}/.m2

# prime maven
RUN git clone https://github.com/manuel-freire/iw \
  && cd iw/plantilla \
  && mvn package \
  && cd ../.. && rm -rf iw \
  && cd ${WORK_DIR}

# expose built-in tomcat webserver (to be launched by users)
EXPOSE 8080

# end by launching SSH as root
EXPOSE 22
USER root
CMD /usr/sbin/sshd -D
