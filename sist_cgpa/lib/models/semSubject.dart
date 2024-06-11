import 'package:flutter/material.dart';
import 'package:sist_cgpa/models/subject.dart';

class SemSubject {
  final Subject sub;
  late TextEditingController textController;

  SemSubject({
    required this.sub,
    int? mark,
  }) {
    textController = TextEditingController(text: mark?.toString());
  }
}
