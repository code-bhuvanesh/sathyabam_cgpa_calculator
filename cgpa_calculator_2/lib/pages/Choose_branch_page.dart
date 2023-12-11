import 'dart:convert';

import '/pages/choose_course_page.dart';
import '/widget/common_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChooseBranch extends StatefulWidget {
  const ChooseBranch({super.key});

  static const String routeName = "/chooseBranch";

  @override
  State<ChooseBranch> createState() => _ChooseBranchState();
}

class _ChooseBranchState extends State<ChooseBranch> {
  List<String> branches = [];
  late Map<String, dynamic> data = {};
  List<String> filteredbranches = [];

  @override
  void initState() {
    readJson();
    super.initState();
  }

  void readJson() async {
    var response = await rootBundle.loadString("assets/course_credits.json");
    setState(() {
      data = jsonDecode(response) as Map<String, dynamic>;
      branches = data.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select your Branch",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: (data.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CommonListWidget(
              whatToSelect: "branch",
              nextPage: ChooseCourse.routeName,
              allItems: branches,
              totalHeight: totalHeight,
              data: data,
              argumentsGenerator: (index) => [index, data[index]],
            ),
    );
  }
}
