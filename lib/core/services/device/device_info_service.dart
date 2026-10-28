import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceInfoService {
  DeviceInfoService._();

  static final DeviceInfoPlugin _plugin = DeviceInfoPlugin();
  static String? _cachedName;

  static Future<String> getDeviceName() async {
    if (_cachedName != null) return _cachedName!;

    try {
      if (kIsWeb) {
        _cachedName = (await _plugin.webBrowserInfo).browserName.name;
      } else if (Platform.isAndroid) {
        final a = await _plugin.androidInfo;
        _cachedName = '${a.brand} ${a.model}';
      } else if (Platform.isIOS) {
        _cachedName = (await _plugin.iosInfo).utsname.machine;
      }
    } catch (_) {}

    return _cachedName ??= 'unknown';
  }
}