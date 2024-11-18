import Flutter
import UIKit
import FaceLiveness

public class FaceLivenessPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    var sink: FlutterEventSink?
    var sdkResult : [String: Any?] = [:]
    var faceLiveness: FaceLivenessSDK?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Constants.methodChannelName, binaryMessenger: registrar.messenger())
        let instance = FaceLivenessPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterEventChannel(name: Constants.eventChannelName, binaryMessenger: registrar.messenger())
            .setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == Constants.start {
            do {
                start(call: call);
            }
            result(nil)
        } else {
            result(FlutterMethodNotImplemented);
        }
    }

    private func start(call: FlutterMethodCall) {

        guard let arguments = call.arguments as? [String: Any?] else {
            fatalError(Constants.argumentsErrorMessage)
        }

        guard let mobileToken = arguments["mobileToken"] as? String else {
            fatalError(Constants.mobileTokenErrorMessage)
        }

        guard let personId = arguments["personId"] as? String else {
            fatalError(Constants.personIdErrorMessage)
        }

        let mFaceLivenessBuilder = FaceLivenessSDK.Build()

        // Stage
        if let stage = arguments["stage"] as? String ?? nil {
            _ = mFaceLivenessBuilder.setStage(stage: getCafStage(stage: stage))
        }

        // Camera Filter
        if let filter = arguments["filter"] as? String ?? nil {
            _ = mFaceLivenessBuilder.setFilter(filter: getFilter(filter: filter))
        }

        // Enable SDK default loading screen
        if let enableLoadingScreen = arguments["enableLoadingScreen"] as? Bool ?? nil {
            _ = mFaceLivenessBuilder.setLoadingScreen(withLoading: enableLoadingScreen)
        }

        if let expirationTime = arguments["imageUrlExpirationTime"] as? String ?? nil {
            _ = mFaceLivenessBuilder.setImageUrlExpirationTime(time: getExpirationTime(time: expirationTime))
        }

        // FaceLiveness Build
        self.faceLiveness = mFaceLivenessBuilder.build()
        faceLiveness?.delegate = self
        faceLiveness?.sdkType = .Flutter

        // Set the app last window as the current key window to the view controller
        guard let viewController = UIApplication.shared.currentKeyWindow?.rootViewController else {
            fatalError(Constants.viewControllerErrorMessage)
        }

        faceLiveness?.startSDK(viewController: viewController, mobileToken: mobileToken, personId: personId)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil

        return nil
    }
}

extension FaceLivenessPlugin: FaceLivenessDelegate {
    
    public func didFinishLiveness(with livenessResult: LivenessResult) {
        sdkResult["event"] = Constants.eventSuccess
        sdkResult["signedResponse"] = livenessResult.signedResponse

        self.sink?(sdkResult)
        self.sink?(FlutterEndOfEventStream)
        faceLiveness = nil
    }

    public func didFinishWithError(with sdkFailure: SDKFailure) {
        sdkResult["event"] = Constants.eventError

        sdkResult["errorType"] = sdkFailure.errorType?.rawValue
        sdkResult["errorDescription"] = sdkFailure.description

        self.sink?(sdkResult)
        self.sink?(FlutterEndOfEventStream)
        faceLiveness = nil
    }

    public func didFinishWithCancelled() {
        sdkResult["event"] = Constants.eventCanceled

        self.sink?(sdkResult)
        self.sink?(FlutterEndOfEventStream)
        faceLiveness = nil
    }

    public func onConnectionChanged(_ state: LivenessState) {
    }
    
    public func openLoadingScreenStartSDK() {
        sdkResult["event"] = Constants.eventConnecting
        
        self.sink?(sdkResult)
    }
    
    public func closeLoadingScreenStartSDK() {
        sdkResult["event"] = Constants.eventConnected
        
        self.sink?(sdkResult)
    }
    
    public func openLoadingScreenValidation() {
        sdkResult["event"] = Constants.eventValidating
        
        self.sink?(sdkResult)
    }
    
    public func closeLoadingScreenValidation() {
        sdkResult["event"] = Constants.eventValidated
        
        self.sink?(sdkResult)
    }
}
