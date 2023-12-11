import '../calculate_cgpa/calculate_cgpa_page.dart';
import 'package:flutter/material.dart';

import '../../widget/common_list_widget.dart';

class ChooseCourse extends StatefulWidget {
  const ChooseCourse({super.key, required this.args});

  static const String routeName = "/chooseCourse";
  final List<dynamic> args;

  @override
  State<ChooseCourse> createState() => _ChooseCourseState();
}

class _ChooseCourseState extends State<ChooseCourse> {
  List<String> courses = [];
  late Map<String, dynamic> data;
  late String selectedBranch;

  @override
  void initState() {
    selectedBranch = widget.args[0] as String;
    data = widget.args[1] as Map<String, dynamic>;
    courses = data.keys.toList();
    super.initState();
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
        body: CommonListWidget(
            whatToSelect: "Course",
            nextPage: CalculateGpaPage.routeName,
            allItems: courses,
            totalHeight: totalHeight,
            data: data,
            argumentsGenerator: (String index) => data[index]));
  }
}
