FROM alpine:latest

RUN apt-get update \ 
  && apt-get install -y make g++ perl libreadline7 libreadline-dev wget \
  && apt-get autoremove -y \
  && apt-get clean all \
  && mkdir /epics/ \
  && cd /epics/ \
  && wget --quiet https://epics.anl.gov/download/base/base-3.16.2.tar.gz -O EPICS.tar.gz \
  && tar xzf EPICS.tar.gz \
  && mv base-*/ base/ \
  && rm EPICS.tar.gz \
  && cd /epics/base \
  && export EPICS_BASE=/epics/base/ \
  && export EPICS_HOST_ARCH='linux-x86_64' \
  && make \
  && apt-get remove -y --purge make g++ perl wget
  
EXPOSE 5065 5064

ENV PATH $PATH:/epics/base/bin/linux-x86_64/
