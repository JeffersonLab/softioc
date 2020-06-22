FROM centos:7 AS builder

ENV WORK_DIR=/usr/local/epics

ENV EPICS_VER=3.15.8 \
    USER=epics \
    EPICS_BASE=$WORK_DIR/base \
    EPICS_HOST_ARCH=linux-x86_64 \
    PATH=$PATH:$WORK_DIR/base/bin/linux-x86_64

RUN yum install -y wget gcc-c++ readline-devel perl-devel make  \
    && wget --no-check-certificate https://www.aps.anl.gov/epics/download/base/base-$EPICS_VER.tar.gz \
    && tar -zxvf base-$EPICS_VER.tar.gz \
    && mkdir $WORK_DIR \
    && mv base-$EPICS_VER $WORK_DIR \
    && rm base-$EPICS_VER.tar.gz \
    && cd $WORK_DIR \
    && ln -s base-$EPICS_VER base \
    && cd $WORK_DIR/base \
    && make \
    && yum remove -y wget gcc-c++ readline-devel perl-devel make \
    && printf "#!/bin/sh \nsoftIoc -s -d /db/softioc.db" >> /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh \
    && mkdir /db \
    && ln -s /usr/local/epics/softioc/db /db

# TODO: Slim image by 90% or so if we can figure out how to run on busybox (dynamic linked libc++ and others missing)
#FROM busybox:glibc
#WORKDIR /usr/local/epics
#COPY --from=builder /usr/local/epics .
#WORKDIR /usr/local/bin
#COPY --from=builder /usr/local/bin .


EXPOSE 5065 5064

ENTRYPOINT ["/usr/local/bin/start.sh"]