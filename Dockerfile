FROM ubuntu:16.04

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
	&& apt-get install -y x11vnc \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common \
  && apt-get install -y dos2unix

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS
RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh
RUN chmod a+x ibgateway-stable-standalone-linux-x64.sh

# Setup  IBController
RUN mkdir -p /opt/IBController/ && mkdir -p /opt/IBController/Logs
WORKDIR /opt/IBController/
RUN wget -q https://github.com/IbcAlpha/IBC/releases/download/3.10.0/IBCLinux-3.10.0.zip
RUN unzip ./IBCLinux-3.10.0.zip
RUN chmod -R u+x *.sh && chmod -R u+x scripts/*.sh

WORKDIR /

# Install TWS
RUN yes '' | /opt/TWS/ibgateway-stable-standalone-linux-x64.sh

ENV DISPLAY :0

ADD runscript.sh runscript.sh
ADD ./vnc/xvfb_init /etc/init.d/xvfb
ADD ./vnc/vnc_init /etc/init.d/vnc
ADD ./vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

RUN chmod -R u+x runscript.sh \
  && chmod -R 777 /usr/bin/xvfb-daemon-run \
  && chmod 777 /etc/init.d/xvfb \
  && chmod 777 /etc/init.d/vnc

RUN dos2unix /usr/bin/xvfb-daemon-run \
  && dos2unix /etc/init.d/xvfb \
  && dos2unix /etc/init.d/vnc \
  && dos2unix runscript.sh

# Below files copied during build to enable operation without volume mount
COPY ./ib/IBController.ini /root/IBController/IBController.ini
COPY ./ib/jts.ini /opt/IBController/Settings/jts.ini

EXPOSE 4001
EXPOSE 4002
EXPOSE 5900

CMD bash runscript.sh
