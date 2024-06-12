import 'package:flutter/material.dart';

import 'package:sist_cgpa/models/subject.dart';

class SemSubject {
  final Subject sub;
  int? mark;
  late TextEditingController textController;

  SemSubject({
    required this.sub,
    this.mark,
  }) {
    textController = TextEditingController(
      text: mark?.toString(),
    );
  }

  factory SemSubject.fromJson(Map<String, dynamic> json) {
    // debugPrint(json);
    
    return SemSubject(
      sub: Subject.fromJson(json["subject"]),
      mark: int.tryParse(json["mark"]),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sub': sub.toMap(),
      'mark': mark,
    };
  }

  factory SemSubject.fromMap(Map<String, dynamic> map) {
    return SemSubject(
      sub: Subject.fromMap(map['sub'] as Map<String,dynamic>),
      mark: map['mark'] != null ? map['mark'] as int : null,
    );
  }

 
}
