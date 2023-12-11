import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<Map<String, String>> _readAll() async {
    var map = <String, String>{};
    try {
      map = await _storage.readAll();
    } catch (e) {
      print(e);
    }
    return map;
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      // _readAll();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> readSecureData(String key) async {
    String? value = "";
    try {
      value = await _storage.read(key: key, aOptions: _getAndroidOptions());
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print(e);
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      print(e);
    }
  }

  // IOSOptions _getIOSOptions() => const IOSOptions(
  //   accessibility: IOSAccessibility.first_unlock,
  // );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
