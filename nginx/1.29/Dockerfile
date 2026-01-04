FROM nginx:1.29-bookworm
LABEL maintainer="Christian WALDBILLIG <christian@waldbillig.io>"
LABEL org.opencontainers.image.source="https://git.waldbillig.io/chrecht/docker-library"

#####################################
# Base OS Update
#####################################
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
