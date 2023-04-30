ARG image_path=""
ARG sdk
FROM ${image_path}android-sdk:${sdk}

ARG ndk
RUN : \
    "${ndk:?"NDK version should be specified via '--build-arg ndk'"}"
ENV ANDROID_NDK_VERSION=$ndk

RUN yes | sdkmanager --update && \
    sdkmanager "ndk;$ANDROID_NDK_VERSION" && \
    rm -rf "$ANDROID_USER_HOME/cache"
