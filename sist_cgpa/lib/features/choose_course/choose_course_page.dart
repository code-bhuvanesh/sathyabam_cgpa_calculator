import 'package:flutter/material.dart';

import '../../utilites/sqlite_db.dart';
import '../calculate_cgpa/calculate_cgpa_page.dart';
import '../../widget/common_list_widget.dart';

class ChooseCourse extends StatefulWidget {
  const ChooseCourse({super.key, required this.branch});
  final String branch;

  static const String routeName = "/chooseCourse";

  @override
  State<ChooseCourse> createState() => _ChooseCourseState();
}

class _ChooseCourseState extends State<ChooseCourse> {
  List<String> courses = [];
  late Map<String, dynamic> data;
  late String selectedBranch;
  List<String> filteredcourses = [];
  late SqliteDB sqliteDB;
  @override
  void initState() {
    sqliteDB = SqliteDB();
    loadCourses();
    super.initState();
  }

  void loadCourses() async {
    var c = await sqliteDB.getCourses(widget.branch);
    setState(() {
      courses = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select your Course",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: (courses.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CommonListWidget(
              whatToSelect: "Course",
              nextPage: CalculateGpaPage.routeName,
              allItems: courses,
              totalHeight: totalHeight,
            ),
    );
  }
}
