# Base Image
FROM centos:centos7
# Implementor
MAINTAINER R.LIEW
LABEL description="Base on centOS7, openJDK11"

ENV REFRESHED_AT 2020.12
ENV LANG C.UTF-8

ARG RESOURCE_PATH=resources
ARG INSTALLATION_PATH=/usr/share

# Setup openJDK-11 start --
ADD ${RESOURCE_PATH}/openjdk-11-dependency-rpm.tar.gz ${INSTALLATION_PATH}/openjdk-11-dependency
RUN yum localinstall -y ${INSTALLATION_PATH}/openjdk-11-dependency/*.rpm
ADD ${RESOURCE_PATH}/openjdk-11.tar.gz ${INSTALLATION_PATH}/openjdk-11
RUN chmod +x -R ${INSTALLATION_PATH}/openjdk-11
ENV JAVA_HOME ${INSTALLATION_PATH}/openjdk-11
ENV CLASSPATH $JAVA_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin
# Setup openJDK-11 end --

# Setup Maven start --
ADD ${RESOURCE_PATH}/maven-3.6.3.tar.gz ${INSTALLATION_PATH}/maven-3.6.3/
RUN chmod +x -R ${INSTALLATION_PATH}/maven-3.6.3
ENV PATH ${INSTALLATION_PATH}/maven-3.6.3/bin:${PATH}
# Setup Maven end --

# Setup Git start --
ADD ${RESOURCE_PATH}/git-1.8.3.tar.gz ${INSTALLATION_PATH}/git-1.8.3/
RUN yum localinstall -y ${INSTALLATION_PATH}/git-1.8.3/*.rpm
# Setup Git end --

#Setup unzip start --
ADD ${RESOURCE_PATH}/unzip-6.0-21.tar.gz ${INSTALLATION_PATH}/unzip-6.0-21/
RUN yum localinstall -y ${INSTALLATION_PATH}/unzip-6.0-21/*.rpm
#Setup unzip end --

# Setup Jenkins start --
ARG JENKINS_PATH=${INSTALLATION_PATH}/jenkins
ARG HTTP_PORT=8080
ARG AGENT_PORT=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=${JENKINS_PATH}/ref
ARG TINI_VERSION=v0.16.1
ARG JENKINS_VERSION=2.263.2
ARG JENKINS_SHA=89d054193d541b8d542f61e13262daf842b13fd5c04bfdc52765c70346f0878e

RUN mkdir -p ${JENKINS_HOME} \
 && mkdir -p ${JENKINS_PATH} \
 && mkdir -p ${REF}/init.groovy.d

VOLUME ${JENKINS_HOME}

ADD ${RESOURCE_PATH}/jenkins.tar.gz ${JENKINS_PATH}

RUN echo "${JENKINS_SHA} ${JENKINS_PATH}/jenkins-war-${JENKINS_VERSION}.war" | sha256sum -c - \
 && mv ${JENKINS_PATH}/jenkins-war-${JENKINS_VERSION}.war ${JENKINS_PATH}/jenkins.war \
 && mkdir -p ${JENKINS_HOME}

RUN cp ${JENKINS_PATH}/tini_pub.gpg ${JENKINS_HOME}/tini_pub.gpg \
 && cp ${JENKINS_PATH}/tini-static-amd64 /sbin/tini \
 && cp ${JENKINS_PATH}/tini-static-amd64.asc /sbin/tini.asc \
 && cp ${JENKINS_PATH}/jenkins-plugin-manager-2.2.0.jar /usr/lib/jenkins-plugin-manager.jar \
 && cp ${JENKINS_PATH}/jenkins-plugin-manager-retry-2.2.0.jar /usr/lib/jenkins-plugin-manager-retry.jar \
 && gpg --no-tty --import ${JENKINS_HOME}/tini_pub.gpg \
 && gpg --verify /sbin/tini.asc \
 && rm -rf /sbin/tini.asc /root/.gnupg \
 && chmod +x -R /sbin/tini \
 && chmod +x -R ${JENKINS_HOME}

EXPOSE ${HTTP_PORT}
EXPOSE ${AGENT_PORT}

ENV JENKINS_HOME ${JENKINS_HOME}
ENV JENKINS_SLAVE_AGENT_PORT ${AGENT_PORT}
ENV REF ${REF}
ENV JENKINS_VERSION ${JENKINS_VERSION}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV COPY_REFERENCE_FILE_LOG ${JENKINS_HOME}/copy_reference_file.log

RUN cp ${JENKINS_PATH}/jenkins-support /usr/local/bin/jenkins-support \
 && cp ${JENKINS_PATH}/jenkins.sh /usr/local/bin/jenkins.sh \
 && cp ${JENKINS_PATH}/tini-shim.sh /bin/tini \
 && cp ${JENKINS_PATH}/jenkins-plugin-cli.sh /bin/jenkins-plugin-cli \
 && cp ${JENKINS_PATH}/install-plugins.sh /usr/local/bin/install-plugins.sh \
 && cp ${JENKINS_PATH}/jenkins-plugin-cli-proxy-retry.sh /bin/jenkins-plugin-cli-proxy-retry

RUN chmod +x -R /usr/local/bin/jenkins.sh
# Setup Jenkins end --

# Setup plugins start --
RUN /bin/jenkins-plugin-cli-proxy-retry -f ${JENKINS_PATH}/plugins.txt
# Setup plugins end --

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]