import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(""),
      ),
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
              onPressed: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  final appId = Platform.isAndroid
                      ? 'com.bhuvanesh.sist_cgpa'
                      : 'YOUR_IOS_APP_ID';
                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "market://details?id=$appId"
                        : "https://apps.apple.com/app/id$appId",
                  );
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
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
