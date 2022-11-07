#!/usr/bin/env bash
# Install required libraries for 64-bit machine
# https://developer.android.com/studio/install#64bit-libs

set -e

arch=$(dpkg --print-architecture)
if [[ $arch == amd64 ]]; then
  dpkg --add-architecture i386
  apt-get update --yes
  apt-get install --yes --no-install-recommends \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    lib32z1 \
    libbz2-1.0:i386
  rm -rf /var/lib/apt/lists/*
else
  echo "Current arch is '$arch'. Skipping."
fi
