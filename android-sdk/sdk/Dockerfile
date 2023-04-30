ARG image_path=""
FROM ${image_path}android-sdk:base

# SDK version should be specified via build args
ARG sdk
RUN : \
    "${sdk:?"Compile SDK version should be specified via '--build-arg sdk'"}"
ENV ANDROID_COMPILE_SDK=$sdk

# Install SDK
RUN yes | sdkmanager --update && \
    yes | sdkmanager \
      "platforms;android-$ANDROID_COMPILE_SDK" && \
    rm -rf "$ANDROID_USER_HOME/cache"
