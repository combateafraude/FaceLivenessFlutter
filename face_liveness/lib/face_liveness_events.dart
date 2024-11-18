/// `FaceLivenessEvent` is an abstract class representing different types of events.
///
///It is used to create an instance of one of the event subclasses based
///on a map input, which comes from the SDK's result.
///
///Depending on the event type, it creates an instance of either
///`FaceLivenessEventConnecting`, `FaceLivenessEventConnected`,
///`FaceLivenessEventClosed`, `FaceLivenessEventFailure` or `FaceLivenessEventSuccess`. If the event is not recognized,
///it throws an internal exception.
///
///This setup allows for a structured and type-safe way to handle different
///outcomes of the document capture process in the SDK.
abstract class FaceLivenessEvent {
  bool get isFinal;

  static const connectingEvent = "connecting";
  static const connectedEvent = "connected";
  static const validatingEvent = "validating";
  static const validatedEvent = "validated";
  static const canceledEvent = "canceled";
  static const successEvent = "success";
  static const failureEvent = "failure";
  static const resultMappingError =
      "Unexpected error mapping the document_detector execution return";

  factory FaceLivenessEvent.fromMap(Map map) {
    switch (map['event']) {
      case connectingEvent:
        return const FaceLivenessEventConnecting();
      case connectedEvent:
        return const FaceLivenessEventConnected();
      case validatingEvent:
        return const FaceLivenessEventConnecting();
      case validatedEvent:
        return const FaceLivenessEventConnected();
      case canceledEvent:
        return const FaceLivenessEventClosed();
      case successEvent:
        return FaceLivenessEventSuccess(map['signedResponse']);
      case failureEvent:
        return FaceLivenessEventFailure(
            errorType: map["errorType"],
            errorDescription: map["errorDescription"]);
    }
    throw Exception(resultMappingError);
  }
}

/// The SDK is connecting to the server. You should provide an indeterminate progress indicator
/// to let the user know that the connection is taking place.
class FaceLivenessEventConnecting implements FaceLivenessEvent {
  @override
  get isFinal => false;

  const FaceLivenessEventConnecting();
}

/// The SDK has connected, and the iProov user interface will now be displayed. You should hide
/// any progress indication at this point.
class FaceLivenessEventConnected implements FaceLivenessEvent {
  @override
  get isFinal => false;

  const FaceLivenessEventConnected();
}

/// The user canceled iProov, either by pressing the close button at the top right, or sending
/// the app to the background.
class FaceLivenessEventClosed implements FaceLivenessEvent {
  @override
  get isFinal => true;

  const FaceLivenessEventClosed();
}

/// The user was successfully verified/enrolled and the token has been validated.
class FaceLivenessEventSuccess implements FaceLivenessEvent {
  @override
  get isFinal => true;

  /// The JWT containing the information of the execution.
  final String? signedResponse;

  const FaceLivenessEventSuccess(this.signedResponse);
}

/// The user was not successfully verified/enrolled, as their identity could not be verified,
/// or there was another issue with their verification/enrollment.
class FaceLivenessEventFailure implements FaceLivenessEvent {
  @override
  get isFinal => true;

  /// The failure type which can be captured to implement a specific use case for each.
  final String? errorType;

  /// The reason for the failure which can be displayed directly to the user.
  final String? errorDescription;

  const FaceLivenessEventFailure({this.errorType, this.errorDescription});
}
