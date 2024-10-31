FROM flowfuse/node-red:2.9.0-4.0.x
USER root
RUN apk update && \
    apk upgrade
RUN apk add ffmpeg
USER node-red
