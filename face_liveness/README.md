# [FaceLiveness](https://docs.caf.io/sdks/flutter/getting-started/faceliveness)

The FaceLiveness SDK brings cutting-edge live facial verification and fingerprint authentication technology into your Flutter applications, offering a seamless and secure way to authenticate users.

---

## Terms & Policies

Ensure compliance with our [Privacy Policy](https://en.caf.io/politicas/politicas-de-privacidade) and [Terms of Use](https://en.caf.io/politicas/termos-e-condicoes-de-uso).

---

### Runtime Permissions

| Platform | Permission                  | Required | 
| -------- | --------------------------- | :------: |
| Android  | `CAMERA`                    | ✅       |
| iOS      | `Privacy - Camera Usage`    | ✅       |

---

## Installation

**Add Dependency**: Update `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_caf_face_liveness: ^1.0.0
   ```

---

### Event Handling

The `CafLivenessListener` in Flutter handles key events during the SDK's liveness detection process. Below are the correct Flutter events you can listen to:

| **Event**                           | **Description**                                                                                      |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **FaceLivenessEventClosed**         | Triggered when the user cancels the liveness detection process.                                      |
| **FaceLivenessEventFailure**        | Called when an SDK failure occurs, providing error details like `errorType` and `errorDescription`. |
| **FaceLivenessEventConnected**      | Triggered when the SDK is fully loaded and ready to start.                                           |
| **FaceLivenessEventConnecting**     | Indicates the SDK is initializing or in the process of loading.                                      |
| **FaceLivenessEventSuccess**        | Triggered upon successful liveness detection, with the result available in `signedResponse`.         |

**Example:**

```dart
void _setupFaceLivenessListener(Stream<FaceLivenessEvent> stream) {
  stream.listen((event) {
    if (event is FaceLivenessEventConnecting) {
      print('Connecting to FaceLiveness...');
    } else if (event is FaceLivenessEventConnected) {
      print('Connected to FaceLiveness.');
    } else if (event is FaceLivenessEventClosed) {
      print('SDK closed by the user.');
    } else if (event is FaceLivenessEventSuccess) {
      print('Success! SignedResponse: ${event.signedResponse}');
    } else if (event is FaceLivenessEventFailure) {
      print(
        'Failure! Error type: ${event.errorType}, '
        'Error description: ${event.errorDescription}',
      );
    }
  });
}
```

### Builder Methods

| Parameter                           | Description                                                                 | Required |
| ----------------------------------- | --------------------------------------------------------------------------- | :------: |
| **setScreenCaptureEnabled(Boolean)** | Enables or disables screen capture. Default: `false`.                       |    ❌    |
| **setStage(CafStage)**              | Defines the environment stage (e.g., `PROD`, `BETA`). Default: `PROD`.      |    ❌    |
| **setLoadingScreen(Boolean)**       | Enables or disables the loading screen. Default: `false`.                   |    ❌    |
| **setListener(CafLivenessListener)** | Sets a listener for liveness verification events.                           |    ✅    |

### Example

```dart
  void _initializeFaceLiveness() {
    _faceLiveness = FaceLiveness(mobileToken: _mobileToken, personId: _personId);
    _faceLiveness.setStage(CafStage.prod);
    _faceLiveness.setCameraFilter(CameraFilter.natural);
    _faceLiveness.setEnableScreenshots(true);
    _faceLiveness.setEnableLoadingScreen(false);
  }
```

## Calling `startFaceLiveness`

To start the liveness verification process, initialize `FaceLiveness` with `mobileToken` and `personId`, then call `start()` and handle events using a listener:

```dart
void startSDK() {
  final stream = _faceLiveness.start();
  _setupFaceLivenessListener(stream);
}

void _setupFaceLivenessListener(Stream<FaceLivenessEvent> stream) {
  stream.listen((event) {
    if (event is FaceLivenessEventConnecting) {
      print('Connecting to FaceLiveness...');
    } else if (event is FaceLivenessEventConnected) {
      print('Connected to FaceLiveness.');
    } else if (event is FaceLivenessEventClosed) {
      print('SDK closed by the user.');
    } else if (event is FaceLivenessEventSuccess) {
      print('Success! SignedResponse: ${event.signedResponse}');
    } else if (event is FaceLivenessEventFailure) {
      print(
        'Failure! Error type: ${event.errorType}, '
        'Error description: ${event.errorDescription}',
      );
    }
  });
}
```
