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

class _CameraViewState extends State<CameraView> with AutomaticKeepAliveClientMixin {
  final JoyveeCamera _joyveeCamera = JoyveeCamera();
  bool keepAlive = false;
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
    setState(() {});
  }

  void _disableFlashLight() async {
    await _joyveeCamera.disableFlashLight();
    setState(() {
      isEnabledFlashLight = false;
    });
  }

  @override
  bool get wantKeepAlive => keepAlive;

  void _startStream() async {
    keepAlive = true;
    updateKeepAlive();
    await _joyveeCamera.startStream("rtmp://192.168.1.103:1935/live/android");
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children:[
            Positioned.fill(
              child: Center(
                child: _joyveeCamera.bulidPreview(context),
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
              top: 30,
              left: 50,
              child: IconButton(
                icon: Icon(Icons.call),
                onPressed: () async => await _joyveeCamera.callEvent(),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: StreamBuilder<StreamStatus>(
                  initialData: StreamStatus.rtmp_disconnected,
                  stream: _joyveeCamera.eventStream,
                  builder: (context, snapshot) {
                    final StreamStatus streamStatus = snapshot.data ?? StreamStatus.unknow;
                    String _message = "";
                    Color? _color;
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
                onPressed: () => _joyveeCamera.switchCamera(),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                  child: Text('start', style: TextStyle(color: Colors.red),),
                  onPressed: ()  => _startStream(),
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

