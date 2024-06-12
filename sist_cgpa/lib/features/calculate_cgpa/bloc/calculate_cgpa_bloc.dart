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
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sist_cgpa/constants.dart';
import 'package:sist_cgpa/utilites/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sist_cgpa/utilites/sqlite_db.dart';

import '../../../models/sem_subject.dart';
import '../../../models/subject.dart';
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
  //     debugPrint(e);
  //     return;
  //   }

  //   // debugPrint(
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
  //   debugPrint("body:  $body");
  //   var response =
  //       await client.post(Uri.parse(url), headers: headers, body: body);
  //   var data = jsonDecode(response.body)["responseData"]["SemResult"];
  //   // debugPrint(data);
  //   for (var i in data) {
  //     debugPrint("subject code : ${i["SubjectCode"]}");
  //     debugPrint("Subject Name : ${i["SubjectName"]}");
  //     var semsub = semSubjects[currSem]!.firstWhere(
  //       (element) {
  //         var sub = element.sub;
  //         debugPrint("**************************************");
  //         debugPrint("${sub.subCode} : ${i["SubjectCode"]}");
  //         debugPrint("${sub.subName} == ${i["SubjectName"]}");

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

  List<double> gpaSubFuntion(List<SemSubject> subjects) {
    var gpa = 0.0;
    var totalCredit = 0.0;
    for (var sub in subjects) {
      var gradePoint = -1;
      var subMark = int.parse(sub.textController.text);
      if (subMark == sub.sub.maxMarks) gradePoint = 10;
      if (sub.sub.maxMarks != 100) {
        subMark = ((subMark / sub.sub.maxMarks) * 100).toInt();
      }
      gradePoint = (gradePoint == -1) ? subMark ~/ 10 + 1 : gradePoint;
      gpa += gradePoint * sub.sub.credit;
      totalCredit += sub.sub.credit;
    }
    return [gpa, totalCredit];
  }

  FutureOr<void> calculateGpa(
    CalculateGpa event,
    Emitter<CalculateCgpaState> emit,
  ) {
    var gpaResult = gpaSubFuntion(event.subjects);
    var gpa = gpaResult[0] / gpaResult[1];
    emit(GpaResult(gpa: gpa));
  }

  Future<FutureOr<void>> calculateCgpa(
    CalculateCgpa event,
    Emitter<CalculateCgpaState> emit,
  ) async {
    var cgpa = 0.0;
    var totalCredit = 0.0;
    event.semsubjects.forEach((key, subjects) {
      var gpaResult = gpaSubFuntion(subjects);
      cgpa += gpaResult[0];
      totalCredit += gpaResult[1];
    });

    cgpa = cgpa / totalCredit;
    emit(CgpaResult(cgpa: cgpa));
    // await SecureStorage().saveSemSubjects(event.semsubjects);
  }

  FutureOr<void> loadSubjects(
    LoadSubjects event,
    Emitter<CalculateCgpaState> emit,
  ) async {
    //load saved semsubjects
    var semSubjects = await SecureStorage().readSemSubjects();
    debugPrint("saved subjects : $semSubjects");
    if (semSubjects.isNotEmpty) {
      emit(
        SubjectsLoaded(
          semSubjects: semSubjects,
        ),
      );
    } else {
      // Map<int, List<SemSubject>> semSubjects = {};
      // var authToken = "";
      var regno = "";
      var startYear = 0;
      // var endYear = 0;
      var secureStorage = SecureStorage();
      try {
        // authToken = await secureStorage.readSecureData(authTokenKey);
        regno = await secureStorage.readSecureData(regnoKey);
        startYear = int.parse(await secureStorage.readSecureData(startYearKey));
        // endYear = int.parse(await secureStorage.readSecureData(endYearKey));
      } catch (e) {
        debugPrint(e.toString());
        return;
      }

      // debugPrint(
      //     "${startYear + (sem ~/ 2).ceil() - 1}-${startYear + (sem ~/ 2).ceil()}");

      //get student detial

      var url =
          "https://erp.sathyabama.ac.in/erp/api/v1.0/ResultMark/studentResult";
      var client = http.Client();
      var headers = {
        "Authorization": "Bearer ${await getAuthToken()}",
      };
      var totalSemsUntil = (DateTime.now().year - startYear) * 2;
      debugPrint("totalSemsUntil : $totalSemsUntil");
      for (var curSem = 1; curSem <= totalSemsUntil; curSem++) {
        // semSubjects[curSem] = [];
        var year = startYear + (curSem / 2).ceil();
        var body = {
          "RegisterNumber": regno,
          "AcademicMonthId": "${curSem % 2 == 0 ? 1 : 2}",
          "AcademicYear": "${year - 1}-$year",
          "Semester": "$curSem"
        };
        // debugPrint("body:  $body");
        var response =
            await client.post(Uri.parse(url), headers: headers, body: body);
        var data = jsonDecode(response.body)["responseData"]["SemResult"];
        // debugPrint(data);
        debugPrint("testevent : semseter $curSem");
        for (var i in data) {
          if (!semSubjects.keys.contains(curSem)) semSubjects[curSem] = [];
          debugPrint("subject code : ${i["SubjectCode"]}");
          // debugPrint("Subject Name : ${i["SubjectName"]}");
          var subs = (await SqliteDB().searchSubject(
            "${i["SubjectCode"].toString().trim()} ${i["SubjectName"].toString().trim()}",
          ));
          Subject sub;
          if (subs.isNotEmpty) {
            sub = subs[0];
          } else {
            sub = Subject(
              semester: curSem,
              subCode: i["SubjectCode"],
              subName: i["SubjectName"],
              subType: "THEORY",
              credit: 3,
              maxMarks: 100,
            );
          }

          debugPrint("testevent : ${i["SubjectCode"]} ${i["SubjectName"]}");
          debugPrint("testevent : ${sub.subCode} : ${sub.subName}");
          var semsub = SemSubject(
            sub: sub,
            mark: int.parse(
              i["TotalMark"],
            ),
          );
          semSubjects[curSem]!.add(semsub);
        }
      }
      // debugPrint("subject loaded emited ${semSubjects.keys}");
      emit(SubjectsLoaded(semSubjects: semSubjects));
      await SecureStorage().saveSemSubjects(semSubjects);
    }
  }
}
