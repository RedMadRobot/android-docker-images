# syntax=docker/dockerfile:1
#
# android-emu-atd — CI-образ для instrumented (UI) тестов через Gradle Managed Devices (GMD).
#
# В отличие от experimental `android-emu` (ручная модель: запечённый AVD + snapshot +
# start-emulator, google_apis, один API на образ) — этот образ НЕ бейкает AVD/snapshot:
# lifecycle эмулятора управляет сама GMD-задача (`:app:ciAtdDebugAndroidTest`). Образ лишь
# докладывает то, чего нет в android-sdk:34 — рантайм-либы, пакет `emulator` и ATD-образы.
# Один образ несёт ОБА уровня матрицы (30 x86 + 34 x86_64), чтобы обслуживать её из одного `image:`.
#
# ATD (Automated Test Device) — headless-оптимизированные образы без Google APIs.
# /dev/kvm сюда не входит — это проброс устройства на раннере (тег `android`), не часть образа.
#
# Список system-images должен совпадать с apiLevel в проекте
# (app/build.gradle.kts → testOptions.managedDevices: ciAtd=30, ciAtd34=34).

FROM ghcr.io/redmadrobot/android/android-sdk:34

ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
  # Рантайм-либы эмулятора: без libX11.so.6 лаунчер падает на старте (error loading shared libraries).
  apt-get update --yes
  apt-get install --yes --no-install-recommends \
    libx11-6 libx11-xcb1 libxcb1 libxext6 libxdamage1 libxfixes3 \
    libxcomposite1 libxcursor1 libxi6 libxrender1 libxtst6 \
    libnss3 libnspr4 libpulse0 libasound2 libgl1
  rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
  # Пакет emulator + ATD system-images под матрицу GMD. Лицензии принимаются здесь же.
  yes | sdkmanager --licenses > /dev/null
  yes | sdkmanager \
    "emulator" \
    "system-images;android-30;aosp_atd;x86" \
    "system-images;android-34;aosp_atd;x86_64"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF

RUN <<EOF
  # Build-time sanity: лаунчер линкуется без missing-libs.
  # (accel-check требует /dev/kvm в рантайме — здесь проверяем только целостность либ.)
  "$ANDROID_HOME/emulator/emulator" -version | head -1
  if ldd "$ANDROID_HOME/emulator/emulator" | grep -q "not found"; then
    echo "ERROR: emulator has missing shared libraries" >&2
    ldd "$ANDROID_HOME/emulator/emulator" | grep "not found" >&2
    exit 1
  fi
  echo "emulator libs OK"
EOF
