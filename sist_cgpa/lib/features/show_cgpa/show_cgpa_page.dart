import 'package:flutter/material.dart';

class ShowCgpa extends StatelessWidget {
  static const String routeName = "/showCgpa";
  const ShowCgpa({super.key, required this.cgpa});
  final double cgpa;

  @override
  Widget build(BuildContext context) {
    var transformedCgpa = (cgpa * 100).toInt();
    return Scaffold(
      body: Center(
        child: Text(
          " your cgpa is ${transformedCgpa / 100.0}",
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
