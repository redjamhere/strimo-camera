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
  final JoyveeCamera _joyveeCamera = JoyveeCamera();
  Size? size;

  bool? isStreaming;
  bool? isEnabledFlashLight;

  @override
  void initState() {
    super.initState();
    isStreaming = false;
    isEnabledFlashLight = false;
  }

  void _enableFlashLight() async {
    isEnabledFlashLight =  await _joyveeCamera.enableFlashLight();
    setState(() {

    });
  }

  void _disableFlashLight() async {
    await _joyveeCamera.disableFlashLight();
    setState(() {
      isEnabledFlashLight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children:[
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _joyveeCamera.bulidPreview(context),
                ),
              )
            ),
            (!isEnabledFlashLight!)
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
              bottom: 0,
              left: 0,
              child: TextButton(
                child: Text('SwitchCamera'),
                onPressed: () => _joyveeCamera.switchCamera(),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                  child: Text('start', style: TextStyle(color: Colors.red),),
                  onPressed: () async => await _joyveeCamera.startStream("rtmp://192.168.1.101:1935/live/android"),
                )),
            Positioned(
                bottom: 0,
                right: 100,
                child: TextButton(
                  child: Text('Stop', style: TextStyle(color: Colors.blue),),
                  onPressed: () async => await _joyveeCamera.stopStream(),
                )),
          ]
      ),
    );
  }
}

