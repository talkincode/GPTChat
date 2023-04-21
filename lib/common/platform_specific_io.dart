import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class PlatformUtils {
  static bool isDesktop() {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  static bool isMobile() {
    return Platform.isIOS || Platform.isAndroid;
  }

  static bool isWeb() {
    return false;
  }

  static Future<String> getDeviceUniqueId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String clientid = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      clientid = androidInfo.serialNumber;
    } else if (Platform.isIOS || Platform.isMacOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      clientid = iosInfo.identifierForVendor ?? ""; // 这个值可能会在用户卸载并重新安装应用后改变
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      clientid = linuxInfo.machineId ?? "";
    } else if (Platform.isLinux) {
      WindowsDeviceInfo wininfo = await deviceInfo.windowsInfo;
      clientid = wininfo.deviceId;
    }
    if (clientid.isEmpty) {
      clientid = "";
    }
    return clientid;
  }
}
