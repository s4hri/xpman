ARG DOCKER_SRC

FROM ${DOCKER_SRC} AS base
LABEL maintainer="Davide De Tommaso <davide.detommaso@iit.it>, Adam Lukomski <adam.lukomski@iit.it>"

ENV DEBIAN_FRONTEND noninteractive

ARG LOCAL_USER_ID
ARG NVIDIA_ENV=0
ARG GROUP_AUDIO
ARG GROUP_VIDEO
ARG GROUP_INPUT

USER root

ENV LOCAL_USER_ID=${LOCAL_USER_ID}
ENV NVIDIA_ENV=${NVIDIA_ENV}
ENV GROUP_INPUT=${GROUP_INPUT}
ENV GROUP_VIDEO=${GROUP_VIDEO}
ENV GROUP_AUDIO=${GROUP_AUDIO}

RUN if [ "$NVIDIA_ENV" = 1 ] ; then apt-get update && apt-get install -y --no-install-recommends \
      libxau6 libxdmcp6 libxcb1 libxext6 libx11-6 && \
  export NVIDIA_VISIBLE_DEVICES=all && \
  export NVIDIA_DRIVER_CAPABILITIES=graphics,utility && \
  /bin/sh -c echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
  echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
  export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu:/usr/local/nvidia/lib:/usr/local/nvidia/lib64 && \
  apt-get update && apt-get install -y --no-install-recommends  \
      libglvnd0 libgl1 libglx0 libegl1 libgles2 && \
  apt-get update && apt-get install -y --no-install-recommends  \
      pkg-config libglvnd-dev libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev ; fi

RUN usermod -u ${LOCAL_USER_ID} docky
RUN usermod -a -G root,sudo,${GROUP_AUDIO},${GROUP_VIDEO},${GROUP_INPUT} docky
USER docky
