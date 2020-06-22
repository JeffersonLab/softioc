FROM centos:8

ENV WORK_DIR=/usr/local/epics

ENV EPICS_VER=3.15.8 \
    USER=epics \
    EPICS_BASE=$WORK_DIR/base \
    EPICS_HOST_ARCH=linux-x86_64 \
    PATH=$PATH:$WORK_DIR/base/bin/linux-x86_64

# Note: Perl complains about the locale a million times.   Can't figure out a way to tell it to shut up and just use en_us.UTF8
RUN yum install -y wget gcc-c++ readline-devel perl-devel make \
    && wget --no-check-certificate https://www.aps.anl.gov/epics/download/base/base-$EPICS_VER.tar.gz \
    && tar -zxvf base-$EPICS_VER.tar.gz \
    && mkdir $WORK_DIR \
    && mv base-$EPICS_VER $WORK_DIR \
    && rm base-$EPICS_VER.tar.gz \
    && cd $WORK_DIR \
    && ln -s base-$EPICS_VER base \
    && cd $WORK_DIR/base \
    && make

RUN cd $WORK_DIR \
    && mkdir softioc \
    && cd softioc \
    && $WORK_DIR/base/bin/linux-x86_64/makeBaseApp.pl -t ioc -a linux-x86_64 softioc \
    && $WORK_DIR/base/bin/linux-x86_64/makeBaseApp.pl -i ioc -a linux-x86_64 softioc \
    && make \
    && yum remove -y wget gcc-c++ readline-devel perl-devel make \
    && echo "cd $WORK_DIR/softioc/iocBoot/softioc && ../../bin/linux-x86_64/softioc st.cmd" >> /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh

EXPOSE 5065 5064

#CMD ["/usr/local/bin/start.sh"]