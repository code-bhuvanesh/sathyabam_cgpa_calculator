import 'package:cgpa_calculator/animations/page_transition_animation.dart';
import 'package:cgpa_calculator/pages/Choose_branch_page.dart';
import 'package:cgpa_calculator/pages/calculate_cgpa_page.dart';
import 'package:cgpa_calculator/pages/choose_course_page.dart';
import 'package:cgpa_calculator/pages/show_cgpa_page.dart';
import 'package:cgpa_calculator/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGPA CALCULATOR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ChooseBranch.routeName:
            return PageTransionAnim(
              builder: (context) => const ChooseBranch(),
            );
          case ChooseCourse.routeName:
            return PageTransionAnim(
              builder: (context) => ChooseCourse(
                args: settings.arguments as List<dynamic>,
              ),
            );
          case CalculateGpaPage.routeName:
            return PageTransionAnim(
              builder: (context) => CalculateGpaPage(
                data: settings.arguments as Map<String, dynamic>,
              ),
            );
          case ShowCgpa.routeName:
            return PageTransionAnim(
              builder: (context) => ShowCgpa(
                args: settings.arguments as List<dynamic>,
              ),
            );
          default:
            return PageTransionAnim(
              builder: (context) => const SplashScreen(),
            );
        }
      },
    );
  }
}
