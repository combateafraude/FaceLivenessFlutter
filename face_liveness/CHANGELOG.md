# Release notes

This is a continuation of the [new_face_liveness](https://pub.dev/packages/new_face_liveness) package, with necessary adjustments made to align with the updated project structure.

## v5.0.0 (Sep, 25 2024)

### Android

#### Breaking changes

- Updated Gradle to `8.4`.
- Updated Android Gradle Plugin to `8.3.2`.
- Updated compile and taget SDK to API `34`.

#### Highlights

- Updated FaceLiveness SDK from `3.0.0` to [`3.2.0`](https://docs.caf.io/sdks/android/release-notes#faceliveness-3.2.0).
- Created a method to make implementing reverse proxy possible - `setReverseProxySettings(ReverseProxySettings)`.
- Optimized metrics collecting to ensure data security.
- Update iProov Version to `9.0.4`.

### iOS

#### Breaking changes

- iOS minimum deployment target changed from `12.0` to `13.0`.

#### Highlights

- Updated FaceLiveness SDK from `5.0.0` to [`6.1.0`](https://docs.caf.io/sdks/ios/release-notes#faceliveness-6.1.0).
- Server request timeout updated to 20s.
- Iproov SDK updated from `11.0.3` to `12.0.0`.
- FingerPrint SDK updated from `2.2.0` to `2.6.0`.
