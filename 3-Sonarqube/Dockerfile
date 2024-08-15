# Base Image
FROM centos:centos7
ENV REFRESHED_AT 2020.12
ENV LANG C.UTF-8

# Software summary start --
ARG OPENJDK_VERSION=11
ARG UNZIP_VERSION=6.0
ARG SONARQUBE_VERSION=8.6.0
ARG RESOURCE_PATH=resources
ARG INSTALLATION_PATH=/archive
# Software summary end --

# LABEL start --
LABEL system.operation="CentOS 7"
LABEL system.maintainer="R.LIEW"
LABEL system.software.openjdk=${OPENJDK_VERSION}
LABEL system.software.unzip=${UNZIP_VERSION}
LABEL system.software.sonarqube=${SONARQUBE_VERSION}
#LABEL end --

# Setup openJDK-11 start --
ADD ${RESOURCE_PATH}/openjdk-${OPENJDK_VERSION}-dependency-rpm.tar.gz ${INSTALLATION_PATH}/openjdk-dependency
RUN yum localinstall -y ${INSTALLATION_PATH}/openjdk-dependency/*.rpm
ADD ${RESOURCE_PATH}/openjdk-${OPENJDK_VERSION}.tar.gz ${INSTALLATION_PATH}/openjdk
RUN chmod +x -R ${INSTALLATION_PATH}/openjdk
ENV JAVA_HOME=${INSTALLATION_PATH}/openjdk
ENV CLASSPATH=$JAVA_HOME/lib
ENV PATH=$PATH:$JAVA_HOME/bin
# Setup openJDK-11 end --

#Setup unzip start --
ADD ${RESOURCE_PATH}/unzip-${UNZIP_VERSION}.tar.gz ${INSTALLATION_PATH}/unzip
RUN yum localinstall -y ${INSTALLATION_PATH}/unzip/*.rpm
#Setup unzip end --

# Setup Sonarqube start --
ENV SONARQUBE_HOME=${INSTALLATION_PATH}/sonarqube
ENV SONAR_VERSION=${SONARQUBE_VERSION}
ENV SQ_DATA_DIR="${SONARQUBE_HOME}/data"
ENV SQ_EXTENSIONS_DIR="${SONARQUBE_HOME}/extensions"
ENV SQ_LOGS_DIR="${SONARQUBE_HOME}/logs"
ENV SQ_TEMP_DIR="${SONARQUBE_HOME}/temp"
ADD ${RESOURCE_PATH}/sonarqube-${SONARQUBE_VERSION}.tar.gz ${SONARQUBE_HOME}
RUN cp ${SONARQUBE_HOME}/sonar.sh /usr/local/bin/sonar.sh \
 && cp ${SONARQUBE_HOME}/tini-static-amd64 /sbin/tini \
 && cp ${SONARQUBE_HOME}/tini-static-amd64.asc /sbin/tini.asc \
 && cp ${SONARQUBE_HOME}/tini-shim.sh /bin/tini \
 && gpg --no-tty --import ${SONARQUBE_HOME}/tini_pub.gpg \
 && gpg --verify /sbin/tini.asc \
 && rm -rf /sbin/tini.asc /root/.gnupg \
 && chmod +x /usr/local/bin/sonar.sh \
 && chmod +x /sbin/tini
RUN groupadd -g 1000 sonarqube
RUN useradd -N -d "${SONARQUBE_HOME}" -u 1000 -g 1000 -m -s /bin/bash sonarqube
RUN chown -R 1000:1000 "${SONARQUBE_HOME}"
RUN chmod -R 777 "${SQ_DATA_DIR}" "${SQ_EXTENSIONS_DIR}" "${SQ_LOGS_DIR}" "${SQ_TEMP_DIR}"
# Setup Sonarqube end --
WORKDIR ${SONARQUBE_HOME}
EXPOSE 9000
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/sonar.sh"]