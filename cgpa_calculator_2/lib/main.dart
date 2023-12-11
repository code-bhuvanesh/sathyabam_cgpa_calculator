import 'package:flutter_native_splash/flutter_native_splash.dart';

import '/animations/page_transition_animation.dart';
import '/pages/Choose_branch_page.dart';
import '/pages/calculate_cgpa_page.dart';
import '/pages/choose_course_page.dart';
import '/pages/login_page.dart';
import '/pages/show_cgpa_page.dart';
import '/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cgpa calculator',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: LoginPage.routeName,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LoginPage.routeName:
            return PageTransionAnim(builder: (context) => const LoginPage());
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
              builder: (context) => const LoginPage(),
            );
        }
      },
    );
  }
}
