FROM centos:7.8.2003 AS builder

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
    && rm -rf $WORK_DIR/base/src

# Slim image (413MB -> 49.5MB) by using busybox
RUN mkdir /deps \
   && cp --parents /lib64/libstdc++.so.6 /deps \
   && cp --parents /lib64/libm.so.6 /deps \
   && cp --parents /lib64/libgcc_s.so.1 /deps \
   && cp --parents /lib64/libreadline.so.6 /deps \
   && cp --parents /lib64/librt.so.1 /deps \
   && cp --parents /lib64/libdl.so.2 /deps \
   && cp --parents /lib64/libtinfo.so.5 /deps

FROM busybox:1.31.1-glibc

ENV PATH=/usr/local/epics/base/bin/linux-x86_64:$PATH

WORKDIR /usr/local/epics
COPY --from=builder /usr/local/epics .
WORKDIR /
COPY --from=builder /deps/lib64/*.so.* /lib64/

EXPOSE 5065 5064

ENTRYPOINT ["softIoc"]
CMD ["-d", "/db/softioc.db"]
