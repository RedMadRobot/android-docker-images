# syntax=docker/dockerfile:1

ARG image_path=""
FROM ${image_path}android-sdk:base

ARG sdk
ENV ANDROID_COMPILE_SDK=$sdk

RUN <<EOF
  # Check SDK version specified via build args
  : ${sdk:?"Compile SDK version should be specified via '--build-arg sdk'"}

  yes | sdkmanager --update
  yes | sdkmanager "platforms;android-$ANDROID_COMPILE_SDK"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF
