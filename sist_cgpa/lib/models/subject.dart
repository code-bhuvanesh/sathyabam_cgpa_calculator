// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../utilites/utils.dart';

class Subject {
  Subject({
    this.id,
    required this.semester,
    required this.subCode,
    required this.subName,
    required this.subType,
    required this.credit,
    required this.maxMarks,
    // required this.subLectureHours,
    // required this.subTutorialHours,
    // required this.subPrcaticalHours,
  });
  final int? id;
  final int semester;
  final String subCode;
  final String subName;
  final String subType;
  final int credit;
  final int maxMarks;

  // final int subLectureHours;
  // final int subTutorialHours;
  // final int subPrcaticalHours;

  factory Subject.fromJson(Map<String, dynamic> json) {
    // debugPrint(json);
    return Subject(
      id: json["id"],
      semester: json["semester"],
      subCode: json["subcode"].trim(),
      subName: removeMultipleSpace(json["coursetitle"]),
      subType: json["coursetype"],
      credit: json["credit"],
      maxMarks: json["maxmark"],
      // subLectureHours: json["lecture"],
      // subTutorialHours: json["tutorial"],
      // subPrcaticalHours: json["practical"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'semester': semester,
      'subCode': subCode,
      'subName': subName,
      'subType': subType,
      'credit': credit,
      'maxMarks': maxMarks,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] != null ? map['id'] as int : null,
      semester: map['semester'] as int,
      subCode: map['subCode'] as String,
      subName: map['subName'] as String,
      subType: map['subType'] as String,
      credit: map['credit'] as int,
      maxMarks: map['maxMarks'] as int,
    );
  }

  String toJson() => json.encode(toMap());
}
