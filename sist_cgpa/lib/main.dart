import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sist_cgpa/features/add_subjects/add_subjects_page.dart';
import 'package:sist_cgpa/features/add_subjects/bloc/add_page_bloc.dart';
import 'package:sist_cgpa/features/login/bloc/login_bloc.dart';
import 'package:sist_cgpa/features/settings/settings_page.dart';
import 'package:sist_cgpa/utilites/sqlite_db.dart';
import 'package:sist_cgpa/utilites/theme.dart';

import '/animations/page_transition_animation.dart';
import 'features/calculate_cgpa/bloc/calculate_cgpa_bloc.dart';
import 'features/choose_branch/choose_branch_page.dart';
import 'features/calculate_cgpa/calculate_cgpa_page.dart';
import 'features/choose_course/choose_course_page.dart';
import 'features/login/login_page.dart';
import 'features/show_cgpa/show_cgpa_page.dart';
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

  static const Map<int, Color> blackSwatch = {
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(0xFF9E9E9E),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
  };
  static const MaterialColor blackColor =
      MaterialColor(0xFF000000, blackSwatch);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sist cgpa',
      theme: ThemeData(
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(66, 26, 26, 26);
              } else if (states.contains(MaterialState.hovered)) {
                return Colors.black87;
              } else if (states.contains(MaterialState.focused)) {
                return Colors.black;
              } else {
                return Colors.black;
              }
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) {
              return Colors.white;
            },
          ),
        )),

        primarySwatch: blackColor,
        // useMaterial3: true,
      ),
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
