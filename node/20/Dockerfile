FROM node:20-bookworm
LABEL maintainer="Christian WALDBILLIG <christian@waldbillig.io>"
LABEL org.opencontainers.image.source="https://github.com/chrecht/docker-library"

#####################################
# Base OS Update, install FFMPEG & MediaInfo
#####################################
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && curl -O https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb \
    && dpkg -i deb-multimedia-keyring_2024.9.1_all.deb \
    && echo "deb http://www.deb-multimedia.org bookworm main non-free" >> /etc/apt/sources.list \
    && echo "deb http://www.deb-multimedia.org bookworm-backports main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y zip unzip wget imagemagick --no-install-recommends \
    && apt-get install -t bookworm-backports -y ffmpeg mediainfo  --no-install-recommends \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
