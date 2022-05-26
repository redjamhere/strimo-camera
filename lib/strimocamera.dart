
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strimocamera/NativeSurfaceView.dart';
import 'package:torch_light/torch_light.dart';


enum StreamStatus {
  error,
  rtmp_disconnected,
  rtmp_connected,
  rtmp_connecting,
  rtmp_connection_failed,
  unknow
}

class JoyveeCamera {

  static const MethodChannel _channel = MethodChannel('strimocamera');
  static const EventChannel _eventChannel = EventChannel("strimocamera_event_channel");

  /// Event for when network state changes to Wifi
  static const connected  = 1;

  /// Event for when network state changes to cellular/mobile data
  static const disconnected = 0;

  static const unknow = 2;


  Future<void> callEvent() async {
    await _channel.invokeMethod('callEvent');
  }

  Widget bulidPreview (BuildContext context) {
    return preview(context);
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

  Future<bool> enableFlashLight() async {
    return await _channel.invokeMethod('enableFlashLight');
  }

  Future<bool> disableFlashLight() async {
    return await _channel.invokeMethod('disableFlashLight');
  }

  Stream<StreamStatus> get eventStream async* {
    await for (String message in _eventChannel.receiveBroadcastStream().map((message) => message)){
      print(message);
      yield strToStreamStatus(message);
    }
  }

}

StreamStatus strToStreamStatus(String s) {
  StreamStatus _status = StreamStatus.unknow;
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
