import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/sem_subject.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  Future<Map<String, String>> _readAll() async {
    var map = <String, String>{};
    try {
      map = await _storage.readAll(
          // iOptions: _getIOSOptions(),
          // aOptions: _getAndroidOptions(),
          );
    } catch (e) {
      debugPrint(e.toString());
    }
    return map;
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
          // iOptions: _getIOSOptions(),
          // aOptions: _getAndroidOptions(),
          );
      // _readAll();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> readSecureData(String key) async {
    String value = "";
    try {
      value = (await _storage.read(key: key)) ?? "";
    } catch (e) {
      debugPrint(e.toString());
    }
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        // iOptions: _getIOSOptions(),
        // aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveSemSubjects(Map<int, List<SemSubject>> semSubjects) async {
    // debugPrint(" semsubjects : ${semSubjects.map(
    //       (key, value) => MapEntry(
    //         key,
    //         value.map(
    //           (e) => e.toMap(),
    //         ),
    //       ),
    //     ).toString()}");
    var semSubjectJson = jsonEncode(semSubjects.map(
      (key, value) => MapEntry(
        key.toString(),
        value
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      ),
    ));

    await _storage.write(key: "semsubject", value: semSubjectJson);
  }

  Future<Map<int, List<SemSubject>>> readSemSubjects() async {
    var semSubjectJson = await _storage.read(key: "semsubject");
    if (semSubjectJson != null) {
      debugPrint(" semsubjects : ${jsonDecode(semSubjectJson)}");
      var semSubject = (jsonDecode(semSubjectJson) as Map<String, dynamic>)
          .map((key, value) {
        debugPrint(" semsubjects $key : $value");
        return MapEntry(
          int.parse(key),
          (value as List)
              .map(
                (e) => SemSubject.fromMap(
                  e,
                ),
              )
              .toList(),
        );
      });

      return semSubject;
    }
    return {};
  }

  // IOSOptions _getIOSOptions() => const IOSOptions(
  //       accessibility: IOSAccessibility.first_unlock,
  //     );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
