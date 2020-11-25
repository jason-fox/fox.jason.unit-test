#! /bin/sh

# This file is part of the DITA-OT Unit Test Plug-in project.
# See the accompanying LICENSE file for applicable licenses.

ARG DITA_OT_VERSION=3.5.4


FROM adoptopenjdk:11-jre-hotspot
ARG DITA_OT_VERSION


RUN apt-get update && \
    apt-get install -y unzip wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sLo /tmp/dita-ot-"$DITA_OT_VERSION".zip https://github.com/dita-ot/dita-ot/releases/download/"$DITA_OT_VERSION"/dita-ot-"$DITA_OT_VERSION".zip && \
    unzip /tmp/dita-ot-"$DITA_OT_VERSION".zip -d /tmp/ && \
    rm /tmp/dita-ot-"$DITA_OT_VERSION".zip && \
    mkdir -p /opt/app/ && \
    mv /tmp/dita-ot-"$DITA_OT_VERSION"/bin /opt/app/bin && \
    chmod 755 /opt/app/bin/dita && \
    mv /tmp/dita-ot-"$DITA_OT_VERSION"/config /opt/app/config && \
    mv /tmp/dita-ot-"$DITA_OT_VERSION"/lib /opt/app/lib && \
    mv /tmp/dita-ot-"$DITA_OT_VERSION"/plugins /opt/app/plugins && \
    mv /tmp/dita-ot-"$DITA_OT_VERSION"/build.xml /opt/app/build.xml && \
    mv /tmp/dita-ot-"$DITA_OT_VERSION"/integrator.xml /opt/app/integrator.xml && \
    rm -r /tmp/dita-ot-"$DITA_OT_VERSION" && \
    /opt/app/bin/dita --install && \
	/opt/app/bin/dita install https://github.com/doctales/org.doctales.xmltask/archive/master.zip && \
  	/opt/app/bin/dita install https://github.com/jason-fox/fox.jason.unit-test/archive/master.zip

RUN useradd -ms /bin/bash dita-ot && \
    chown -R dita-ot:dita-ot /opt/app

ENV DITA_HOME=/opt/app
ENV PATH="${PATH}":"${DITA_HOME}"/bin

WORKDIR /opt/app/bin/
COPY entrypoint.sh entrypoint.sh
RUN chmod +x /opt/app/bin/entrypoint.sh

ENTRYPOINT ["/opt/app/bin/entrypoint.sh"]