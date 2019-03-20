FROM openjdk:8-jdk

ARG VCS_REF

LABEL maintainer="Manuel Freire <manuel.freire@fdi.ucm.es>" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/manuel-freire/iw-docker"

ENV DEBIAN_FRONTEND noninteractive

# update & cleanup
RUN apt-get update \
  && apt-get install -y openssh-server git \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# install latest maven version
RUN mkdir /opt/maven \
  && cd /opt/maven \
  && wget http://apache.rediris.es/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz \
  && tar -xvzf apache-maven-3.6.0-bin.tar.gz \
  && ln -s $(pwd)/apache-maven-3.6.0/bin/mvn /usr/local/bin

# drop privileges and prime maven
ENV USER_NAME="user" \
  USER_PASS="pass" \
  WORK_DIR="/app"
RUN mkdir ${WORK_DIR} \
  && mkdir ${WORK_DIR}/.m2 \
  && groupadd -r ${USER_NAME} \
  && useradd -r -d ${WORK_DIR} -g ${USER_NAME} ${USER_NAME} \
  && chown -R ${USER_NAME}:${USER_NAME} ${WORK_DIR}
# see https://stackoverflow.com/a/53016532/15472
COPY settings.xml ${WORK_DIR}/.m2
RUN mkdir /var/run/sshd \
  && echo "${USER_NAME}:${USER_PASS}" | chpasswd \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
    -i /etc/pam.d/sshd
USER ${USER_NAME}
WORKDIR ${WORK_DIR}

RUN git clone https://github.com/manuel-freire/iw1819

RUN cd iw1819 \
  && mvn package \
  && cd ${WORK_DIR}

# limit maven's memory consumption
ENV MAVEN_OPTS="-Xmx256m -XX:ErrorFile=log.log"

# expose built-in tomcat webserver
EXPOSE 8080
# expose hsqldb default port
EXPOSE 9001

# end by launching SSH as root
EXPOSE 22
USER root
CMD /usr/sbin/sshd -D


  
