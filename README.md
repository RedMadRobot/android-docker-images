# red_mad_robot Android Docker Images

Set of docker images used by red_mad_robot Android team.
All images are published in [GitHub Container Registry][ghcr].

---

## android-sdk

### android-sdk:base

> `ghcr.io/redmadrobot/android/android-sdk:base`

Base Android image. All other android images are built on top of this image.

**Base image**: `eclipse-temurin:11-jdk-jammy` \
**Packages:**

- sdkmanager:
    - cmdline-tools;latest
    - platform-tools
    - build-tools;**30.0.3**
    - extras;android;m2repository
    - extras;google;google_play_services
    - extras;google;m2repository"
- python3
- git
- zip, unzip

### android-sdk:[x]

> `ghcr.io/redmadrobot/android/android-sdk:[x]`

Where `[x]` is one of API levels:

- 33 (Android 13)
- 32 (Android 12L)
- 31 (Android 12)
- 30 (Android 11)

### android-sdk:[x]-ndk

> `ghcr.io/redmadrobot/android/android-sdk:[x]-ndk` \
> `ghcr.io/redmadrobot/android/android-sdk:[x]-ndk-[y]`

Where `[x]` is SDK version and `[y]` is NDK version (optionally).

**NDK version**: 25.1.8937393

<details>
<summary>Other images</summary>

    android-sdk:32-ndk-22.1.7171670
    android-sdk:31-ndk-22.1.7171670
    android-sdk:30-ndk-22.1.7171670

</details>

## ruby:[x]

> `ghcr.io/redmadrobot/android/ruby:3.0` \
> `ghcr.io/redmadrobot/android/ruby:2.7`

Ruby image with some additions to work with Fastlane and Danger.

**Base image:** `ruby:[x]-slim` \
**Packages:**

- Bundler
- Firebase CLI

## Experimental images

> :warning: Use these images at your own risk.

### android-emu:[x]

> `ghcr.io/redmadrobot/android/android-emu:30`

**Base image**: `android-sdk:30`

To start emulator, you should run script `/start_emulator.sh`.
Emulator will be named as **EMU_X**, where **X** - is an SDK version (for, API **30** name will be **EMU_30**).

### danger-kotlin:[x]

> `ghcr.io/redmadrobot/android/danger-kotlin:1.0.0` \
> `ghcr.io/redmadrobot/android/danger-kotlin:1.1.0`

[Danger-kotlin][danger-kotlin] docker image.

- **gradle**: 5.6.2
- **jdk**: 8
- **kotlin-compiler**: 1.5.0
- **danger-kotlin**: [x]

## License

[MIT](LICENSE)

<!-- @formatter:off -->
[registry]: https://git.redmadrobot.com/DevOps/docker-android-builder/container_registry
[ghcr]: https://github.com/orgs/RedMadRobot/packages?ecosystem=container&q=android%2F
[danger-kotlin]: https://github.com/danger/kotlin
