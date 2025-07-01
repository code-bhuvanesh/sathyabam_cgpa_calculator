import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../add_subjects/add_subjects_page.dart';
import '../logout/logout_page.dart';
import '../show_cgpa/show_cgpa_page.dart';
import 'bloc/calculate_cgpa_bloc.dart';
import '/models/sem_subject.dart';
import '/utilites/theme.dart';
import '/widget/subject_wiget.dart';
import '/models/course.dart';
import '/models/current_sem_cgpa.dart';
import '/utilites/secure_storage.dart';

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

  bool dialogShown = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<CalculateCgpaBloc>().add(LoadSubjects());
    () async {
      print("semsubjects323 : \n${await SecureStorage().readSemSubjects()}");
    };
    // print("*******************************");
    // print("*******************************");
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showEnsureDialog();
    });
    super.didChangeDependencies();
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

  void showEnsureDialog() {
    if (dialogShown) return;
    dialogShown = true;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Ensure all the subjects are listed in each semester to calculate CGPA properly.\n\nThere may be some missing subjects. \n\nUnfortunately latest semster marks may not be available in ERP so you need to manually add it.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("ok"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SIST CGPA",
          style: TextStyle(
              // color: Colors.black,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(LogoutPage.routeName);
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

            if (semSubjects.containsKey(currSem)) {
              context.read<CalculateCgpaBloc>().add(
                    CalculateGpa(
                      subjects: semSubjects[currSem]!,
                    ),
                  );
            }
          } else if (state is GpaResult) {
            setState(() {
              curGpa = state.gpa;
            });
          } else if (state is CgpaResult) {
            if (mounted) {
              Navigator.of(context).pushNamed(
                ShowCgpa.routeName,
                arguments: state.cgpa,
              );
            }
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
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Text(
                          "semester $currSem",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    arrowButton(isLeftButton: false),
                  ],
                ),
              ),
              Expanded(
                child: (semSubjects.keys.contains(currSem) &&
                        semSubjects[currSem]!.isNotEmpty)
                    ? ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                          bottom: 15,
                        ),
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
                            updateGPA: () {
                              context.read<CalculateCgpaBloc>().add(
                                  CalculateGpa(
                                      subjects: semSubjects[currSem]!));
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

            setState(() {
              //if subject is not already added add it
              if (semSubjects[currSem]!
                  .where((e) => (e.sub.subCode == newSubject.sub.subCode))
                  .isEmpty) {
                semSubjects[currSem]!.add(newSubject);
              } else {
                Fluttertoast.showToast(msg: "subject has already added");
              }
            });

            await SecureStorage().saveSemSubjects(
                semSubjects); //when ever a new subject is added
            print(
                "semsubjects3235 : \n${await SecureStorage().readSemSubjects()}");
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

  bool checkIfSubjectsAdded() {
    // print("******************************");
    // print(semSubjects.keys.contains(currSem));
    // print(semSubjects[currSem]!.isNotEmpty);
    //check for next sem because some students doesn't have marks and sem 1
    return (semSubjects.keys.contains(currSem + 1) &&
            semSubjects[currSem + 1]!.isNotEmpty) ||
        (semSubjects.keys.contains(currSem) &&
            semSubjects[currSem]!.isNotEmpty);
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
          } else if (!isLeftButton &&
              currSem < totalSem &&
              checkIfSubjectsAdded()) {
            currSem++;
          } else if (currSem == totalSem && checkIfSubjectsAdded()) {
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
