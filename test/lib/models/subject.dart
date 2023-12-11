class Subject {
  Subject({
    required this.semester,
    required this.id,
    required this.subCode,
    required this.subName,
    required this.subType,
    required this.credit,
    required this.caeMarks,
    required this.eseMarks,
    // required this.subLectureHours,
    // required this.subTutorialHours,
    // required this.subPrcaticalHours,
  });
  final int id;
  final int semester;
  final String subCode;
  final String subName;
  final String subType;
  final int credit;
  final int caeMarks;
  final int eseMarks;
  get maxMarks {
    int maxMarks = caeMarks + eseMarks;
    if (maxMarks == 0) maxMarks = 100;
    return maxMarks;
  }
  // final int subLectureHours;
  // final int subTutorialHours;
  // final int subPrcaticalHours;

  factory Subject.fromJson(String subCode, Map<String, dynamic> json) {
    return Subject(
      id: json["id"],
      semester: json["semester"],
      subCode: subCode,
      subName: json["coursetitle"],
      subType: json["coursetype"],
      credit: json["credit"],
      caeMarks: json["cae"],
      eseMarks: json["ese"],
      // subLectureHours: json["lecture"],
      // subTutorialHours: json["tutorial"],
      // subPrcaticalHours: json["practical"],
    );
  }
}
