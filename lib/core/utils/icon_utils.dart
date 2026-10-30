import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class IconUtils {

 static IconData getDeviceIcon(String? platform) {
    switch (platform?.toLowerCase()) {
      case 'android':
        return Iconsax.mobile_copy;

      case 'ios':
        return Iconsax.mobile_copy;

      case 'windows':
        return Iconsax.monitor_copy;

      case 'macos':
        return Iconsax.monitor_copy;

      case 'linux':
        return Iconsax.monitor_copy;

      case 'web':
        return Iconsax.global;

      default:
        return Iconsax.devices_copy;
    }
  }


 // static IconData getDeviceIcon(String? platform) {
 //    switch (platform?.toLowerCase()) {
 //      case 'android':
 //        return CupertinoIcons.device_phone_portrait;
 //
 //      case 'ios':
 //        return CupertinoIcons.device_phone_portrait;
 //
 //      case 'windows':
 //        return CupertinoIcons.desktopcomputer;
 //
 //      case 'macos':
 //        return CupertinoIcons.device_laptop;
 //
 //      case 'linux':
 //        return CupertinoIcons.desktopcomputer;
 //
 //      case 'web':
 //        return CupertinoIcons.globe;
 //
 //      default:
 //        return CupertinoIcons.device_laptop;
 //    }
 //  }
 //  static IconData getDeviceIcon(String? platform) {
 //    switch (platform?.toLowerCase()) {
 //      case 'android':
 //        return Icons.phone_android;
 //
 //      case 'ios':
 //        return Icons.phone_iphone;
 //
 //      case 'windows':
 //        return Icons.desktop_windows;
 //
 //      case 'macos':
 //        return Icons.laptop_mac;
 //
 //      case 'linux':
 //        return Icons.computer;
 //
 //      case 'web':
 //        return Icons.language;
 //
 //      default:
 //        return Icons.devices;
 //    }
 //  }
}