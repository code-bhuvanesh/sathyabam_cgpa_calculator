import 'dart:convert';

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
    required Map<String, dynamic> data,
  }) : _data = data;

  static const String routeName = "/CalculateGpaPage";

  final Map<String, dynamic> _data;

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
  List<Subject> semSubjects = [];
  Map<String, Map<String, TextEditingController>> subjectsTEC = {};

  Map<String,Map<String, dynamic>> subjects = {
    // "subcode" : {
    //   "textController" : TextEditingController(),
    //   "sub" : Subject

    // }
  };

  //user details
  SecureStorage secureStorage = SecureStorage();



  @override
  void initState() {
    loadSubs();
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (var semTec in subjectsTEC.values) {
      for (var tec in semTec.values) {
        tec.dispose();
      }
    }
  }

  void getUserData() async {
    var authToken = "";
    var regno = "";
    var startYear = 0;
    var endYear = 0;
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

    var url =
        "https://erp.sathyabama.ac.in/erp/api/v1.0/ResultMark/studentResult";
    var client = http.Client();
    var headers = {
      "Authorization": "Bearer ${await getAuthToken()}",
    };

    var year = startYear + (selectedSem / 2).ceil();
    var body = {
      "RegisterNumber": regno,
      "AcademicMonthId": "${selectedSem % 2 == 0 ? 1 : 2}",
      "AcademicYear": "${year - 1}-$year",
      "Semester": "$selectedSem"
    };
    print("body:  $body");
    var response =
        await client.post(Uri.parse(url), headers: headers, body: body);
    var data = jsonDecode(response.body)["responseData"]["SemResult"];
    // print(data);
    for (var i in data) {
      print("subject code : ${i["SubjectCode"]}");
      print("Subject Name : ${i["SubjectName"]}");
      var subName = semSubjects.where(
        (element) {
          print("${i["SubjectCode"]} : ${i["SubjectName"]}");
          print("name ${element.subName} == ${i["SubjectName"]}");
          print("name ${element.subName == i["SubjectName"]}");

          return subjectsTEC[currSem]!.keys.contains(element.subCode.trim()) &&
              element.subName == i["SubjectName"];
        },
      ).firstOrNull;
      print(
          "teokt ${subjectsTEC[currSem]!.containsKey(i["SubjectCode"].trim())}");
      if (subjectsTEC[currSem]!.containsKey(i["SubjectCode"].trim())) {
        var subjectCode = subName?.subCode ?? i["SubjectCode"];
        subjectsTEC[currSem]![subjectCode]!.text = i["TotalMark"].toString();
        print("subject code : ${i["SubjectCode"]}");
        print("Subject Name : ${i["SubjectName"]}");
        print("mark: ${i["TotalMark"]}");
      }
    }
    calculateGPA();
    // print();
  }

  void loadSubs() async {
    setState(() {
      currentCourse = Course.fromJson("course name", widget._data);

      if (!subjectsTEC.containsKey(currSem)) {
        subjectsTEC.addAll({currSem: {}});
      }
      for (var i = 1; i <= currentCourse.getToatalSem(); i++) {
        allSemGpa.addAll({"sem $i": -1.0});
      }
      semSubjects = currentCourse.getBySem(selectedSem);
    });
    createDropdownItems();
  }

  void checkToCalculate() {
    bool canCalulate = true;
    for (var tec in subjectsTEC[currSem]!.values) {
      canCalulate = canCalulate && tec.text.isNotEmpty;
    }
    if (canCalulate) {
      calculateGPA();
    }
  }

  void dropdownCallback(dynamic selectedValue) {
    setState(() {
      if (!subjectsTEC.containsKey(currSem)) {
        subjectsTEC.addAll({currSem: {}});
      }
      // allSemGpa = 0;
      curGpa = -1.0;
      if (selectedValue != null) {
        currSem = selectedValue;
        selectedSem = int.parse((selectedValue as String).split(" ")[1]);
        semSubjects = currentCourse.getBySem(selectedSem);
      }
    });
    getUserData();
  }

  void createDropdownItems() {
    dropDownItems.clear();

    for (var i = 1; i <= currentCourse.getToatalSem(); i++) {
      dropDownItems.add(DropdownMenuItem(
        value: "sem $i",
        child: Text(
          "sem $i",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ));
    }
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: ((context) => CupertinoAlertDialog(
            title: const Text(
              "mark should be less than total marks of the subject",
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          )),
    );
  }

  void calculateGPA() {
    var creditGrade = 0;
    var totalCredit = 0;
    for (var tec in subjectsTEC[currSem]!.entries) {
      if (tec.value.value.text.isNotEmpty) {
        double mark = double.parse(tec.value.value.text);
        var curSubject =
            semSubjects.firstWhere((element) => element.subCode == tec.key);
        mark = ((mark / (curSubject.maxMarks)) * 100);
        if (mark > 100) {
          showErrorDialog();
        } else {
          creditGrade += ((mark ~/ 10) + 1) *
              semSubjects
                  .singleWhere((subject) => subject.subCode == tec.key)
                  .credit;
          totalCredit += semSubjects
              .singleWhere((subject) => subject.subCode == tec.key)
              .credit;
          print("${tec.key} : m : $mark,  ${((mark ~/ 10) + 1)}");
        }
      }
    }
    print("total credit : $totalCredit");

    cgpaList["sem $selectedSem"] =
        CurrentSemCgpa(SubjectCredit: creditGrade, totalCredit: totalCredit);
    setState(() {
      curGpa = creditGrade / totalCredit;
      allSemGpa[currSem] = curGpa;
    });
  }

  bool checkAllBetweenSemsAvailable() {
    // int gsem = 0; //greater sem
    bool gpaNotCalculated = true;
    bool oneIsFalse = false;
    for (var element in allSemGpa.values) {
      if (!oneIsFalse) {
        gpaNotCalculated = gpaNotCalculated && (element > 0);
        if (!gpaNotCalculated) {
          oneIsFalse = true;
        }
      } else {
        if (element > 0) {
          return false;
        }
      }
    }

    return true;
  }

  void showTotalCgpa() {
    var subjectCredit = 0;
    var totalCredit = 0;
    for (var sem in cgpaList.values) {
      subjectCredit += sem.SubjectCredit;
      totalCredit += sem.totalCredit;
    }
    var cgpa = subjectCredit / totalCredit;
    Navigator.of(context).pushNamed(
      ShowCgpa.routeName,
      arguments: [cgpa.toStringAsFixed(2)],
    );
  }

  bool checkTextNotEmpty() {
    var notEmpty = false;
    for (var tec in subjectsTEC[currSem]!.values) {
      notEmpty = notEmpty && tec.value.text.isNotEmpty;
    }
    return notEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!subjectsTEC.containsKey(currSem)) {
      subjectsTEC.addAll({currSem: {}});
    }
    if (!allSemGpa.containsKey(currSem)) {
      allSemGpa.addAll({currSem: -1.0});
    }
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
      body: Column(
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
                      itemCount: semSubjects.length,
                      itemBuilder: ((context, index) {
                        if (!subjectsTEC[currSem]!
                            .containsKey(semSubjects[index].subCode)) {
                          subjectsTEC[currSem]!.addAll({
                            semSubjects[index].subCode:
                                // TextEditingController(
                                // text: (semSubjects[index].maxMarks - 3)
                                //     .toString()),
                                TextEditingController(),
                          });
                        }

                        return SubjectItem(
                          subCode: semSubjects[index].subCode,
                          subName: semSubjects[index].subName,
                          tec: subjectsTEC[currSem]![
                              semSubjects[index].subCode]!,
                          subMaxMarks: semSubjects[index].maxMarks.toString(),
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
          checkAllBetweenSemsAvailable()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ElevatedButton(
                      //   onPressed: calculateGPA,
                      //   style: ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStateProperty.all(Colors.lightBlue),
                      //   ),
                      //   child: const Text("Calculate"),
                      // ),
                      ElevatedButton(
                        onPressed: checkAllBetweenSemsAvailable()
                            ? showTotalCgpa
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightBlue),
                        ),
                        child: const Text("show CGPA"),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
