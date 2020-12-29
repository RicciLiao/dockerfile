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
ENV CLASSPATH $CLASSPATH:$JAVA_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin
# Setup openJDK-11 end --

# Setup Maven start --
COPY ${RESOURCE_PATH}/maven-3.6.3 ${INSTALLATION_PATH}/maven-3.6.3/
RUN chmod +x -R ${INSTALLATION_PATH}/maven-3.6.3
ENV PATH ${INSTALLATION_PATH}/maven-3.6.3/bin:${PATH}
# Setup Maven end --

# Setup Git start --
COPY ${RESOURCE_PATH}/git-1.8.3 ${INSTALLATION_PATH}/git-1.8.3/
RUN yum localinstall -y ${INSTALLATION_PATH}/git-1.8.3/*.rpm
# Setup Git end --

## Setup RocketMQ start --
#COPY ${RESOURCE_PATH}/rocketmq-4.8.0 ${INSTALLATION_PATH}/rocketmq-4.8.0/
#RUN chmod +x -R ${INSTALLATION_PATH}/rocketmq-4.8.0
#ENV MQ_HOME ${INSTALLATION_PATH}/rocketmq-4.8.0
## Setup RocketMQ end --
#
#COPY startup.sh mq-startup.sh
#RUN chmod +x -R mq-startup.sh
#
#ENTRYPOINT ["sh","mq-startup.sh"]