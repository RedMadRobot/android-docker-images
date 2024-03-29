# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy AS base

# Specify build tools version.
# Use the latest available version by default.
# https://developer.android.com/tools/releases/build-tools
ARG build_tools="34.0.0"
ENV ANDROID_BUILD_TOOLS_VERSION=$build_tools

# Define Android environment variables
# https://developer.android.com/tools/variables
# Keep in mind, variable can't be declared and used in the same ENV instructuion
ENV HOME="/root"
ENV ANDROID_HOME="/opt/android-sdk" \
    ANDROID_USER_HOME="$HOME/.android"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"
ENV PATH="$PATH:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION"

# Make apt-get non-interactive
ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
  # Install required tools (keep it sorted)
  #  libncurses5 is required by llvm-rs-cc (build-tools before 30.0.3)
  apt-get update --yes
  apt-get install --yes --no-install-recommends \
          git \
          libncurses5 \
          python3 \
          python3-pip \
          unzip \
          zip
  rm -rf /var/lib/apt/lists/*

  # Setup locale
  localedef -i en_US -c -f UTF-8 \
            -A /usr/share/locale/locale.alias en_US.UTF-8
EOF

# Commandline Tools revisions: https://developer.android.com/studio#command-line-tools-only
# NOTE: Remember to update cmdline-tools-package.xml on commandlinetools update.
ARG commandlinetools_url=https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
ARG commandlinetools_sha256=2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258

WORKDIR $ANDROID_HOME
RUN <<EOF
  # Download and install Android Commandline Tools
  wget --quiet --output-document=commandlinetools.zip ${commandlinetools_url}
  echo "$commandlinetools_sha256 commandlinetools.zip" | sha256sum --check

  unzip -qq commandlinetools.zip -d tmp/
  mkdir cmdline-tools/
  mv tmp/cmdline-tools cmdline-tools/latest
  rm -rf tmp commandlinetools.zip

  # Workaround for "Warning: File .android/repositories.cfg could not be loaded."
  mkdir --parents ${ANDROID_USER_HOME}
  touch "$ANDROID_USER_HOME/repositories.cfg"

  # Accept licenses and install build tools and platform tools
  # https://developer.android.com/tools/releases/build-tools
  # https://developer.android.com/tools/releases/platform-tools
  yes | sdkmanager --licenses
  yes | sdkmanager \
    "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
    "platform-tools"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF

# Make cmdline-tools visible for sdkmanager
COPY cmdline-tools-package.xml "cmdline-tools/latest/package.xml"

WORKDIR $HOME


FROM base AS sdk

ARG sdk
ENV ANDROID_COMPILE_SDK=$sdk

RUN <<EOF
  # Check SDK version specified via build args
  : ${sdk:?"Compile SDK version should be specified via '--build-arg sdk'"}

  yes | sdkmanager --update
  yes | sdkmanager "platforms;android-$ANDROID_COMPILE_SDK"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF


FROM sdk AS ndk

ARG ndk
ENV ANDROID_NDK_VERSION=$ndk

RUN <<EOF
  # Check NDK version specified via build args
  : ${ndk:?"NDK version should be specified via '--build-arg ndk'"}

  yes | sdkmanager --update
  yes | sdkmanager "ndk;$ANDROID_NDK_VERSION"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF
