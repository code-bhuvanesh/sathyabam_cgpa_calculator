import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1084174997155279/3496783807";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1084174997155279/3496783807";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get fullscreenAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1084174997155279/2362847297";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1084174997155279/2362847297";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
