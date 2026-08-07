# syntax=docker/dockerfile:1
#
# android-emu-atd — CI image for instrumented (UI) tests via Gradle Managed Devices (GMD).
#
# Unlike the experimental `android-emu` image (manual model: baked AVD + snapshot +
# start-emulator, google_apis, one API level per image), this image does NOT bake an
# AVD/snapshot: the GMD task owns the emulator lifecycle. The image only adds what is
# missing in android-sdk — emulator runtime libs, the `emulator` package and the system
# images. A single image carries EVERY matrix level (30, 31, 34, 37.0), so a device
# matrix can be served from one `image:`.
#
# ATD (Automated Test Device) — system images optimized for headless runs, without Google APIs.
# Google publishes ATD up to android-36 only, so API 37.0 falls back to a regular
# `google_apis` image: bigger and not headless-optimized, but the only x86_64 option there.
# /dev/kvm is not part of the image: the runner must pass the device through
# (on red_mad_robot CI — the runner tagged `android`).
#
# The list of system images must match both the apiLevel and the systemImageSource of the
# managed devices declared by the consuming project (testOptions.managedDevices):
# `aosp-atd` for the ATD levels, `google` for 37.0.

FROM ghcr.io/redmadrobot/android/android-sdk:36

ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
  set -eu
  # Emulator runtime libs: without libX11.so.6 the launcher fails at startup
  # (error while loading shared libraries).
  apt-get update --yes
  apt-get install --yes --no-install-recommends \
    libx11-6 libx11-xcb1 libxcb1 libxext6 libxdamage1 libxfixes3 \
    libxcomposite1 libxcursor1 libxi6 libxrender1 libxtst6 \
    libnss3 libnspr4 libpulse0 libasound2 libgl1
  rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
  set -eu
  # The `emulator` package and the system images for the GMD matrix. Licenses are accepted here too.
  # Package ids are exact: API 31 has no 32-bit x86 ATD image (x86 ATD stops at API 30),
  # and 37.0 keeps its minor version — there is no flat `android-37` in system-images.
  yes | sdkmanager --licenses > /dev/null
  yes | sdkmanager \
    "emulator" \
    "system-images;android-30;aosp_atd;x86" \
    "system-images;android-31;aosp_atd;x86_64" \
    "system-images;android-34;aosp_atd;x86_64" \
    "system-images;android-37.0;google_apis;x86_64"
  rm -rf "$ANDROID_USER_HOME/cache"
EOF

RUN <<EOF
  set -eu
  # Build-time sanity check: the launcher links without missing libs.
  # (accel-check needs /dev/kvm at runtime, so only lib integrity is verified here.)
  "$ANDROID_HOME/emulator/emulator" -version | head -1
  if ldd "$ANDROID_HOME/emulator/emulator" | grep -q "not found"; then
    echo "ERROR: emulator has missing shared libraries" >&2
    ldd "$ANDROID_HOME/emulator/emulator" | grep "not found" >&2
    exit 1
  fi
  echo "emulator libs OK"
EOF
