FROM ubuntu
ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV TZ=Asia/Shanghai
ENV SCREEN_RESOLUTION=1280x900
ENV VNC_PASSWORD=123456
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
USER root
WORKDIR /root
COPY extensions /root/
RUN echo 'repo_add_once=false' > /etc/default/google-chrome
RUN apt-get update && apt-get --no-install-recommends -y install xvfb x11vnc supervisor fluxbox git-core git ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy wget gnupg unzip thunar \
    && wget http://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_79.0.3945.130-1_amd64.deb \
    && apt install --no-install-recommends -f -y /root/google-chrome-stable_79.0.3945.130-1_amd64.deb && rm -f /root/google-chrome-stable_79.0.3945.130-1_amd64.deb \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/novnc/noVNC.git && ln -s /root/noVNC/vnc_auto.html /root/noVNC/index.html \
    && git clone https://github.com/novnc/websockify /root/noVNC/utils/websockify
COPY supervisiord.conf /etc/supervisor/conf.d/supervisord.conf
ENV DISPLAY=:0
EXPOSE 5900
EXPOSE 8083
CMD ["/usr/bin/supervisord"]