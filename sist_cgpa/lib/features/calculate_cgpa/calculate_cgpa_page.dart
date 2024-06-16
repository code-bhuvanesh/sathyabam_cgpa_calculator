import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sist_cgpa/features/add_subjects/add_subjects_page.dart';
import 'package:sist_cgpa/features/calculate_cgpa/bloc/calculate_cgpa_bloc.dart';
import 'package:sist_cgpa/features/logout/logout_page.dart';
import 'package:sist_cgpa/features/show_cgpa/show_cgpa_page.dart';
import 'package:sist_cgpa/models/sem_subject.dart';
import 'package:sist_cgpa/utilites/theme.dart';

import '../../utilites/adhelper.dart';
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
    loadFullScreenAd();
    loadBannerAd();
    context.read<CalculateCgpaBloc>().add(LoadSubjects());
    WidgetsBinding.instance.addPostFrameCallback((_) => showEnsureDialog());
  }

  @override
  void dispose() {
    if (_bannerAd != null) _bannerAd!.dispose();
    if (_interstitialAd != null) _interstitialAd!.dispose();
    super.dispose();
  }

  BannerAd? _bannerAd;
  bool _isADLoaded = false;

  /// Loads a banner ad.
  void loadBannerAd() {
    try {
      _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            setState(() {
              _isADLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
          },
        ),
      )..load();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  InterstitialAd? _interstitialAd;
  void loadFullScreenAd() {
    try {
      InterstitialAd.load(
        adUnitId: AdHelper.fullscreenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
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
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Ensure all the subjects are listed in all the semester to calculate CGPA properly.\nThere may be some missing subjects",
                  style: TextStyle(
                    fontSize: 16,
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
          "CGPA calculator",
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
            await SecureStorage().saveSemSubjects(
                semSubjects); //when ever a new subject is added
          } else if (state is CgpaResult) {
            loadFullScreenAd();
            if (_interstitialAd != null) {
              await _interstitialAd!.show();
            }
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
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            if (_isADLoaded) {
                              // _bannerAd!.load();
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: SafeArea(
                                  child: SizedBox(
                                    width: _bannerAd!.size.width.toDouble(),
                                    height: _bannerAd!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd!),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          } else {
                            var semSubject = semSubjects[currSem]![index - 1];

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
                          }
                        },
                        itemCount: semSubjects[currSem]!.length + 1,
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
          loadBannerAd();
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
            );
          }
          if (isLeftButton && currSem > 1) {
            currSem--;
          } else if (!isLeftButton && currSem < totalSem) {
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
