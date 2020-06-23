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
    && printf "#!/bin/sh \nsoftIoc -s -d /db/softioc.db" >> /usr/local/epics/start.sh \
    && chmod +x /usr/local/epics/start.sh \
    && mkdir /db

# TODO: Slim image by 90% or so if we can figure out how to run on busybox (413MB -> ?)
#RUN mkdir /deps \
#   && cp --parents /lib64/libstdc++.so.6 /deps \
#   && cp --parents /lib64/libm.so.6 /deps \
#   && cp --parents /lib64/libgcc_s.so.1 /deps \
#   && cp --parents /lib64/libc.so.6 /deps \
#   && cp --parents /lib64/libpthread.so.0 /deps \
#   && cp --parents /lib64/libreadline.so.6 /deps \
#   && cp --parents /lib64/librt.so.1 /deps \
#   && cp --parents /lib64/libdl.so.2 /deps \
#   && cp --parents /lib64/ld-linux-x86-64.so.2 /deps \
#   && cp --parents /lib64/libtinfo.so.5 /deps

#FROM busybox:glibc
#WORKDIR /usr/local/epics
#COPY --from=builder /usr/local/epics .
#WORKDIR /
#COPY --from=builder /deps/lib64/*.so.* /lib64/

EXPOSE 5065 5064

ENTRYPOINT ["/usr/local/epics/start.sh"]