/// The CalculateCgpaBloc handles loading subject data from the database and calculating CGPA.
///
/// It dispatches LoadSubjects events to trigger loading subjects from the database for a given course.
/// The subjects are loaded from the database and stored in [semsubjects].
///
/// The bloc then emits a [SubjectsLoaded] state with the loaded subjects. Other blocs can listen
/// to this state to get the subject data for calculating CGPA.
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/semSubject.dart';
import '../../../utilites/sqlite_db.dart';

part 'calculate_cgpa_event.dart';
part 'calculate_cgpa_state.dart';

class CalculateCgpaBloc extends Bloc<CalculateCgpaEvent, CalculateCgpaState> {
  Map<String, List<SemSubject>> semsubjects = {};

  CalculateCgpaBloc() : super(CalculateCgpaInitial()) {
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

  Future<FutureOr<void>> loadSubjects(
    LoadSubjects event,
    Emitter<CalculateCgpaState> emit,
  ) async {
    var c = await SqliteDB().getCourse(event.course);
    Map<String, List<SemSubject>> semSubjects = {};
    for (var s = 1; s <= c.maxsem; s++) {
      semSubjects["sem $s"] = c
          .getBySem(s)
          .map(
            (e) => SemSubject(sub: e),
          )
          .toList();
    }
    emit(SubjectsLoaded(semSubjects: semsubjects));
  }
}
