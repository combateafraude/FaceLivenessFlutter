import 'dart:async';

import 'package:caf_face_liveness/reverse_proxy_settings.dart';
import 'package:flutter/services.dart';
import 'face_liveness_enums.dart';
import 'face_liveness_events.dart';

const _livenessMethodChannel = MethodChannel('face_liveness');
const _livenessListenerEventChannel = EventChannel('face_liveness_listener');

class FaceLiveness {
  /// Usage token associated with your CAF account
  String mobileToken;

  /// Set users identifier for fraud profile identification purposes and to
  /// assist in the identification of Analytics logs in cases of bugs and errors.
  String personId;

  CafStage? stage;
  CameraFilter? filter;
  bool? enableScreenshot;
  bool? enableLoadingScreen;
  UrlExpirationTime? imageUrlExpirationTime;
  ReverseProxySettings? reverseProxySettings;

  FaceLiveness({required this.mobileToken, required this.personId});

  /// Set the environment in wich the SDK will run.
  void setStage(CafStage stage) {
    this.stage = stage;
  }

  /// Set the camera filter displayed to take the selfie picture
  void setCameraFilter(CameraFilter filter) {
    this.filter = filter;
  }

  /// This feature works only for Android
  void setEnableScreenshots(bool enable) {
    enableScreenshot = enable;
  }

  /// Determines whether the loading screen will be the SDK default implementation or if you will implement your own.
  /// If set to 'true' the loading screen will be a standard SDK screen.
  /// In the case of 'false' you should implement the loading screen on your side.
  /// By default the loading screen is set to 'false'.
  void setEnableLoadingScreen(bool enable) {
    enableLoadingScreen = enable;
  }

  // Customize the image URL expiration time. You can set it to expire in 3h or 30 days.
  // Set the parameter with 'Time.threeHours' or 'Time.thirtyDays' to configure this.
  void setImageUrlExpirationTime(UrlExpirationTime time) {
    imageUrlExpirationTime = time;
  }

  /// Configure the reverse proxy settings for running the FaceLiveness and/or Authentication services.
  /// These two services can operate independently of each other.
  void setReverseProxySettings(ReverseProxySettings reverseProxySettings) {
    this.reverseProxySettings = reverseProxySettings;
  }

  Stream<FaceLivenessEvent> start() {
    Map<String, dynamic> params = {};

    params['mobileToken'] = mobileToken;
    params['personId'] = personId;
    params['stage'] = stage?.stringValue;
    params['filter'] = filter?.stringValue;
    params['enableScreenshot'] = enableScreenshot;
    params['enableLoadingScreen'] = enableLoadingScreen;
    params['imageUrlExpirationTime'] = imageUrlExpirationTime?.stringValue;
    params['reverseProxySettings'] = reverseProxySettings?.asMap();

    _livenessMethodChannel.invokeMethod('start', params);

    return _livenessListenerEventChannel
        .receiveBroadcastStream()
        .map((result) => FaceLivenessEvent.fromMap(result));
  }
}
