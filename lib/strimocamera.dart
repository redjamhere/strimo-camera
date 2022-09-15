
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strimocamera/NativeSurfaceView.dart';
import 'package:permission_handler/permission_handler.dart';


enum StreamStatus {
  error,
  rtmp_disconnected,
  rtmp_connected,
  rtmp_connecting,
  rtmp_connection_failed,
  initial
}


class JoyveeCameraPreview extends StatefulWidget {
  const JoyveeCameraPreview({Key? key, required this.controller}) : super(key: key);

  final JoyveeCameraController controller;

  @override
  State<JoyveeCameraPreview> createState() => _JoyveeCameraPreviewState();
}

class _JoyveeCameraPreviewState extends State<JoyveeCameraPreview> {

  Future _requestCameraPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (statuses[Permission.microphone] == PermissionStatus.granted && statuses[Permission.camera] == PermissionStatus.granted) {
      return;
    } else if (statuses[Permission.microphone] == PermissionStatus.denied || statuses[Permission.camera] == PermissionStatus.denied) {
      throw Exception("Camera is not allowed");
    } else if (statuses[Permission.microphone] == PermissionStatus.permanentlyDenied || statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<Widget> buildPreview (BuildContext context) async {
    try {
      await _requestCameraPermission();
      return preview(context);
    } catch (e) {
      throw Exception(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildPreview(context),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Center(
            child: Text("Ошибка загрузки камеры"),
          );
        }
      },
    );
  }
}

class JoyveeCameraController {

  static const MethodChannel _channel = MethodChannel('strimocamera');
  static const EventChannel _eventChannel = EventChannel("strimocamera_event_channel");

  /// Event for when network state changes to Wifi
  static const connected  = 1;

  /// Event for when network state changes to cellular/mobile data
  static const disconnected = 0;

  static const unknow = 2;

  final _isFlashLightEnabled = StreamController<bool>();

  Future<void> callEvent() async {
    await _channel.invokeMethod('callEvent');
  }

  Future<void> switchCamera() async {
    await _channel.invokeMethod('switchCamera');
  }

  Future<bool> startStream(String url) async {
    return await _channel.invokeMethod('startStream', <String, dynamic>{"url": url});
  }

  Future<bool> stopStream() async {
    return  await _channel.invokeMethod('stopStream');
  }

  Future<void> enableFlashLight() async {
    _isFlashLightEnabled.add(await _channel.invokeMethod('enableFlashLight'));
  }

  Future<void> disableFlashLight() async {
    _isFlashLightEnabled.add(await _channel.invokeMethod('disableFlashLight'));
  }

  Stream<bool> get isFlashLightEnabled async* {
    yield false;
    yield* _isFlashLightEnabled.stream;
  }

  Stream<StreamStatus> get eventStream async* {
    await for (String message in _eventChannel.receiveBroadcastStream().map((message) => message)){
      yield strToStreamStatus(message);
    }
  }
}

StreamStatus strToStreamStatus(String s) {
  StreamStatus _status = StreamStatus.initial;
  switch (s) {
    case "error":
      _status = StreamStatus.error;
      break;
    case "rtmp_disconnected":
      _status = StreamStatus.rtmp_disconnected;
      break;
    case "rtmp_connected":
      _status = StreamStatus.rtmp_connected;
      break;
    case "rtmp_connecting":
      _status = StreamStatus.rtmp_connecting;
      break;
    case "rtmp_connection_failed":
      _status = StreamStatus.rtmp_connection_failed;
      break;
  }
  return _status;

}
