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

# Fetch and install Android command line tools
RUN mkdir -p ~/Android/Sdk/cmdline-tools \
  && cd ~/Android/Sdk/cmdline-tools \
  && wget https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
  && unzip commandlinetools-linux-14742923_latest.zip \
  && rm commandlinetools-linux-14742923_latest.zip \
  && mv cmdline-tools latest

# Set Android environment variables
ENV ANDROID_HOME=/root/Android/Sdk
ENV ANDROID_NDK_HOME="${ANDROID_HOME}/ndk/27.3.13750724"

# Add the important directories to PATH
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools:${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin"

# Accept Android SDK licenses and install SDK tools and NDX
RUN yes | sdkmanager --licenses \
  && sdkmanager --update \
  && sdkmanager \
    "platform-tools" \
    "build-tools;36.0.0" \
    "platforms;android-36" \
    "cmake;3.22.1" \
  && sdkmanager "ndk;29.0.14206865"

# Update .bashrc
RUN cat >> /root/.bashrc << 'EOF'

# Android SDK
export ANDROID_HOME=/root/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/27.3.13750724

export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools"
export PATH="$PATH:$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin"
EOF

# Install mini-studio
RUN cd ~/ && git clone https://github.com/sp1ritCS/mini-studio.git

# Install ldc and dub
RUN mkdir -p ~/dlang && wget https://dlang.org/install.sh -O ~/dlang/install.sh && chmod 755 ~/dlang/install.sh
RUN ~/dlang/install.sh ldc
RUN ~/dlang/install.sh dub

# Install android-aarch64 D runtime/phobos libraries
RUN cd ~/dlang \
  && wget https://github.com/ldc-developers/ldc/releases/download/v1.42.0/ldc2-1.42.0-android-aarch64.tar.xz \
  && tar xf ldc2-1.42.0-android-aarch64.tar.xz \
  && mv ldc2-1.42.0-android-aarch64/lib ~/dlang/ldc-1.42.0/lib-android_aarch64

# Add ldc2 activate script to .bashrc
RUN echo ". ~/dlang/ldc-1.42.0/activate" >> ~/.bashrc

# Create a python virtual environment and install meson
RUN cd ~/ && python3 -m venv venv \
  && . ~/venv/bin/activate \
  && pip install meson==1.11.1

# Add Python venv activation to .bashrc
RUN echo ". /root/venv/bin/activate" >> ~/.bashrc

# Patch meson
COPY meson.patch /root
RUN cd /root && patch -p0 <meson.patch

# Copy android cross-compile ldc2 conf
COPY ldc2.conf /root/dlang/ldc-1.42.0/etc/ldc2.conf/40-android.conf
