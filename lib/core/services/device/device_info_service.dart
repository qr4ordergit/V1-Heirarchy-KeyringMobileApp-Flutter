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
        _cachedName =
            (await _plugin.webBrowserInfo).browserName.name;
      } else if (Platform.isAndroid) {
        final a = await _plugin.androidInfo;
        _cachedName = '${a.brand} ${a.model}';
      } else if (Platform.isIOS) {
        final i = await _plugin.iosInfo;
        _cachedName = i.utsname.machine;
      } else if (Platform.isWindows) {
        final w = await _plugin.windowsInfo;
        _cachedName = w.computerName;
      } else if (Platform.isMacOS) {
        final m = await _plugin.macOsInfo;
        _cachedName = m.computerName;
      } else if (Platform.isLinux) {
        final l = await _plugin.linuxInfo;
        _cachedName = l.prettyName;
      }
    } catch (_) {}

    return _cachedName ??= 'unknown';
  }

  static Future<String> getPlatform() async {
    if (kIsWeb) {
      final webInfo = await _plugin.webBrowserInfo;
      final userAgent = webInfo.userAgent?.toLowerCase() ?? '';

      if (userAgent.contains('windows')) return 'Windows';
      if (userAgent.contains('android')) return 'Android';
      if (userAgent.contains('iphone') ||
          userAgent.contains('ipad')) {
        return 'iOS';
      }
      if (userAgent.contains('macintosh') ||
          userAgent.contains('mac os')) {
        return 'macOS';
      }
      if (userAgent.contains('linux')) return 'Linux';

      return 'Web';
    }

    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';

    return 'unknown';
  }

  static Future<String> getBrowserName() async {
    if (!kIsWeb) return '';

    try {
      final webInfo = await _plugin.webBrowserInfo;
      final browser = webInfo.browserName.name;

      if (browser == 'chrome') return 'Chrome';
      if (browser == 'edge') return 'Microsoft Edge';
      if (browser == 'firefox') return 'Firefox';
      if (browser == 'safari') return 'Safari';

      return browser;
    } catch (_) {
      return 'unknown';
    }
  }

  static bool isApp() {
    return !kIsWeb;
  }

}
