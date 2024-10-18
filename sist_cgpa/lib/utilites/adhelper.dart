import 'dart:io';

import 'package:flutter/foundation.dart';

import '../constants.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode? adBanneridDev : adBannerid;
    } else if (Platform.isIOS) {
      return adBannerid;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get fullscreenAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode? fsADidDev : fsADid;
    } else if (Platform.isIOS) {
      return kDebugMode? fsADidDev : fsADid;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
