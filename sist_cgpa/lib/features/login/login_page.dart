import 'dart:convert';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../choose_branch/Choose_branch_page.dart';
import '../../constants.dart';
import '../../utilites/secure_storage.dart';
import '../../utilites/utils.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginpage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // var regnoController = TextEditingController(text: "41110198");
  // var dobController = TextEditingController(text: "26/11/2003");
  // var passwordController = TextEditingController(text: "Bhuvideva003");
  var regnoController = TextEditingController();
  var dobController = TextEditingController();
  var passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // () async => await secureStorage.deleteSecureData(authTokenKey);
    // () async => await secureStorage.deleteAll();
    getAuthenticationKey();
    FlutterNativeSplash.remove();
    super.initState();
  }

  Future<void> login() async {
    getAuthenticationKey(useSaved: false);
  }

  void getAuthenticationKey({bool useSaved = true}) async {
    SecureStorage secureStorage = SecureStorage();

    secureStorage = SecureStorage();
    var url = "https://erp.sathyabama.ac.in/erp/api/v1.0/MasterStudent/login";
    String? regno;
    String? dob;
    String? password;
    if (useSaved) {
      regno = await secureStorage.readSecureData(regnoKey);
      dob = await secureStorage.readSecureData(dobKey);
      password = await secureStorage.readSecureData(erpPasswordKey);
      if (regno.isEmpty || dob.isEmpty || password.isEmpty) return;
    } else {
      regno = regnoController.text;
      dob = dobController.text;
      password = passwordController.text;
      if (regno.isEmpty || dob.isEmpty || password.isEmpty) return;
    }

    print("regno : $regno");
    print("password : $password");

    var client = http.Client();
    var body = {
      "RegisterNumber": regno,
      "Password": password,
    };
    var response = await client.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data["message"] == "Success") {
        var token = data["responseData"]["login"]["accessToken"];
        var batch = data["responseData"]["login"]["Batch"] as String;
        var startyear = batch.substring(0, batch.indexOf("-"));
        var endyear = batch.substring(batch.indexOf("-") + 1);

        // print(token);
        await secureStorage.writeSecureData(regnoKey, regno);
        await secureStorage.writeSecureData(dobKey, dob);
        await secureStorage.writeSecureData(erpPasswordKey, password);
        await secureStorage.writeSecureData(authTokenKey, token);
        await secureStorage.writeSecureData(startYearKey, startyear);
        await secureStorage.writeSecureData(endYearKey, endyear);
        // print(await secureStorage.readSecureData(authTokenKey));
        if (mounted) {
          Navigator.of(context).popAndPushNamed(ChooseBranch.routeName);
        }
      } else {
        if (mounted) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Invalid register number or password",
            ),
          );
        }
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[300],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: logo(),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10.0,
                            ),
                            child: Text(
                              "Login for easy access",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 3, 8, 87)),
                            ),
                          ),
                        ),
                        customTextField(
                          hintText: "regiester number",
                          controller: regnoController,
                          validator: isvalidRegno,
                        ),
                        customTextField(
                            hintText: "date of birth",
                            controller: dobController,
                            validator: isValidDOBFormat),
                        customTextField(
                          hintText: "erp password",
                          controller: passwordController,
                          isPassword: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text("Login"),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .popAndPushNamed(ChooseBranch.routeName),
                          child: const Text(
                            "skip",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: const Text(
        "CGPA\ncalulator",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w900,
          color: Color.fromARGB(255, 3, 8, 87),
        ),
      ),
    );
  }

  String? noError(String? s) => null;

  Widget customTextField(
      {required String hintText,
      required TextEditingController controller,
      String? Function(String?)? validator,
      bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator ?? noError,
        obscureText: isPassword,
        decoration: InputDecoration(
          focusColor: Colors.white,
          fillColor: Colors.white,
          hintText: hintText,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
