import 'dart:convert';

import '../../utilites/sqlite_db.dart';
import '../choose_course/choose_course_page.dart';
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
  late SqliteDB sqliteDB;
  @override
  void initState() {
    sqliteDB = SqliteDB();
    loadBranches();
    super.initState();
  }

  void loadBranches() async {
    var b = await sqliteDB.getBranchs();
    setState(() {
      branches = b;
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
      body: (branches.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CommonListWidget(
              whatToSelect: "branch",
              nextPage: ChooseCourse.routeName,
              allItems: branches,
              totalHeight: totalHeight,
            ),
    );
  }
}
