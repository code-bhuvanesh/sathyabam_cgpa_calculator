import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sist_cgpa/features/calculate_cgpa/bloc/calculate_cgpa_bloc.dart';
import 'package:sist_cgpa/models/semSubject.dart';
import 'package:sist_cgpa/utilites/sqlite_db.dart';
import 'package:sqflite/sqflite.dart';

import '/utilites/utils.dart';
import '/constants.dart';
import '/models/course.dart';
import '/models/current_sem_cgpa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/subject.dart';
import '../../utilites/secure_storage.dart';
import '../../widget/subject_wiget.dart';
import '../show_cgpa/show_cgpa_page.dart';

class CalculateGpaPage extends StatefulWidget {
  const CalculateGpaPage({
    super.key,
    required String course,
  }) : _course = course;

  static const String routeName = "/CalculateGpaPage";

  final String _course;

  @override
  State<CalculateGpaPage> createState() => _CalculateGpaPageState();
}

class _CalculateGpaPageState extends State<CalculateGpaPage> {
  Map<String, CurrentSemCgpa> cgpaList = {};

  late Course currentCourse;
  List<DropdownMenuItem> dropDownItems = [];
  var currSem = "sem 1";
  Map<String, double> allSemGpa = {};
  double curGpa = -1.0;
  // Map<String, bool> gpaCompltedList = {};
  int selectedSem = 1;
  // Map<String, Map<String, TextEditingController>> subjectsTEC = {};

  Map<String, List<SemSubject>> semSubjects = {};

  //user details
  SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // loadSubs();
    // getUserData();
    context.read<CalculateCgpaBloc>().add(LoadSubjects(course: widget._course));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // for (var semsub in semSubjects.values) {
    //   for (var element in semsub) {
    //     element.texController.dispose();
    //   }
    // }
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
  //     // // print(
  //     // //     "teokt ${subjectsTEC[currSem]!.containsKey(i["SubjectCode"].trim())}");
  //     // if (subjectsTEC[currSem]!.containsKey(i["SubjectCode"].trim())) {
  //     //   var subjectCode = subName.subCode ?? i["SubjectCode"];
  //     //   subjectsTEC[currSem]![subjectCode]!.text = i["TotalMark"].toString();
  //     //   print("subject code : ${i["SubjectCode"]}");
  //     //   print("Subject Name : ${i["SubjectName"]}");
  //     //   print("mark: ${i["TotalMark"]}");
  //     // }
  //   }
  //   calculateGPA();
  //   // print();
  // }

  // void loadSubs() async {
  //   var c = await SqliteDB().getCourse(widget._course);
  //   print(c);
  //   setState(() {
  //     currentCourse = c;

  //     for (var i = 1; i <= currentCourse.maxsem; i++) {
  //       allSemGpa.addAll({"sem $i": -1.0});
  //     }
  //     for (var s = 1; s <= currentCourse.maxsem; s++) {
  //       semSubjects["sem $s"] = currentCourse
  //           .getBySem(s)
  //           .map(
  //             (e) => SemSubject(sub: e),
  //           )
  //           .toList();
  //     }
  //   });
  //   getUserData();
  //   createDropdownItems();
  // }

  void checkToCalculate() {
    // for (var semSub in semSubjects[currSem]!) {
    //   if (semSub.texController.text.isNotEmpty) return;
    // }
    // calculateGPA();
  }

  void dropdownCallback(dynamic selectedValue) {
    // setState(() {
    //   // if (!subjectsTEC.containsKey(currSem)) {
    //   //   subjectsTEC.addAll({currSem: {}});
    //   // }
    //   // allSemGpa = 0;
    //   curGpa = -1.0;
    //   if (selectedValue != null) {
    //     currSem = selectedValue;
    //     selectedSem = int.parse((selectedValue as String).split(" ")[1]);
    //   }
    // });
    // getUserData();
  }

  // void createDropdownItems() {
  //   dropDownItems.clear();

  //   for (var i = 1; i <= currentCourse.getToatalSem(); i++) {
  //     dropDownItems.add(DropdownMenuItem(
  //       value: "sem $i",
  //       child: Text(
  //         "sem $i",
  //         style: const TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //     ));
  //   }
  // }

  // void showErrorDialog() {
  //   showDialog(
  //     context: context,
  //     builder: ((context) => CupertinoAlertDialog(
  //           title: const Text(
  //             "mark should be less than total marks of the subject",
  //           ),
  //           actions: [
  //             CupertinoDialogAction(
  //               child: const Text("OK"),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //           ],
  //         )),
  //   );
  // }

  // void calculateGPA() {
  //   var creditGrade = 0;
  //   var totalCredit = 0;
  //   for (var semSub in semSubjects[currSem]!) {
  //     if (semSub.texController.value.text.isNotEmpty) {
  //       double mark = double.parse(semSub.texController.value.text);
  //       var curSubject = semSub.sub;
  //       mark = ((mark / (curSubject.maxMarks)) * 100);
  //       if (mark > 100) {
  //         showErrorDialog();
  //       } else {
  //         creditGrade += ((mark ~/ 10) + 1) * curSubject.credit;
  //         totalCredit += curSubject.credit;
  //         // print("${curSubject.subCode} : m : $mark,  ${((mark ~/ 10) + 1)}");
  //       }
  //     }
  //   }
  //   // print("total credit : $totalCredit");

  //   cgpaList["sem $selectedSem"] =
  //       CurrentSemCgpa(SubjectCredit: creditGrade, totalCredit: totalCredit);
  //   setState(() {
  //     curGpa = creditGrade / totalCredit;
  //     allSemGpa[currSem] = curGpa;
  //   });
  // }

  // bool checkAllBetweenSemsAvailable() {
  //   // int gsem = 0; //greater sem
  //   bool gpaNotCalculated = true;
  //   bool oneIsFalse = false;
  //   for (var element in allSemGpa.values) {
  //     if (!oneIsFalse) {
  //       gpaNotCalculated = gpaNotCalculated && (element > 0);
  //       if (!gpaNotCalculated) {
  //         oneIsFalse = true;
  //       }
  //     } else {
  //       if (element > 0) {
  //         return false;
  //       }
  //     }
  //   }

  //   return true;
  // }

  // void showTotalCgpa() {
  //   var subjectCredit = 0;
  //   var totalCredit = 0;
  //   for (var sem in cgpaList.values) {
  //     subjectCredit += sem.SubjectCredit;
  //     totalCredit += sem.totalCredit;
  //   }
  //   var cgpa = subjectCredit / totalCredit;
  //   Navigator.of(context).pushNamed(
  //     ShowCgpa.routeName,
  //     arguments: [cgpa.toStringAsFixed(2)],
  //   );
  // }

  // bool checkTextNotEmpty() {
  //   for (var semsub in semSubjects[currSem]!) {
  //     if (semsub.texController.text.isNotEmpty) return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    // if (!subjectsTEC.containsKey(currSem)) {
    //   subjectsTEC.addAll({currSem: {}});
    // }
    // if (!allSemGpa.containsKey(currSem)) {
    //   allSemGpa.addAll({currSem: -1.0});
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CGPA calculator",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocListener<CalculateCgpaBloc, CalculateCgpaState>(
        listener: (context, state) {
          if (state is SubjectsLoaded) {
            setState(() {
              semSubjects = state.semSubjects;
            });
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Card(
                  color: Colors.lightBlue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton(
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.lightBlue,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      elevation: 10,
                      value: currSem,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropDownItems,
                      onChanged: dropdownCallback,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: (semSubjects.isEmpty)
                    ? const CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: semSubjects[currSem]!.length,
                        itemBuilder: ((context, index) {
                          var semSub = semSubjects[currSem]![index]!;
                          var sub = semSub.sub;
                          return SubjectItem(
                            subCode: sub.subCode,
                            subName: sub.subName,
                            tec: semSub.texController,
                            subMaxMarks: sub.maxMarks.toString(),
                            checkToCalculate: checkToCalculate,
                          );
                        }),
                      ),
              ),
            ),
            (curGpa >= 0)
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "GPA for semester $selectedSem : ${allSemGpa[currSem]!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            // checkAllBetweenSemsAvailable()
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             // ElevatedButton(
            //             //   onPressed: calculateGPA,
            //             //   style: ButtonStyle(
            //             //     backgroundColor:
            //             //         MaterialStateProperty.all(Colors.lightBlue),
            //             //   ),
            //             //   child: const Text("Calculate"),
            //             // ),
            //             ElevatedButton(
            //               onPressed: checkAllBetweenSemsAvailable()
            //                   ? showTotalCgpa
            //                   : null,
            //               style: ButtonStyle(
            //                 backgroundColor:
            //                     MaterialStateProperty.all(Colors.lightBlue),
            //               ),
            //               child: const Text("show CGPA"),
            //             ),
            //           ],
            //         ),
            //       )
            //     : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
