import 'package:flutter/material.dart';
import 'package:sist_cgpa/models/subject.dart';

class SemSubject {
  final Subject sub;
  final TextEditingController texController = TextEditingController();

  SemSubject({
    required this.sub,
  });
}
