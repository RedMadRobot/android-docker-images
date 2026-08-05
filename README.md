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
> All `android-sdk` tags ship the same build-tools **36.0.0** — newer build-tools can build for lower compile SDK levels.
>
> ```kotlin
> android {
>     buildToolsVersion = "36.0.0"
>     compileSdk = [x]
> }
> ```
>
> Keep in mind that Android Gradle Plugin ignores `buildToolsVersion` below its own minimum and downloads its default version instead. AGP 9.2.x defaults to build-tools **36.0.0**.

### android-sdk:base

> `ghcr.io/redmadrobot/android/android-sdk:base`

Base Android image. All other android images are built on top of this image.

**Base image**: `eclipse-temurin:17-jdk-jammy` \
**Platforms:** `linux/amd64`, `linux/arm64` \
**Packages:**

- sdkmanager:
    - cmdline-tools **12.0**
    - build-tools **36.0.0**
    - platform-tools — not pinned, an image gets the release current at its build time
- python3 **3.10**
- git
- zip, unzip

<details>
<summary>Deprecated tags</summary>

    base-36.0.0
    base-jdk11

</details>

### android-sdk:[x]

> `ghcr.io/redmadrobot/android/android-sdk:[tag]`

Image with preinstalled SDK.
It should match your `compileSdk` in project build script.

**Tags:**

- `36` (Android 16)
- `35` (Android 15)
- `34` (Android 14)

<details>
<summary>Deprecated tags</summary>

    - 33, 33-jdk11
    - 32, 32-jdk11
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

**Base image:** `ruby:[x]-slim-bookworm` \
**Platforms:** `linux/amd64` \
**Packages:**

- Bundler **2.5.6**
- Firebase CLI **13.3.1**

**Tags:**

- `3.3`, `latest`
- `3.2`
- `3.1`

<details>
<summary>Deprecated tags</summary>

    - 3.0
    - 2.7

</details>

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

### android-emu-atd

> `ghcr.io/redmadrobot/android/android-emu-atd:36`

**Base image**: `android-sdk:36` \
**Platforms:** `linux/amd64`

> [!Note]
>
> The image tag is the version of the base `android-sdk` image, **not** an ATD API level.
> `android-emu-atd:36` is built on `android-sdk:36` and carries ATD system images for API **30** and **34**.

Image for instrumented (UI) tests run via **Gradle Managed Devices (GMD)**.
Unlike `android-emu` (manual model: baked AVD + snapshot + `start-emulator`, `google_apis`,
one API per image), this image does **not** bake an AVD or snapshot — the GMD Gradle task
manages the emulator lifecycle. It only adds what stock `android-sdk` lacks:

- emulator runtime shared libraries (`libX11` etc. — the launcher fails to start without them);
- the `emulator` package;
- AOSP **ATD** system images (headless-optimized, no Google APIs):
  `system-images;android-30;aosp_atd;x86` and `system-images;android-34;aosp_atd;x86_64`.

A single image carries both API levels so it serves the whole GMD matrix from one `image:`.
The API levels must match `apiLevel` in the consuming project's Gradle Managed Devices config.

> [!Note]
>
> Hardware acceleration (`/dev/kvm`) is **not** part of the image — it is a device passthrough
> configured on the runner. The emulator needs it at runtime.

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
