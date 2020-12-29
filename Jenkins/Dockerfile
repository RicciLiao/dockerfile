# Base Image
FROM centos:7
# Implementor
MAINTAINER R.LIEW
LABEL description="Base on centOS7, openJDK11"

ENV REFRESHED_AT 2020.12
ENV LANG C.UTF-8

ARG RESOURCE_PATH=resource
ARG INSTALLATION_PATH=/usr/share

# Setup openJDK-11 start --
COPY ${RESOURCE_PATH}/openjdk-11-dependency-rpm ${INSTALLATION_PATH}/openjdk-11-dependency-rpm/
RUN yum localinstall -y ${INSTALLATION_PATH}/openjdk-11-dependency/*.rpm
COPY ${RESOURCE_PATH}/openjdk-11 ${INSTALLATION_PATH}/openjdk-11/
RUN chmod +x -R ${INSTALLATION_PATH}/openjdk-11
ENV JAVA_HOME ${INSTALLATION_PATH}/openjdk-11
ENV CLASSPATH $JAVA_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin
# Setup openJDK-11 end --

# Setup Jenkins start --
ARG JENKINS_INSTALLATION_DIR=${RESOURCE_PATH}/jenkins
ARG HTTP_PORT=8080
ARG AGENT_PORT=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=${INSTALLATION_PATH}/jenkins/ref
ARG TINI_VERSION=v0.16.1
ARG JENKINS_VERSION=2.235.4
ARG JENKINS_SHA=e5688a8f07cc3d79ba3afa3cab367d083dd90daab77cebd461ba8e83a1e3c177

RUN mkdir -p ${JENKINS_HOME} \
 && mkdir -p ${INSTALLATION_PATH}/jenkins \
 && mkdir -p ${REF}/init.groovy.d

VOLUME ${JENKINS_HOME}

COPY ${JENKINS_INSTALLATION_DIR}/jenkins-war-${JENKINS_VERSION}.war ${INSTALLATION_PATH}/jenkins/jenkins.war

RUN echo "${JENKINS_SHA} ${INSTALLATION_PATH}/jenkins/jenkins.war" | sha256sum -c -

RUN mkdir -p ${JENKINS_HOME} \
 && chmod +x -R ${JENKINS_HOME}

COPY ${JENKINS_INSTALLATION_DIR}/tini_pub.gpg ${JENKINS_HOME}/tini_pub.gpg
COPY ${JENKINS_INSTALLATION_DIR}/tini-static-amd64 /sbin/tini
COPY ${JENKINS_INSTALLATION_DIR}/tini-static-amd64.asc /sbin/tini.asc
COPY ${JENKINS_INSTALLATION_DIR}/jenkins-plugin-manager-2.1.2.jar /usr/lib/jenkins-plugin-manager.jar

RUN gpg --no-tty --import ${JENKINS_HOME}/tini_pub.gpg \
 && gpg --verify /sbin/tini.asc \
 && rm -rf /sbin/tini.asc /root/.gnupg \
 && chmod +x -R /sbin/tini

EXPOSE ${HTTP_PORT}
EXPOSE ${AGENT_PORT}

ENV JENKINS_HOME ${JENKINS_HOME}
ENV JENKINS_SLAVE_AGENT_PORT ${AGENT_PORT}
ENV REF ${REF}
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.235.4}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV COPY_REFERENCE_FILE_LOG ${JENKINS_HOME}/copy_reference_file.log

COPY ${JENKINS_INSTALLATION_DIR}/jenkins-support /usr/local/bin/jenkins-support
COPY ${JENKINS_INSTALLATION_DIR}/jenkins.sh /usr/local/bin/jenkins.sh
COPY ${JENKINS_INSTALLATION_DIR}/tini-shim.sh /bin/tini
COPY ${JENKINS_INSTALLATION_DIR}/jenkins-plugin-cli.sh /bin/jenkins-plugin-cli
COPY ${JENKINS_INSTALLATION_DIR}/install-plugins.sh /usr/local/bin/install-plugins.sh

RUN chmod +x -R /usr/local/bin/jenkins.sh
# Setup Jenkins end --

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]