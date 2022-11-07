FROM eclipse-temurin:11-jdk-jammy

# Specify build tools version
ARG build_tools
RUN : \
    "${build_tools:?"Build tools version should be specified via '--build-arg build_tools'"}"
ENV ANDROID_BUILD_TOOLS_VERSION=$build_tools

# Make Ubuntu non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Define Android SDK path variables
ENV HOME="/root"
ENV ANDROID_HOME="/opt/android-sdk"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
ENV PATH="$PATH:$ANDROID_HOME/tools/bin"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"
ENV PATH="$PATH:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION"

# Install required tools
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
            git \
            zip \
            unzip \
            python3 \
            python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install required libraries for 64-bit machine
# https://developer.android.com/studio/install#64bit-libs
COPY amd64-install-libs.sh /tmp/
RUN /tmp/amd64-install-libs.sh

# Setup locale
RUN localedef -i en_US -c -f UTF-8 \
                  -A /usr/share/locale/locale.alias en_US.UTF-8

# Download and install Android Commandline Tools
# Commandline Tools revisions: https://developer.android.com/studio#command-line-tools-only
# NOTE: Remember to update cmdline-tools-package.xml on commandlinetools update.
WORKDIR $ANDROID_HOME
RUN wget --quiet --output-document=commandlinetools.zip \
         https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
    unzip -qq commandlinetools.zip -d tmp/ && \
    mkdir -p cmdline-tools/latest/ && \
    mv tmp/cmdline-tools/* cmdline-tools/latest/ && \
    rm -rf tmp commandlinetools.zip
# Make cmdline-tools visible for sdkmanager
COPY cmdline-tools-package.xml "cmdline-tools/latest/package.xml"
WORKDIR $HOME

# Workaround for
# Warning: File .android/repositories.cfg could not be loaded.
RUN mkdir -p .android && \
    touch .android/repositories.cfg

# Update SDK manager and install system image, platform and build tools
RUN yes | sdkmanager --licenses && \
    yes | sdkmanager --update && \
    yes | sdkmanager \
      "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
      "extras;android;m2repository" \
      "extras;google;google_play_services" \
      "extras;google;m2repository"
