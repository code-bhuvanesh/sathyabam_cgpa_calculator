import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sist_cgpa/features/add_subjects/add_subjects_page.dart';
import 'package:sist_cgpa/features/calculate_cgpa/bloc/calculate_cgpa_bloc.dart';
import 'package:sist_cgpa/features/settings/settings_page.dart';
import 'package:sist_cgpa/features/show_cgpa/show_cgpa_page.dart';
import 'package:sist_cgpa/models/sem_subject.dart';
import 'package:sist_cgpa/utilites/theme.dart';

import '../../widget/subject_wiget.dart';
import '/models/course.dart';
import '/models/current_sem_cgpa.dart';
import 'package:flutter/material.dart';

import '../../utilites/secure_storage.dart';

class CalculateGpaPage extends StatefulWidget {
  const CalculateGpaPage({
    super.key,
  });

  static const String routeName = "/CalculateGpaPage";

  @override
  State<CalculateGpaPage> createState() => _CalculateGpaPageState();
}

class _CalculateGpaPageState extends State<CalculateGpaPage>
    with SingleTickerProviderStateMixin {
  Map<String, CurrentSemCgpa> cgpaList = {};

  late Course currentCourse;
  List<DropdownMenuItem> dropDownItems = [];
  var currSem = 1;
  var totalSem = 1;
  Map<String, double> allSemGpa = {};
  double curGpa = -1.0;
  // Map<String, bool> gpaCompltedList = {};
  int selectedSem = 1;
  // Map<String, Map<String, TextEditingController>> subjectsTEC = {};

  Map<int, List<SemSubject>> semSubjects = {};

  //user details
  SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    context.read<CalculateCgpaBloc>().add(LoadSubjects());
  }

  late ScrollController _scrollController;
  Color _containerColor = backgroundColor;
  void _onScroll() {
    double offset = _scrollController.offset;
    setState(() {
      // debugPrint(offset);
      if (offset > 0) {
        _containerColor = scrollContainerColor;
      } else {
        _containerColor = backgroundColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CGPA calculator",
          style: TextStyle(
              // color: Colors.black,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SetttingsPage.routeName);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          )
        ],
        // iconTheme: const IconThemeData(color: Colors.black),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        // centerTitle: true,
      ),
      body: BlocListener<CalculateCgpaBloc, CalculateCgpaState>(
        listener: (context, state) async {
          if (state is SubjectsLoaded) {
            for (var element in state.semSubjects.keys) {
              if (element > totalSem) {
                totalSem = element;
              }
            }
            debugPrint("total sem : $totalSem");
            setState(() {
              semSubjects = state.semSubjects;
              totalSem = totalSem;
            });
          } else if (state is GpaResult) {
            setState(() {
              curGpa = state.gpa;
            });
            await SecureStorage().saveSemSubjects(
                semSubjects); //when ever a new subject is added
          } else if (state is CgpaResult) {
            Navigator.of(context).pushNamed(
              ShowCgpa.routeName,
              arguments: state.cgpa,
            );
          }
        },
        child: Container(
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: _containerColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    arrowButton(isLeftButton: true),
                    Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          child: Text(
                            "Semmester $currSem",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    arrowButton(isLeftButton: false),
                  ],
                ),
              ),
              Expanded(
                child: (semSubjects.keys.contains(currSem))
                    ? ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (_, index) {
                          var semSubject = semSubjects[currSem]![index];
                          return SubjectItem(
                            subject: semSubject.sub,
                            tec: semSubject.textController,
                            onDelete: () {
                              setState(() {
                                semSubjects[currSem]!.removeAt(index);
                              });
                              context.read<CalculateCgpaBloc>().add(
                                    CalculateGpa(
                                      subjects: semSubjects[currSem]!,
                                    ),
                                  );
                            },
                          );
                        },
                        itemCount: semSubjects[currSem]!.length,
                      )
                    : const Center(
                        child: Text(
                          "Add some subjects to calculate CGPA",
                        ),
                      ),
              ),
              (semSubjects.keys.contains(currSem) &&
                      semSubjects[currSem]!.isNotEmpty)
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: _containerColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: Text(
                              "Semester $currSem GPA : ${curGpa.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CalculateCgpaBloc>().add(
                                    CalculateCgpa(
                                      semsubjects: semSubjects,
                                    ),
                                  );
                            },
                            child: const Text(
                              "Calculate CGPA",
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = (await Navigator.of(context)
              .pushNamed(AddSubjectsPage.routeName));
          // debugPrint("result is : $result");
          if (result != null) {
            var newSubject = result as SemSubject;
            if (!semSubjects.keys.contains(currSem)) {
              semSubjects[currSem] = [];
            }
            setState(
              () {
                semSubjects[currSem]!.add(newSubject);
              },
            );
            // ignore: use_build_context_synchronously
            context.read<CalculateCgpaBloc>().add(
                  CalculateGpa(
                    subjects: semSubjects[currSem]!,
                  ),
                );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Card arrowButton({required bool isLeftButton}) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: IconButton(
        icon: Icon(
          isLeftButton
              ? Icons.arrow_left
              : (currSem == totalSem)
                  ? Icons.add
                  : Icons.arrow_right,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
            );
          }
          if (isLeftButton && currSem > 1) {
            currSem--;
          } else if (currSem < totalSem) {
            currSem++;
          } else if (currSem == totalSem) {
            totalSem++;
            currSem++;
          }
          if (!semSubjects.keys.contains(currSem)) {
            semSubjects[currSem] = [];
          } else {
            context.read<CalculateCgpaBloc>().add(
                  CalculateGpa(
                    subjects: semSubjects[currSem]!,
                  ),
                );
          }
          setState(
            () {
              currSem = currSem;
            },
          );
        },
      ),
    );
  }
}
