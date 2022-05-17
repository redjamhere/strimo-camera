import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strimocamera/strimocamera.dart';

void main() {
  const MethodChannel channel = MethodChannel('strimocamera');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Strimocamera.platformVersion, '42');
  });
}
