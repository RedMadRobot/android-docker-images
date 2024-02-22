# red_mad_robot Android Docker Images

Set of docker images used by red_mad_robot Android team.
All images are published in [GitHub Container Registry][ghcr].

> [!Note]
>
> All images versioned using prefix with date when this image was built `[tag]-YYYYMMDD`.
> It is recommended to use image tags with date prefix to keep build stable and to not break it on images updates.
> All changes are listed in [CHANGELOG](CHANGELOG.md).

---

## android-sdk

> [!Note]
>
> You should always align build-tools and compile SDK in your project to match the versions used in image, otherwise Android Gradle Plugin will download `build-tools` and `platform` packages in each CI build.
>
> ```kotlin
> android {
>     buildToolsVersion = "34.0.0"
>     compileSdk = [x]
> }
> ```

### android-sdk:base

> `ghcr.io/redmadrobot/android/android-sdk:base`

Base Android image. All other android images are built on top of this image.

**Base image**: `eclipse-temurin:17-jdk-jammy` \
**Packages:**

- sdkmanager:
    - cmdline-tools **12.0**
    - build-tools **34.0.0**
    - platform-tools **35.0.0**
- python3
- git
- zip, unzip

<details>
<summary>Deprecated tags</summary>

    base-jdk11

</details>

### android-sdk:[x]

> `ghcr.io/redmadrobot/android/android-sdk:[tag]`

Image with preinstalled SDK.
It should match your `compileSdk` in project build script.

**Tags:**

- `34` (Android 14)
- `33` (Android 13)
- `32` (Android 12L)

<details>
<summary>Deprecated tags</summary>

    - 33-jdk11
    - 32-jdk11
    - 31, 31-jdk11
    - 30, 30-jdk11

</details>

### android-sdk:[x]-ndk

> `ghcr.io/redmadrobot/android/android-sdk:[x]-ndk` \
> `ghcr.io/redmadrobot/android/android-sdk:[x]-ndk-[y]`

Where `[x]` is SDK version and `[y]` is NDK version (optionally).

**Base image**: `android-sdk:[x]` \
**NDK version**: 26.2.11394342

Remember to specify NDK version in `android` block:

```kotlin
android {
    ndkVersion = "26.2.11394342"
}
```

**Tags:**

- `34-ndk`, `33-ndk-26.2.11394342`
- `33-ndk`, `33-ndk-26.2.11394342`
- `32-ndk`, `32-ndk-26.2.11394342`

<details>
<summary>Deprecated tags</summary>

    - 33-jdk11-ndk, 33-jdk11-ndk-25.1.8937393
    - 33-ndk-25.1.8937393
    - 32-jdk11-ndk, 32-jdk11-ndk-25.1.8937393
    - 32-ndk-25.1.8937393, 32-ndk-22.1.7171670
    - 31-jdk11-ndk, 31-jdk11-ndk-25.1.8937393
    - 31-ndk, 31-ndk-25.1.8937393, 31-ndk-22.1.7171670
    - 30-jdk11-ndk, 30-jdk11-ndk-25.1.8937393
    - 30-ndk, 30-ndk-25.1.8937393, 30-ndk-22.1.7171670

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

> [!Warning]
>
> Use these images at your own risk.

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

## Images building

Images use [Dockerfile frontend 1.4+][dockerfile-frontend] so they are meant to be built using [BuildKit] and [buildx].

If you want to build multi-platform images it is recommended to [enable containerd image store][containerd].
Without this option you will not be able to publish images to local store.

## License

[MIT](LICENSE)

<!-- @formatter:off -->
[registry]: https://git.redmadrobot.com/DevOps/docker-android-builder/container_registry
[ghcr]: https://github.com/orgs/RedMadRobot/packages?ecosystem=container&q=android%2F
[danger-kotlin]: https://github.com/danger/kotlin
[allurectl]: https://github.com/allure-framework/allurectl
[buildkit]: https://docs.docker.com/build/buildkit/
[buildx]: https://docs.docker.com/build/install-buildx/
[dockerfile-frontend]: https://hub.docker.com/r/docker/dockerfile
[containerd]: https://docs.docker.com/desktop/containerd/
