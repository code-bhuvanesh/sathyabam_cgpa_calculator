import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:sist_cgpa/utilites/adhelper.dart';

class ShowCgpa extends StatefulWidget {
  static const String routeName = "/showCgpa";
  const ShowCgpa({super.key, required this.cgpa});
  final double cgpa;

  @override
  State<ShowCgpa> createState() => _ShowCgpaState();
}

class _ShowCgpaState extends State<ShowCgpa> {
 
  @override
  Widget build(BuildContext context) {
    // var transformedCgpa = (cgpa * 100).toInt();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 20,
            ),
            Lottie.asset(
              'assets/anim/lottie_anim1.json',
              // controller: _controller,
            ),
            const SizedBox(
              height: 100,
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              color: Colors.black,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                alignment: Alignment.center,
                child: Text(
                  " Your CGPA is ${widget.cgpa.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Give your Feedback",
              ),
            )
          ],
        ),
      ),
    );
  }
}
