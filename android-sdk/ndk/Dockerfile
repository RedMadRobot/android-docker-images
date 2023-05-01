# syntax=docker/dockerfile:1

ARG image_path=""
ARG sdk
FROM ${image_path}android-sdk:${sdk}

ARG ndk
ENV ANDROID_NDK_VERSION=$ndk

RUN <<EOF
  # Check NDK version specified via build args
  : ${ndk:?"NDK version should be specified via '--build-arg ndk'"}

  yes | sdkmanager --update
  yes | sdkmanager "ndk;$ANDROID_NDK_VERSION"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF
