# using the official devkitARM image as the base
FROM devkitpro/devkitarm:latest

# stop apt from prompting for user input
ENV DEBIAN_FRONTEND=noninteractive

# install deps for ci/cd runners
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    git \
    curl \
    ca-certificates \
    tar \
    gzip \
    zip \
    unzip \
    jq \
    ffmpeg \
    make \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install the 3ds toolchain and every available 3DS portlib
RUN dkp-pacman -Syyu --noconfirm && \
    dkp-pacman -S --needed --noconfirm 3ds-dev 3ds-portlibs && \
    yes | dkp-pacman -Scc

# download, extract, and install external 3DS tools to /usr/local/bin
RUN mkdir -p /tmp/3dstools && cd /tmp/3dstools && \
    curl -L "https://github.com/dnasdw/3dstool/releases/download/v1.2.6/3dstool_linux_x86_64.tar.gz" -o 3dstool.tar.gz && \
    tar -xzf 3dstool.tar.gz && \
    find . -name "3dstool" -type f -exec mv {} /usr/local/bin/ \; && \
    curl -L "https://github.com/Epicpkmn11/bannertool/releases/download/v1.2.2/bannertool.zip" -o bannertool.zip && \
    unzip -o bannertool.zip && \
    find . -name "bannertool" -type f -exec mv {} /usr/local/bin/ \; && \
    curl -L "https://github.com/3DSGuy/Project_CTR/releases/download/makerom-v0.18.3/makerom-v0.18.3-ubuntu_x86_64.zip" -o makerom.zip && \
    unzip -o makerom.zip && \
    find . -name "makerom" -type f -exec mv {} /usr/local/bin/ \; && \
    curl -L "https://github.com/3DSGuy/Project_CTR/releases/download/ctrtool-v1.1.0/ctrtool-v1.1.0-ubuntu_x86_64.zip" -o ctrtool.zip && \
    unzip -o ctrtool.zip && \
    find . -name "ctrtool" -type f -exec mv {} /usr/local/bin/ \; && \
    chmod +x /usr/local/bin/3dstool /usr/local/bin/bannertool /usr/local/bin/makerom /usr/local/bin/ctrtool && \
    cd / && rm -rf /tmp/3dstools

# set a default working directory
WORKDIR /build
