FROM centos:8

ENV EPICS_VER 3.15.8
ENV WORK_DIR /usr/local/epics
ENV USER epics

# Note: Perl complains about the locale a million times.   Can't figure out a way to tell it to shut up and just use en_us.UTF8
RUN yum install -y wget gcc-c++ readline-devel perl-devel make \
    && wget --no-check-certificate https://www.aps.anl.gov/epics/download/base/base-$EPICS_VER.tar.gz \
    && tar -zxvf base-$EPICS_VER.tar.gz \
    && mkdir $WORK_DIR \
    && mv base-$EPICS_VER $WORK_DIR \
    && rm base-$EPICS_VER.tar.gz \
    && cd $WORK_DIR \
    && ln -s base-$EPICS_VER base \
    && echo "export EPICS_HOST_ARCH=linux-x86_64" >> ~/.bashrc \
    && echo "export EPICS_BASE="$WORK_DIR"/base" >> ~/.bashrc \
    && echo "export PATH=$PATH:"$WORK_DIR"/base/bin/linux-x86_64" >> ~/.bashrc \
    && source ~/.bashrc \
    && cd $WORK_DIR/base \
    && make \
    && yum remove -y wget gcc-c++ readline-devel perl-devel make

EXPOSE 5065 5064
