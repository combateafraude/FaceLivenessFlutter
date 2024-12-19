import 'package:caf_face_liveness/face_liveness.dart';
import 'package:caf_face_liveness/face_liveness_enums.dart';
import 'package:caf_face_liveness/face_liveness_events.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _mobileToken = "sample_mobile_token";
  final String _personId = "sample_person_id";

  late final FaceLiveness _faceLiveness;

  @override
  void initState() {
    super.initState();
    _initializeFaceLiveness();
  }

  void _initializeFaceLiveness() {
    _faceLiveness = FaceLiveness(mobileToken: _mobileToken, personId: _personId);
    _faceLiveness.setStage(CafStage.prod);
    _faceLiveness.setCameraFilter(CameraFilter.natural);
    _faceLiveness.setEnableScreenshots(true);
    _faceLiveness.setEnableLoadingScreen(false);
  }

  void startFaceLiveness() {
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
        print('SDK Closed: User canceled the session.');
      } else if (event is FaceLivenessEventSuccess) {
        print('SDK Success! \nSignedResponse: ${event.signedResponse}');
      } else if (event is FaceLivenessEventFailure) {
        print('SDK Failure! \nError type: ${event.errorType} \nError Message: ${event.errorDescription}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FaceLiveness Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              startFaceLiveness();
            },
            child: const Text('Start FaceLiveness'),
          ),
        ),
      ),
    );
  }
}
