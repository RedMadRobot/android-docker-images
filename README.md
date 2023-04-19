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

> `ghcr.io/redmadrobot/android/ruby:[tag]`

Ruby image with some additions to work with Fastlane and Danger.

**Base image:** `ruby:[x]-slim-bullseye` \
**Packages:**

- Bundler
- Firebase CLI

**Tags:**

- `3.2`, `latest`
- `3.1`
- `3.0`
- `2.7`

## Experimental images

> :warning: Use these images at your own risk.

### android-emu:[x]

> `ghcr.io/redmadrobot/android/android-emu:30`

**Base image**: `android-sdk:30`

**Scripts**:

- [`start-emulator`](android-emu/start_emulator.sh) - a script to start the emulator.  
  Emulator will be named as **EMU_X**, where **X** - is an SDK version (for, API **30** name will be **EMU_30**).
- [`prepare-snapshot`](android-emu/prepare_snapshot.sh) - a script to save a snapshot.  
  This script will create a snapshot with the name from the environment variable `DEFAULT_SNAPSHOT` ([`DEFAULT_SNAPSHOT="ci"`](android-emu/Dockerfile) by default).  
  To run the emulator with `DEFAULT_SNAPSHOT` set `SNAPSHOT_ENABLED="true"` (by default snapshot is disabled):  
  > `SNAPSHOT_ENABLED="true" start-emulator`  

**Binaries**:

- [Allurectl][allurectl] - command line wrapper of Allure TestOps' API allowing you to upload the test results in real time from a build job, and managing entities on Allure TestOps side (test cases, launches, projects).

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
[allurectl]: https://github.com/allure-framework/allurectl