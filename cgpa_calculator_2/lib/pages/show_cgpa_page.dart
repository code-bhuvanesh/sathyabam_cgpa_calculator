import 'package:flutter/material.dart';

class ShowCgpa extends StatelessWidget {
  static const String routeName = "/showCgpa";
  const ShowCgpa({super.key, required this.args});
  final List<dynamic> args;

  @override
  Widget build(BuildContext context) {
    String cgpa = args[0] as String;
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            " your cgpa is $cgpa",
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
