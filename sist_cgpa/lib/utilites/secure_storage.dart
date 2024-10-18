import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/sem_subject.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // ignore: unused_element
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
      print("read delete1");
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
      print("read delete2");
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
    // debugPrint(" semsubjects32356 : ${semSubjects.map(
    //       (key, value) => MapEntry(
    //         key,
    //         value.map(
    //           (e) => e.toMap(),
    //         ),
    //       ),
    //     ).toString()}");
    debugPrint("semsubjects323 write ${semSubjects.keys}");

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
    // debugPrint(
    //     "semsubjects323567 ${jsonDecode((await _storage.read(key: "semsubject"))!)}");
    debugPrint("semsubjects323 writeread ${await readSemSubjects()}");
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

      debugPrint("semsubjects323 read  ${semSubject.keys}");

      return semSubject;
    }
    return {};
  }

  // IOSOptions _getIOSOptions() => const IOSOptions(
  //       accessibility: IOSAccessibility.first_unlock,
  //     );

  // ignore: unused_element
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
