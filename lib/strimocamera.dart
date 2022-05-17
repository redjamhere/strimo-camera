
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strimocamera/NativeSurfaceView.dart';
import 'package:torch_light/torch_light.dart';


class JoyveeCamera {

  static const MethodChannel _channel = MethodChannel('strimocamera');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
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


}
