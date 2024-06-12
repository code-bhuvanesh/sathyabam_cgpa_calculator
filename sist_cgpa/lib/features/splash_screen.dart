import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login/login_page.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splashScreen";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox.shrink(),
          Center(
              child: Column(
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "custom_font"),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "CGPA",
                      speed: const Duration(milliseconds: 200),
                    )
                  ],
                  totalRepeatCount: 1,
                  onFinished: () => Navigator.of(context)
                      .popAndPushNamed(LoginPage.routeName),
                  // textAlign: TextAlign.center,
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "custom_font"),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText("Calculator",
                        speed: const Duration(milliseconds: 100)),
                  ],
                  totalRepeatCount: 1,
                  // textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
          const Center(
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
