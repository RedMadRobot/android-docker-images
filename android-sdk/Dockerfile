# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy

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
ENV ANDROID_USER_HOME="$HOME/.android"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"
ENV PATH="$PATH:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION"

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
ARG commandlinetools_url=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
ARG commandlinetools_sha256=bd1aa17c7ef10066949c88dc6c9c8d536be27f992a1f3b5a584f9bd2ba5646a0

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
