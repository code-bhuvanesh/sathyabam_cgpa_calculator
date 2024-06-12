import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sist_cgpa/features/login/bloc/login_bloc.dart';
import 'package:sist_cgpa/utilites/theme.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../calculate_cgpa/calculate_cgpa_page.dart';
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
  var dobController = TextEditingController(text: "26/11/2003");
  var passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // () async => await secureStorage.deleteSecureData(authTokenKey);
    // () async => await secureStorage.deleteAll();
    // getAuthenticationKey();
    context.read<LoginBloc>().add(
          OnLogin(
            useSaved: true,
          ),
        );
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSucess) {
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    CalculateGpaPage.routeName,
                    (Route<dynamic> route) => false,
                  );
                }
              } else if (state is LoginFailed) {
                if (mounted) {
                  showTopSnackBar(
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: "Invalid register number or password",
                    ),
                  );
                }
              }
            },
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
                                  // color: Color.fromARGB(255, 3, 8, 87),
                                ),
                              ),
                            ),
                          ),
                          customTextField(
                            hintText: "regiester number",
                            controller: regnoController,
                            validator: isvalidRegno,
                          ),
                          // customTextField(
                          //     hintText: "date of birth",
                          //     controller: dobController,
                          //     validator: isValidDOBFormat),
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
                                context.read<LoginBloc>().add(
                                      OnLogin(
                                        useSaved: false,
                                        regno: regnoController.text,
                                        dob: dobController.text,
                                        erpPassword: passwordController.text,
                                      ),
                                    );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text("Login"),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .popAndPushNamed(CalculateGpaPage.routeName),
                            child: const Text(
                              "skip",
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 114, 114),
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.all(50),
                            child: Text(
                              "Made by Bhuvanesh",
                              style: TextStyle(
                                // color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      padding: const EdgeInsets.symmetric(
          // vertical: 40,
          // horizontal: 100,
          ),
      child: Column(
        children: [
          SizedBox(
            // height: 150,
            // width: 150,
            child: Lottie.asset(
              "assets/hat_anim.json",
              height: MediaQuery.of(context).size.height * 0.13,
            ),
          ),
          const Text(
            "SIST CGPA",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w900,
              // color: Color.fromARGB(255, 3, 8, 87),
            ),
          ),
        ],
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
