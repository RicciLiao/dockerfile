# Base Image
FROM centos:centos7

# Implementor
MAINTAINER R.LIEW
LABEL description="Base on centOS7"

ENV REFRESHED_AT 2024.08
ENV LANG C.UTF-8

ARG RESOURCE_PATH=resources
ARG INSTALLATION_PATH=/usr/share

# Setup Elasticsearch start --
ARG ES_PATH=${INSTALLATION_PATH}/elasticsearch
ARG ES_VERSION=8.15.0
ENV PATH $PATH:$ES_PATH

RUN mkdir -p ${ES_PATH}

ADD ${RESOURCE_PATH}/elasticsearch-${ES_VERSION}.tar.gz ${ES_PATH}

RUN cp ${ES_PATH}/tini-amd64 /sbin/tini \
 && chmod +x -R /sbin/tini \
 && cp ${ES_PATH}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \
 && groupadd -g 1000 elasticsearch \
 && adduser -u 1000 -g 1000 -G 0 -d ${ES_PATH} elasticsearch \
 && chown -R 1000:1000 ${ES_PATH}

EXPOSE 9200
EXPOSE 9300

CMD ["eswrapper"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
USER 1000:0
# Setup Elasticsearch end --
