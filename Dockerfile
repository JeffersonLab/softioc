FROM alpine:latest

# Maybe we can figure out how to build epics-base from Jenkins?  https://jenkins.aps.anl.gov/job/epics-base-3.15/503/consoleFull
RUN apk --no-cache add libstdc++ readline \
  && apk --no-cache add --virtual .build-deps cmake g++ make perl-dev readline-dev \
  && mkdir /epics/ \
  && cd /epics/ \
  && wget --no-check-certificate --quiet https://epics.anl.gov/download/base/base-3.16.2.tar.gz -O EPICS.tar.gz \
  && tar xzf EPICS.tar.gz \
  && mv base-*/ base/ \
  && rm EPICS.tar.gz \
  && cd /epics/base \
  && export EPICS_BASE=/epics/base/ \
  && export EPICS_HOST_ARCH='linux-x86_64' \
  && make -j4 CFLAGS="-DIPPORT_USERRESERVED=5000 -fPIC" CXXFLAGS="-DIPPORT_USERRESERVED=5000 -fPIC" \
  && make clean \
  && mkdir /epics/softioc \
  && makeBaseApp.pl -t softioc -i -a linux-x86_64 softioc \
  && apk del --purge .build-deps

EXPOSE 5065 5064

ENV PATH $PATH:/epics/base/bin/linux-x86_64/
