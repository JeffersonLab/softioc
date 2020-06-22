FROM centos:7

# Defined in separate layer so it can be nested in another ENV
ENV WORK_DIR=/usr/local/epics

ENV EPICS_VER=3.15.8 \
    USER=epics \
    EPICS_BASE=$WORK_DIR/base \
    EPICS_HOST_ARCH=linux-x86_64 \
    PATH=$PATH:$WORK_DIR/base/bin/linux-x86_64

RUN yum install -y wget gcc-c++ readline-devel perl-devel make  \
    #http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && wget --no-check-certificate https://www.aps.anl.gov/epics/download/base/base-$EPICS_VER.tar.gz \
    && tar -zxvf base-$EPICS_VER.tar.gz \
    && mkdir $WORK_DIR \
    && mv base-$EPICS_VER $WORK_DIR \
    && rm base-$EPICS_VER.tar.gz \
    && cd $WORK_DIR \
    && ln -s base-$EPICS_VER base \
    && cd $WORK_DIR/base \
    && make \
    #&& cd $WORK_DIR \
    #&& mkdir softioc \
    #&& cd softioc \
    #&& $WORK_DIR/base/bin/linux-x86_64/makeBaseApp.pl -t ioc -a linux-x86_64 softioc \
    #&& $WORK_DIR/base/bin/linux-x86_64/makeBaseApp.pl -i ioc -a linux-x86_64 softioc \
    #&& make \
    && yum remove -y wget gcc-c++ readline-devel perl-devel make \
    && printf "#!/bin/bash \nsoftIoc -s -d /db/softioc.db" >> /usr/local/bin/start.sh \
    #&& printf "#!/bin/bash \nprocServ -n 'Soft IOC' -i ^D^C 20000 /usr/local/bin/start.sh &> /dev/null" >> /usr/local/bin/init.sh \
    && chmod +x /usr/local/bin/start.sh \
    #&& chmod +x /usr/local/bin/init.sh \
    && mkdir /db \
    && ln -s /usr/local/epics/softioc/db /db

#RUN yum install -y procServ

EXPOSE 5065 5064

ENTRYPOINT ["/usr/local/bin/start.sh"]