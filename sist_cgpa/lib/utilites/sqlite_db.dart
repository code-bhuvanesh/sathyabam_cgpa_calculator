import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sist_cgpa/models/subject.dart';
import 'package:sqflite/sqflite.dart';

import '../models/course.dart';

class SqliteDB {
  SqliteDB._internal();

  static final SqliteDB _sqlitedb = SqliteDB._internal();

  factory SqliteDB() {
    _sqlitedb.initializeDatabase();
    return _sqlitedb;
  }

  late Database _db;

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "coursesdb.sqlite");

    // Check if the database exists
    var exists = await databaseExists(path);

    //comment it at last
    if (exists) {
      try {
        await File(path).delete();
      } catch (e) {}
    }
    exists = await databaseExists(path);
    /* ************************** */

    if (!exists) {
      // Should happen only the first time you launch your application
      debugPrint("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(url.join("assets", "courses.sqlite"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint("Opening existing database");
    }

// open the database
    _db = await openDatabase(path, readOnly: true);
    debugPrint("database : $_db");
    return _db;
  }

  Future<List<String>> getCourses(String branch) async {
    if (_db.isOpen) {
      Set<String> courses = {};
      var c =
          await _db.rawQuery("SELECT * FROM courses WHERE branch=?", [branch]);
      for (var element in c) {
        courses.add(element["course"] as String);
      }
      return courses.toList();
    }
    return [];
  }

  Future<List<String>> getBranchs() async {
    if (_db.isOpen) {
      Set<String> branches = {};
      var courses = await _db.rawQuery("SELECT * FROM courses");
      for (var course in courses) {
        var curBranch = course["branch"] as String;
        branches.add(curBranch);
      }
      return branches.toList();
    }
    //trying again by initializing it
    // await initializeDatabase();
    return [];
  }

  Future<Course> getCourse(String course) async {
    var courseQuery = (await _db
        .rawQuery("SELECT * FROM courses where course=?", [course]))[0];
    var subjectsQuery = await _db
        .rawQuery("SELECT * FROM course_subjects where course=?", [course]);
    debugPrint(courseQuery.toString());
    debugPrint(subjectsQuery[0].toString());

    List<Subject> subjects = [];
    for (var sub in subjectsQuery) {
      var subcode = sub["subcode"] as String;
      subjects.add(await getSubject(subcode));
    }
    return Course(
      courseName: course,
      maxsem: courseQuery["maxsem"] as int,
      subjects: subjects,
    );
  }

  Future<Subject> getSubject(String subcode) async {
    var sub = (await _db
            .rawQuery("SELECT * from subjects where subcode=?", [subcode]))[0]
        .cast<String, dynamic>();
    return Subject.fromJson(sub);
  }

  Future<List<Subject>> searchSubject(String searchText) async {
    final List<String> keywords =
        searchText.split(" "); // Split query into separate keywords

    String whereClause = 'subcode LIKE ?';
    List<String> whereArgs = ['${keywords[0]}%'];

    List<Map<String, dynamic>> results = await _db.query(
      'subjects',
      where: whereClause,
      whereArgs: whereArgs,
    );
    whereArgs.clear();
    //this is used when online seearch both where subject code and name is given
    whereClause = 'coursetitle LIKE ?';
    // var subjectData = "";
    // keywords.sublist(1).forEach((element) {
    //   subjectData += "$element ";
    // });
    whereArgs.add('%${keywords.sublist(1).join(" ")}%');

    whereClause += ' OR coursetitle LIKE ?';
    whereArgs.add('%$searchText%');

    // for (int i = 0; i < keywords.length; i++) {
    //   whereClause += ' OR coursetitle LIKE ?';
    //   whereArgs.add('%${keywords[i]}%');
    // }

    results += await _db.query(
      'subjects',
      where: whereClause,
      whereArgs: whereArgs,
    );
    // var sub = (await _db.rawQuery(
    //         "SELECT * from subjects where subcode like ?", ["%$searchText%"]))
    //     .map((e) => Subject.fromJson(e.cast<String, dynamic>()))
    //     .toList();
    debugPrint(whereClause);
    debugPrint(whereArgs.toString());
    var sub = results
        .map((e) => Subject.fromJson(e.cast<String, dynamic>()))
        .toList();
    //
    // return Subject.fromJson(sub);
    // debugPrint("searched subjects len ${sub.length} $sub ");
    return sub;
  }
}
