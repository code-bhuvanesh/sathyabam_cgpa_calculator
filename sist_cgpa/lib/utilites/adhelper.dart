import 'dart:io';

import '../constants.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return adBannerid;
    } else if (Platform.isIOS) {
      return adBannerid;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get fullscreenAdUnitId {
    if (Platform.isAndroid) {
      return fsADid;
    } else if (Platform.isIOS) {
      return fsADid;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
