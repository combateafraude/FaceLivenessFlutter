package com.caf.face_liveness

import android.content.Context
import android.os.Looper
import com.caf.facelivenessiproov.input.CAFStage
import com.caf.facelivenessiproov.input.FaceLiveness
import com.caf.facelivenessiproov.output.FaceLivenessFailureResult
import com.caf.facelivenessiproov.input.SdkPlatform
import com.caf.facelivenessiproov.input.Time
import com.caf.facelivenessiproov.input.VerifyLivenessListener
import com.caf.facelivenessiproov.input.iproov.Filter
import com.caf.facelivenessiproov.output.FaceLivenessResult
import com.caf.facelivenessiproov.output.failure.SDKError
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FaceLivenessPlugin: FlutterPlugin {

    companion object {
        private const val START_METHOD_CALL = "start"
        private const val METHOD_CHANNEL_NAME = "face_liveness"
        private const val EVENT_CHANNEL_NAME = "face_liveness_listener"
        private const val SUCCESS_EVENT = "success"
        private const val FAILURE_EVENT = "failure"
        private const val CANCELED_EVENT = "canceled"
        private const val CONNECTED_EVENT = "connected"
        private const val CONNECTING_EVENT = "connecting"
    }

    private lateinit var eventChannel: EventChannel
    private lateinit var methodChannel: MethodChannel

    private var eventSink: EventChannel.EventSink? = null
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    private val methodCallHandler =
        MethodChannel.MethodCallHandler { call, result ->
            if (call.method == START_METHOD_CALL) {
                start(call)
            } else {
                result.notImplemented()
            }
        }

    private fun start(call: MethodCall) {
        val context: Context? = flutterPluginBinding?.applicationContext

        val argumentsMap = call.arguments as HashMap<*, *>

        // Mobile token
        val mobileToken = argumentsMap["mobileToken"] as String

        // PersonID
        val personId = argumentsMap["personId"] as String

        val mFaceLivenessBuilder = FaceLiveness.Builder(mobileToken)

        // Stage
        val stage = argumentsMap["stage"] as String?
        stage?.let { mFaceLivenessBuilder.setStage(CAFStage.valueOf(it)) }

        // Filter
        val filter = argumentsMap["filter"] as String?
        filter?.let { mFaceLivenessBuilder.setFilter(Filter.valueOf(it)) }

        // Enable Screenshot
        val enableScreenshot = argumentsMap["enableScreenshot"] as Boolean?
        enableScreenshot?.let { mFaceLivenessBuilder.setEnableScreenshots(it) }

        // Enable SDK default loading screen
        val enableLoadingScreen = argumentsMap["enableLoadingScreen"] as Boolean?
        enableLoadingScreen?.let { mFaceLivenessBuilder.setLoadingScreen(it) }

        // Customize the image URL Expiration Time
        val imageUrlExpirationTime = argumentsMap["imageUrlExpirationTime"] as String?
        imageUrlExpirationTime?.let { mFaceLivenessBuilder.setImageUrlExpirationTime(Time.valueOf(it)) }

        // Set the base URL for the FaceLiveness SDK for reverse proxy
        val reverseProxySettings = argumentsMap["reverseProxySettings"] as HashMap<*, *>?
        reverseProxySettings?.let {
            val faceLivenessBaseUrl = it["faceLivenessBaseUrl"] as String?
            faceLivenessBaseUrl?.let { mFaceLivenessBuilder.setFaceLivenessBaseUrl(faceLivenessBaseUrl) }
            val certificates = it["certificates"] as ArrayList<*>?
            certificates?.let { mFaceLivenessBuilder.setCertificates(certificates.filterIsInstance<String>().toTypedArray()) }
            val authenticationBaseUrl = it["authenticationBaseUrl"] as String?
            authenticationBaseUrl?.let { mFaceLivenessBuilder.setAuthenticationBaseUrl(authenticationBaseUrl) }
        }

        // FaceLiveness build
        mFaceLivenessBuilder.setSdkPlatform(SdkPlatform.FLUTTER)
        mFaceLivenessBuilder.build().startSDK(context, personId, object : VerifyLivenessListener {
            override fun onSuccess(faceLivenessResult: FaceLivenessResult) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getSuccessResponseMap(faceLivenessResult))
                    eventSink?.endOfStream()
                }
            }

            override fun onFailure(result: FaceLivenessFailureResult?) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getFailureResponseMap(result))
                    eventSink?.endOfStream()
                }
            }

            override fun onError(sdkFailure: SDKError) {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getErrorResponseMap(sdkFailure))
                    eventSink?.endOfStream()
                }
            }

            override fun onCancel() {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getClosedResponseMap())
                    eventSink?.endOfStream()
                }
            }

            override fun onLoading() {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getConnectingResponseMap())
                }
            }

            override fun onLoaded() {
                android.os.Handler(Looper.getMainLooper()).post {
                    eventSink?.success(getConnectedResponseMap())
                }
            }
        })
    }

    private fun getSuccessResponseMap(result: FaceLivenessResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = SUCCESS_EVENT
        responseMap["signedResponse"] = result.signedResponse
        return responseMap
    }

    private fun getFailureResponseMap(result: FaceLivenessFailureResult?): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = FAILURE_EVENT
        responseMap["errorType"] = "UnknownFailure"
        responseMap["errorDescription"] = result?.failureMessage ?: "Unknown failure"
        return responseMap
    }

    private fun getErrorResponseMap(result: SDKError): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = FAILURE_EVENT
        responseMap["errorType"] = result.errorType.value
        responseMap["errorDescription"] = result.description
        return responseMap
    }

    private fun getClosedResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = CANCELED_EVENT
        return responseMap
    }

    private fun getConnectingResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = CONNECTING_EVENT
        return responseMap
    }

    private fun getConnectedResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = CONNECTED_EVENT
        return responseMap
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding

        methodChannel = MethodChannel(flutterPluginBinding!!.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(methodCallHandler)

        eventChannel = EventChannel(flutterPluginBinding!!.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        this.flutterPluginBinding = null
    }

}