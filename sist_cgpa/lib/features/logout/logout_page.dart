import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sist_cgpa/features/login/login_page.dart';
import 'package:sist_cgpa/utilites/secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});
  static const routeName = "/settings";

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  void logout() {
    SecureStorage().deleteAll();
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginPage.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Logout Page",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset("assets/icons/app_logo.png"),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: logout,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 5),
                    Text(
                      "logout",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const Text(
                "Credits\nDevloped By Bhuvanesh D\n(2021-2025) Batch",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Contact me on : ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         socialMediaButton(
              //           name: "Github",
              //           iconPath: "assets/icons/github_icon.png",
              //           onPressed: () {
              //             _launchURL(
              //               "https://github.com/code-bhuvanesh",
              //             );
              //           },
              //         ),
              //         socialMediaButton(
              //           name: "Linkedin",
              //           iconPath: "assets/icons/linkedin_icon.png",
              //           onPressed: () {
              //             _launchURL(
              //               "https://www.linkedin.com/in/bhuvanesh-devaraj/",
              //             );
              //           },
              //         ),
              //         socialMediaButton(
              //           name: "Instagram",
              //           iconPath: "assets/icons/instagram_icon.png",
              //           onPressed: () {
              //             _launchURL(
              //               "https://www.instagram.com/ambitious__guy/",
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //     const SizedBox(
              //       height: 25,
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialMediaIconButton(
                    name: "Github",
                    iconPath: "assets/icons/github_icon.png",
                    onPressed: () {
                      _launchURL(
                        "https://github.com/code-bhuvanesh",
                      );
                    },
                  ),
                  socialMediaIconButton(
                    name: "Linkedin",
                    iconPath: "assets/icons/linkedin_icon.png",
                    onPressed: () {
                      _launchURL(
                        "https://www.linkedin.com/in/bhuvanesh-devaraj/",
                      );
                    },
                  ),
                  socialMediaIconButton(
                    name: "Instagram",
                    iconPath: "assets/icons/instagram_icon.png",
                    onPressed: () {
                      _launchURL(
                        "https://www.instagram.com/ambitious__guy/",
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialMediaIconButton({
    required String name,
    required String iconPath,
    required void Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  iconPath,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget socialMediaButton({
    required String name,
    required String iconPath,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
            Text(
              name,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String webUrl) async {
    try {
      await launchUrl(Uri.parse(webUrl));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
