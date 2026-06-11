FROM ubuntu:26.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
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
    meson \
    ninja-build \
    sassc \
    git \
    curl \
    less \
    nano \
    unzip \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN cd ~ && git clone https://github.com/sp1ritCS/gtk-android-builder.git \
  && cd gtk-android-builder \
  && make install

RUN mkdir -p ~/Android/Sdk/cmdline-tools

RUN cd ~/Android/Sdk/cmdline-tools \
  && wget https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
  && unzip commandlinetools-linux-14742923_latest.zip \
  && mv cmdline-tools latest

  # Set Android environment variables (best practice for Docker)
ENV ANDROID_HOME=/root/Android/Sdk \
    ANDROID_SDK_ROOT=/root/Android/Sdk \
    ANDROID_NDK_HOME=/root/Android/Sdk/ndk/27.3.13750724

# Add the important directories to PATH
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin" \
    PATH="${PATH}:${ANDROID_HOME}/platform-tools" \
    PATH="${PATH}:${ANDROID_HOME}/build-tools" \
    PATH="${PATH}:${ANDROID_HOME}/ndk/27.3.13750724/toolchains/llvm/prebuilt/linux-x86_64/bin"

RUN cd $ANDROID_HOME/cmdline-tools/latest/bin \
  && yes | ./sdkmanager --licenses \
  && ./sdkmanager --update \
  && ./sdkmanager \
    "platform-tools" \
    "build-tools;36.0.0" \
    "platforms;android-36" \
    "cmake;3.22.1" \
  && ./sdkmanager "ndk;29.0.14206865"

# Optional: Also update root's .bashrc for interactive shell sessions
RUN cat >> /root/.bashrc << 'EOF'

# Android SDK
export ANDROID_HOME=/root/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/27.3.13750724

export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools"
export PATH="$PATH:$ANDROID_HOME/ndk/27.3.13750724/toolchains/llvm/prebuilt/linux-x86_64/bin"
EOF

RUN cd ~/ && git clone https://github.com/sp1ritCS/mini-studio.git

RUN mkdir -p ~/dlang && wget https://dlang.org/install.sh -O ~/dlang/install.sh && chmod 755 ~/dlang/install.sh

RUN ~/dlang/install.sh ldc
RUN ~/dlang/install.sh dub

RUN echo ". ~/dlang/ldc-1.42.0/activate" >> ~/.bashrc

COPY meson.patch /root
RUN cd / && patch -p0 </root/meson.patch

COPY ldc2.conf /root/dlang/ldc-1.42.0/etc/ldc2.conf/40-android.conf
