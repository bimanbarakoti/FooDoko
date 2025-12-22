// lib/app/services/device_service.dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final Battery _battery = Battery();

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    
    Map<String, dynamic> deviceData = {
      'platform': kIsWeb ? 'web' : Platform.operatingSystem,
      'appName': packageInfo.appName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };

    if (kIsWeb) {
      final webInfo = await _deviceInfo.webBrowserInfo;
      deviceData.addAll({
        'browser': webInfo.browserName.name,
        'userAgent': webInfo.userAgent,
        'platform': webInfo.platform,
      });
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      deviceData.addAll({
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'version': androidInfo.version.release,
        'sdkInt': androidInfo.version.sdkInt,
        'brand': androidInfo.brand,
        'device': androidInfo.device,
      });
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      deviceData.addAll({
        'model': iosInfo.model,
        'name': iosInfo.name,
        'systemVersion': iosInfo.systemVersion,
        'identifierForVendor': iosInfo.identifierForVendor,
      });
    }

    return deviceData;
  }

  static Future<int> getBatteryLevel() async {
    if (kIsWeb) return 100;
    return await _battery.batteryLevel;
  }

  static Future<BatteryState> getBatteryState() async {
    if (kIsWeb) return BatteryState.unknown;
    return await _battery.batteryState;
  }

  static Future<String> getConnectivity() async {
    // Mock connectivity for now
    return 'wifi';
  }

  static Stream<String> getConnectivityStream() {
    // Mock connectivity stream
    return Stream.periodic(const Duration(seconds: 5), (i) => 'wifi');
  }

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isWeb => kIsWeb;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
}