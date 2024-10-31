FROM nodered/node-red:4.0.5
USER root
RUN apk update && \
    apk upgrade
RUN apk add ffmpeg
USER node-red
