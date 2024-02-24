## [Unreleased]

## [2024.02.24]

### android-sdk

- :exclamation: Add image for Android SDK 34
- :exclamation: SDK 30 and 31 images archived and will not be updated anymore
- Update build-tools `34.0.0-rc3`  → `34.0.0`
- Update commadlinetools `9.0` → `14.0`
- Update NDK `25.1.8937393` → `26.2.11394342`
- Publish images for `linux/arm64` platform
- Add sha256sum check for downloaded commandlinetools
- Declare environment variable `ANDROID_USER_HOME = $HOME/.android`
- Do not set `DEBIAN_FRONTEND` variable
- Remove sdkmanager cache from images
- Do not install i386 libraries for 64-bit machines

### ruby

- :exclamation: Environment variable `FL_GMAIL_USERNAME` removed from the image
- :exclamation: Ruby 2.7 and 3.0 images archived and will not be updated anymore
- :exclamation: Base image changed from `bullseye` (Debian 11) to `bookworm` (Debian 12). 
- Add ruby 3.2 image

## [2023.04.19]

> **Warning**  
> This update contains breaking changes.
> Unfortunately, there was no any mechanism to specify version strictly until now. Starting from this release, every image has tag with the date when it was published.
> To keep builds reproducible and to not get unexpected breaking changes it is recommended to use tags with date suffix `-YYYYMMDD`: `android-sdk:33` -> `android-sdk:33-20230419`

### android-sdk

> Remember to align buildToolsVersion in your project with the version used in the image after update
>
> ```kotlin
> android {
>     buildToolsVersion = "34.0.0-rc3"
> }
> ```

- :exclamation: Update to JDK 17, old images with JDK 11 are deprecated. See "Deprecated tags" spoilers if you want to continue use it
- :exclamation: Update build-tools `30.0.3` → `34.0.0-rc3` to support Android 14
- Update platform-tools to `34.0.1`
- Update commadlinetools `8.0` → `9.0`
- Remove `$ANDROID_HOME/tools/bin` from `PATH` since it was used by `sdk-tools` package which is deprecated
- Remove extra packages from sdkmanager:
  - `extras;android;m2repository`
  - `extras;google;m2repository`
  - `extras;google;google_play_services`

### ruby

- Add ruby 3.2 image
- Remove redundant environment variables

[unreleased]: https://github.com/RedMadRobot/android-docker-images/compare/2024.02.24..main
[2024.02.24]: https://github.com/RedMadRobot/android-docker-images/compare/2023.04.19..2024.02.24
[2023.04.19]: https://github.com/RedMadRobot/android-docker-images/compare/2023.01.16..2023.04.19
