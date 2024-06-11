import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sist_cgpa/features/add_subjects/add_subjects_page.dart';
import 'package:sist_cgpa/features/add_subjects/bloc/add_page_bloc.dart';
import 'package:sist_cgpa/features/login/bloc/login_bloc.dart';
import 'package:sist_cgpa/features/settings/settings_page.dart';
import 'package:sist_cgpa/utilites/sqlite_db.dart';

import '/animations/page_transition_animation.dart';
import 'features/calculate_cgpa/bloc/calculate_cgpa_bloc.dart';
import 'features/choose_branch/Choose_branch_page.dart';
import 'features/calculate_cgpa/calculate_cgpa_page.dart';
import 'features/choose_course/choose_course_page.dart';
import 'features/login/login_page.dart';
import 'features/show_cgpa/show_cgpa_page.dart';
import 'features/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //initialize DB
  SqliteDB().initializeDatabase();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Set your desired color here
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sist cgpa',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: LoginPage.routeName,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LoginPage.routeName:
            return PageTransionAnim(
              builder: (context) => BlocProvider(
                create: (context) => LoginBloc(),
                child: const LoginPage(),
              ),
            );
          case ChooseBranch.routeName:
            return PageTransionAnim(
              builder: (context) => const ChooseBranch(),
            );
          case ChooseCourse.routeName:
            return PageTransionAnim(
              builder: (context) => ChooseCourse(
                branch: settings.arguments as String,
              ),
            );
          case AddSubjectsPage.routeName:
            return PageTransionAnim(
              builder: (context) => BlocProvider(
                create: (context) => AddSubjectBloc(),
                child: const AddSubjectsPage(),
              ),
            );
          case CalculateGpaPage.routeName:
            return PageTransionAnim(
              builder: (context) => BlocProvider(
                create: (context) => CalculateCgpaBloc(),
                child: const CalculateGpaPage(),
              ),
            );
          case ShowCgpa.routeName:
            return PageTransionAnim(
              builder: (context) => ShowCgpa(
                cgpa: settings.arguments as double,
              ),
            );
          case SetttingsPage.routeName:
            return PageTransionAnim(
              builder: (context) => const SetttingsPage(),
            );
          default:
            return PageTransionAnim(
              builder: (context) => BlocProvider(
                create: (context) => LoginBloc(),
                child: const LoginPage(),
              ),
            );
        }
      },
    );
  }
}
