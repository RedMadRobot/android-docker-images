ARG api_version=30

FROM ghcr.io/redmadrobot/android/android-sdk:${api_version}

ARG api_version
ENV EMULATOR_NAME="EMU_${api_version}"
ENV ANDROID_IMAGES="system-images;android-${api_version};google_apis;x86_64"
ENV DEFAULT_SNAPSHOT="ci"

RUN sdkmanager --verbose --install ${ANDROID_IMAGES}

RUN echo "no" | avdmanager --verbose create avd --force --name ${EMULATOR_NAME} \
    --package ${ANDROID_IMAGES} \
    --abi google_apis/x86_64

RUN apt update -y && \ 
    apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager libguestfs-tools && \
    apt autoclean && apt autoremove

COPY configs/${api_version}.ini $HOME/.android/avd/${EMULATOR_NAME}.avd/config.ini

ADD start_emulator.sh /bin/start-emulator
ADD prepare_snapshot.sh /bin/prepare-snapshot

RUN curl https://github.com/allure-framework/allurectl/releases/latest/download/allurectl_linux_amd64 -Lo /bin/allurectl && \
    chmod +x /bin/allurectl
