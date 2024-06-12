import 'package:flutter/material.dart';
import 'package:sist_cgpa/features/login/login_page.dart';
import 'package:sist_cgpa/utilites/secure_storage.dart';

class SetttingsPage extends StatefulWidget {
  const SetttingsPage({super.key});
  static const routeName = "/settings";

  @override
  State<SetttingsPage> createState() => _SetttingsPageState();
}

class _SetttingsPageState extends State<SetttingsPage> {
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
          "Settings",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Credits\nDevloped By Bhuvanesh (2021-2025) Batch",
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: logout,
              child: const Text(
                "logout",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
