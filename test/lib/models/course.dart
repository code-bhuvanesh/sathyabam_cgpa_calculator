import '/models/subject.dart';

class Course {
  Course({
    required this.courseName,
    required this.subjects,
  }) {
    removeNonCreditSubject();
  }
  final String courseName;
  final List<Subject> subjects;

  factory Course.fromJson(String courseName, Map<String, dynamic> json) {
    return Course(
      courseName: courseName,
      subjects: json.entries
          .map(
            (e) => Subject.fromJson(
              e.key,
              e.value,
            ),
          )
          .toList(),
    );
  }

  List<Subject> getBySem(int sem) {
    return subjects.where((subject) => subject.semester == sem).toList();
  }

  int getToatalSem() {
    int lastSem = 0;
    for (var sub in subjects) {
      if (sub.semester == 21 || sub.semester == 22) continue;
      lastSem = (sub.semester > lastSem) ? sub.semester : lastSem;
    }

    return lastSem;
  }

  void removeNonCreditSubject() {
    subjects.removeWhere((element) => element.credit == 0);
  }
}
