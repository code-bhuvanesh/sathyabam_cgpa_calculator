import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cgpa_calculator/pages/Choose_branch_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splashScreen";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.shrink(),
          Center(
              child: Column(
            children: [
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "custom_font"),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "CGPA",
                      speed: Duration(milliseconds: 200),
                    )
                  ],
                  totalRepeatCount: 1,
                  onFinished: () => Navigator.of(context)
                      .popAndPushNamed(ChooseBranch.routeName),
                  // textAlign: TextAlign.center,
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "custom_font"),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText("Calculator",
                        speed: Duration(milliseconds: 100)),
                  ],
                  totalRepeatCount: 1,
                  // textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
          Center(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "created by: Bhuvanesh",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
