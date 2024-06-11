/// The CalculateCgpaBloc handles loading subject data from the database and calculating CGPA.
///
/// It dispatches LoadSubjects events to trigger loading subjects from the database for a given course.
/// The subjects are loaded from the database and stored in [semsubjects].
///
/// The bloc then emits a [SubjectsLoaded] state with the loaded subjects. Other blocs can listen
/// to this state to get the subject data for calculating CGPA.
import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sist_cgpa/constants.dart';
import 'package:sist_cgpa/utilites/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sist_cgpa/utilites/sqlite_db.dart';

import '../../../models/semSubject.dart';
import '../../../utilites/utils.dart';

part 'calculate_cgpa_event.dart';
part 'calculate_cgpa_state.dart';

class CalculateCgpaBloc extends Bloc<CalculateCgpaEvent, CalculateCgpaState> {
  CalculateCgpaBloc() : super(CalculateCgpaInitial()) {
    on<CalculateGpa>(calculateGpa);
    on<CalculateCgpa>(calculateCgpa);
    on<LoadSubjects>(loadSubjects);
  }

  // void getUserData() async {
  //   var authToken = "";
  //   var regno = "";
  //   var startYear = 0;
  //   var endYear = 0;
  //   try {
  //     authToken = await secureStorage.readSecureData(authTokenKey);
  //     regno = await secureStorage.readSecureData(regnoKey);
  //     startYear = int.parse(await secureStorage.readSecureData(startYearKey));
  //     endYear = int.parse(await secureStorage.readSecureData(endYearKey));
  //   } catch (e) {
  //     print(e);
  //     return;
  //   }

  //   // print(
  //   //     "${startYear + (sem ~/ 2).ceil() - 1}-${startYear + (sem ~/ 2).ceil()}");

  //   var url =
  //       "https://erp.sathyabama.ac.in/erp/api/v1.0/ResultMark/studentResult";
  //   var client = http.Client();
  //   var headers = {
  //     "Authorization": "Bearer ${await getAuthToken()}",
  //   };

  //   var year = startYear + (selectedSem / 2).ceil();
  //   var body = {
  //     "RegisterNumber": regno,
  //     "AcademicMonthId": "${selectedSem % 2 == 0 ? 1 : 2}",
  //     "AcademicYear": "${year - 1}-$year",
  //     "Semester": "$selectedSem"
  //   };
  //   print("body:  $body");
  //   var response =
  //       await client.post(Uri.parse(url), headers: headers, body: body);
  //   var data = jsonDecode(response.body)["responseData"]["SemResult"];
  //   // print(data);
  //   for (var i in data) {
  //     print("subject code : ${i["SubjectCode"]}");
  //     print("Subject Name : ${i["SubjectName"]}");
  //     var semsub = semSubjects[currSem]!.firstWhere(
  //       (element) {
  //         var sub = element.sub;
  //         print("**************************************");
  //         print("${sub.subCode} : ${i["SubjectCode"]}");
  //         print("${sub.subName} == ${i["SubjectName"]}");

  //         return sub.subCode == i["SubjectCode"].trim() ||
  //             sub.subName == i["SubjectName"].trim();
  //       },
  //     );
  //     semsub.texController.text = i["TotalMark"].toString();
  //   }
  // }

  // void loadSubs() async {

  //     for (var i = 1; i <= currentCourse.maxsem; i++) {
  //       allSemGpa.addAll({"sem $i": -1.0});
  //     }
  //
  //   });
  //   getUserData();
  //   createDropdownItems();
  // }

  FutureOr<void> calculateGpa(
    CalculateGpa event,
    Emitter<CalculateCgpaState> emit,
  ) {
    var gpa = 0.0;
    var totalCredit = 0;
    for (var sub in event.subjects) {
      var gradePoint = -1;
      var subMark = int.parse(sub.textController.text);
      if (subMark == sub.sub.maxMarks) gradePoint = 10;
      if (sub.sub.maxMarks == 50) subMark = subMark * 2;
      gradePoint = (gradePoint == -1) ? subMark ~/ 10 + 1 : gradePoint;
      gpa += gradePoint * sub.sub.credit;
      totalCredit += sub.sub.credit;
    }
    gpa = gpa / totalCredit;
    emit(GpaResult(gpa: gpa));
  }

  FutureOr<void> calculateCgpa(
    CalculateCgpa event,
    Emitter<CalculateCgpaState> emit,
  ) {
    var cgpa = 0.0;
    var totalCredit = 0;
    event.semsubjects.forEach((key, subjects) {
      for (var sub in subjects) {
        var gradePoint = -1;
        var subMark = int.parse(sub.textController.text);
        if (subMark == sub.sub.maxMarks) gradePoint = 10;
        if (sub.sub.maxMarks == 50) subMark = subMark * 2;
        gradePoint = (gradePoint == -1) ? subMark ~/ 10 + 1 : gradePoint;
        cgpa += gradePoint * sub.sub.credit;
        totalCredit += sub.sub.credit;
      }
    });

    cgpa = cgpa / totalCredit;
    emit(CgpaResult(cgpa: cgpa));
  }

  FutureOr<void> loadSubjects(
    LoadSubjects event,
    Emitter<CalculateCgpaState> emit,
  ) async {
    Map<int, List<SemSubject>> semSubjects = {};
    var authToken = "";
    var regno = "";
    var startYear = 0;
    var endYear = 0;
    var secureStorage = SecureStorage();
    try {
      authToken = await secureStorage.readSecureData(authTokenKey);
      regno = await secureStorage.readSecureData(regnoKey);
      startYear = int.parse(await secureStorage.readSecureData(startYearKey));
      endYear = int.parse(await secureStorage.readSecureData(endYearKey));
    } catch (e) {
      print(e);
      return;
    }

    // print(
    //     "${startYear + (sem ~/ 2).ceil() - 1}-${startYear + (sem ~/ 2).ceil()}");

    //get student detial

    var url =
        "https://erp.sathyabama.ac.in/erp/api/v1.0/ResultMark/studentResult";
    var client = http.Client();
    var headers = {
      "Authorization": "Bearer ${await getAuthToken()}",
    };
    var totalSemsUntil = (DateTime.now().year - startYear) * 2;
    print("totalSemsUntil : $totalSemsUntil");
    for (var curSem = 1; curSem <= totalSemsUntil; curSem++) {
      // semSubjects[curSem] = [];
      var year = startYear + (curSem / 2).ceil();
      var body = {
        "RegisterNumber": regno,
        "AcademicMonthId": "${curSem % 2 == 0 ? 1 : 2}",
        "AcademicYear": "${year - 1}-$year",
        "Semester": "$curSem"
      };
      // print("body:  $body");
      var response =
          await client.post(Uri.parse(url), headers: headers, body: body);
      var data = jsonDecode(response.body)["responseData"]["SemResult"];
      // print(data);
      print("testevent : semseter $curSem");
      for (var i in data) {
        if (!semSubjects.keys.contains(curSem)) semSubjects[curSem] = [];
        print("subject code : ${i["SubjectCode"]}");
        // print("Subject Name : ${i["SubjectName"]}");
        var sub = (await SqliteDB().searchSubject(
          "${i["SubjectCode"].toString().trim()} ${i["SubjectName"].toString().trim()}",
        ))[0];
        print("testevent : ${i["SubjectCode"]} ${i["SubjectName"]}");
        print("testevent : ${sub.subCode} : ${sub.subName}");
        var semsub = SemSubject(
          sub: sub,
          mark: int.parse(
            i["TotalMark"],
          ),
        );
        semSubjects[curSem]!.add(semsub);
      }
    }
    // print("subject loaded emited ${semSubjects.keys}");
    emit(SubjectsLoaded(semSubjects: semSubjects));
  }
}
