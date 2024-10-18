import 'dart:async';
import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../utilites/secure_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<OnLogin>(onLogin);
  }

  Future<FutureOr<void>> onLogin(
      OnLogin event, Emitter<LoginState> emit) async {
    SecureStorage secureStorage = SecureStorage();

    secureStorage = SecureStorage();
    var url = "https://erp.sathyabama.ac.in/erp/api/v1.0/MasterStudent/login";
    String? regno;
    String? dob;
    String? password;
    if (event.useSaved) {
      regno = await secureStorage.readSecureData(regnoKey);
      dob = await secureStorage.readSecureData(dobKey);
      password = await secureStorage.readSecureData(erpPasswordKey);
      if (regno.isEmpty || dob.isEmpty || password.isEmpty) {
        emit(NoLoginCredentials());
      }
    } else {
      regno = event.regno!;
      dob = event.dob!;
      password = event.erpPassword!;
      if (regno.isEmpty || dob.isEmpty || password.isEmpty) {
        emit(NoLoginCredentials());
      }
    }

    debugPrint("regno : $regno");
    debugPrint("password : $password");

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

        // debugPrint(token);
        await secureStorage.writeSecureData(regnoKey, regno);
        await secureStorage.writeSecureData(dobKey, dob);
        await secureStorage.writeSecureData(erpPasswordKey, password);
        await secureStorage.writeSecureData(authTokenKey, token);
        await secureStorage.writeSecureData(startYearKey, startyear);
        await secureStorage.writeSecureData(endYearKey, endyear);

        //due to some unkown subject not loading bug i am doing logout once and then again logging in
        await secureStorage.deleteSecureData(regnoKey);
        await secureStorage.deleteSecureData(dobKey);
        await secureStorage.deleteSecureData(erpPasswordKey);
        await secureStorage.deleteSecureData(authTokenKey);
        await secureStorage.deleteSecureData(startYearKey);
        await secureStorage.deleteSecureData(endYearKey);
        // debugPrint(token);
        await secureStorage.writeSecureData(regnoKey, regno);
        await secureStorage.writeSecureData(dobKey, dob);
        await secureStorage.writeSecureData(erpPasswordKey, password);
        await secureStorage.writeSecureData(authTokenKey, token);
        await secureStorage.writeSecureData(startYearKey, startyear);
        await secureStorage.writeSecureData(endYearKey, endyear);

        emit(LoginSucess());
        // debugPrint(await secureStorage.readSecureData(authTokenKey));
      } else {
        if (!event.useSaved) {
          emit(LoginFailed());
        } else {
          emit(NoLoginCredentials());
        }
      }
    } else {}
  }
}
