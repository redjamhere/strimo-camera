import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:strimocamera/strimocamera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CameraView()
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  AppLifecycleState? _notification;
  final JoyveeCameraController _cameraController = JoyveeCameraController();
  bool keepAlive = false;
  Size? size;

  bool? isStreaming;

  bool _isFlashLightEnabled = false;

  @override
  void initState() {
    super.initState();
    _cameraController.isFlashLightEnabled.listen((event) {
      setState(() {
        _isFlashLightEnabled = event;
      });
    });
    isStreaming = false;
  }
  void _enableFlashLight() async {
    await _cameraController.enableFlashLight();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _disableFlashLight() async {
    await _cameraController.disableFlashLight();
  }

  void _startStream() async {
    await _cameraController.startStream("");
  }

  // _buildPreview() async {
  //   dynamic p = await _cameraController.buildPreview(context);
  //   if(p == false) {
  //     preview = Center(child: Text('Camera is not allowed'));
  //   } else {
  //     preview = p;
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children:[
            Positioned.fill(
              child: Center(
                child: JoyveeCameraPreview(controller: _cameraController),
              )
            ),
            (!_isFlashLightEnabled)
            ? Positioned(
              top: 30,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.flash_on),
                onPressed: _enableFlashLight,
              ),
            )
            : Positioned(
              top: 30,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.flashlight_off),
                onPressed: _disableFlashLight
              ),
            ),
            Positioned(
              top: 30,
              left: 50,
              child: IconButton(
                icon: Icon(Icons.call),
                onPressed: () async => await _cameraController.callEvent(),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: StreamBuilder<StreamStatus>(
                  initialData: StreamStatus.initial,
                  stream: _cameraController.eventStream,
                  builder: (context, snapshot) {
                    final StreamStatus streamStatus = snapshot.data ?? StreamStatus.initial;
                    String _message = "> _ < ";
                    Color? _color = Colors.white;
                    if (streamStatus == StreamStatus.rtmp_connected) {
                      _message = 'Connected';
                      _color = Colors.green;
                    }

                    if (streamStatus == StreamStatus.rtmp_connecting) {
                      _message = 'Connecting....';
                      _color = Colors.grey;
                    }

                    if (streamStatus == StreamStatus.rtmp_disconnected) {
                      _message = 'Disconnected';
                      _color = Colors.red;
                    }
                    if (streamStatus == StreamStatus.rtmp_connection_failed) {
                      _message = "Connection failed";
                      _color = Colors.orange;
                    }
                    return Text(_message, style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 40),);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: TextButton(
                child: Text('SwitchCamera'),
                onPressed: () => _cameraController.switchCamera(),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: StreamBuilder<StreamStatus>(
                  initialData: StreamStatus.initial,
                  stream: _cameraController.eventStream,
                  builder: (context, snapshot) {
                    final StreamStatus streamStatus = snapshot.data ?? StreamStatus.initial;
                    if (streamStatus == StreamStatus.rtmp_connected) {
                      return TextButton(
                        child: Text('Stop', style: TextStyle(color: Colors.blue),),
                        onPressed: () async => await _cameraController.stopStream(),
                      );
                    }
                    if (streamStatus == StreamStatus.rtmp_connecting) {
                      return TextButton(
                        child: Text('Connecting', style: TextStyle(color: Colors.grey),),
                        onPressed: null,
                      );
                    }
                    if (streamStatus == StreamStatus.rtmp_disconnected) {
                      return TextButton(
                        child: Text('Retry', style: TextStyle(color: Colors.orange),),
                        onPressed: ()  => _startStream(),
                      );
                    }
                    if (streamStatus == StreamStatus.rtmp_connection_failed) {
                      return TextButton(
                        child: Text('Retry', style: TextStyle(color: Colors.blue),),
                        onPressed: ()  => _startStream(),
                      );
                    }
                    return TextButton(
                      child: Text('start', style: TextStyle(color: Colors.red),),
                      onPressed: ()  => _startStream(),
                    );
                  },
                )),
          ]
      ),
    );
  }
}

