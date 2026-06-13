FROM ubuntu:26.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libglib-perl \
    libglib-object-introspection-perl \
    libipc-run-perl \
    libjson-perl \
    libset-scalar-perl \
    libxml-libxml-perl \
    libxml-libxslt-perl \
    gir1.2-appstream \
    openjdk-17-jdk \
    build-essential \
    glslc \
    gobject-introspection \
    libglib2.0-dev-bin \
    libxml2-utils \
    ninja-build \
    sassc \
    git \
    curl \
    less \
    nano \
    unzip \
    wget \
    python3.14-venv \
    python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install pixiewood
RUN cd ~ && git clone https://github.com/sp1ritCS/gtk-android-builder.git \
  && cd gtk-android-builder \
  && make install

USER ubuntu
WORKDIR /home/ubuntu

# Fetch and install Android command line tools
RUN mkdir -p ~/Android/Sdk/cmdline-tools \
  && cd ~/Android/Sdk/cmdline-tools \
  && wget https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
  && unzip commandlinetools-linux-14742923_latest.zip \
  && rm commandlinetools-linux-14742923_latest.zip \
  && mv cmdline-tools latest

# Set Android environment variables
ENV ANDROID_HOME="/home/ubuntu/Android/Sdk"
ENV ANDROID_NDK_HOME="${ANDROID_HOME}/ndk/29.0.14206865"

# Add important directories to PATH
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools:${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin"

# Accept licenses and install SDK components + NDK
RUN yes | sdkmanager --licenses \
  && sdkmanager --update \
  && sdkmanager \
    "platform-tools" \
    "build-tools;36.0.0" \
    "platforms;android-36" \
    "cmake;3.22.1" \
  && sdkmanager "ndk;29.0.14206865"

# Install mini-studio
RUN git clone https://github.com/sp1ritCS/mini-studio.git ~/mini-studio

# Install LDC and Dub
RUN mkdir -p ~/dlang && wget https://dlang.org/install.sh -O ~/dlang/install.sh && chmod 755 ~/dlang/install.sh
RUN ~/dlang/install.sh ldc
RUN ~/dlang/install.sh dub

# Install Android aarch64 D runtime/Phobos libraries
RUN cd ~/dlang \
  && wget https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc2-1.42.0-android-aarch64.tar.xz \
  && tar xf ldc2-1.42.0-android-aarch64.tar.xz \
  && mv ldc2-1.42.0-android-aarch64/lib ~/dlang/ldc-1.42.0/lib-android_aarch64 \
  && mv ldc2-1.42.0-android-aarch64/lib-android-x86_64 ~/dlang/ldc-1.42.0/lib-android_x86_64 \
  && rm -rf ~/dlang/ldc2-1.42.0-android-aarch64*

# Create Python venv and install Meson 1.11.1
RUN python3 -m venv ~/venv \
  && . ~/venv/bin/activate \
  && pip install meson==1.11.1

# Patch meson
COPY meson.patch /home/ubuntu/
RUN patch -p0 < meson.patch

# Copy android cross-compile ldc2 conf
COPY ldc2.conf /home/ubuntu/dlang/ldc-1.42.0/etc/ldc2.conf/40-android.conf

# Update .bashrc to active LDC and Python venv environments
RUN echo ". ~/dlang/ldc-1.42.0/activate" >>~/.bashrc
RUN echo ". ~/venv/bin/activate" >>~/.bashrc

# Final working directory for builds
WORKDIR /build
