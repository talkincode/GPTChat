class PlatformUtils {
  static bool isDesktop() {
    return false;
  }

  static bool isMobile() {
    return false;
  }

  static bool isWeb() {
    return true;
  }

  static Future<String> getDeviceUniqueId() async {
    return "";
  }
}
