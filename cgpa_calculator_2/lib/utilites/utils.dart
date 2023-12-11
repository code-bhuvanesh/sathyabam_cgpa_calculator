import 'dart:convert';

import 'package:cgpa_calculator_2/constants.dart';
import 'package:cgpa_calculator_2/utilites/secure_storage.dart';
import 'package:http/http.dart' as http;

String? isValidDOBFormat(String? str) {
  if (str != null && str.isEmpty) {
    return "dob cannot be empty";
  }
  RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  if (regex.hasMatch(str!)) {
    return null;
  } else {
    return "not valid dob";
  }
}

String? isvalidRegno(String? str) {
  if (str != null && str.isEmpty) {
    return "regno cannot be empty";
  }
  return RegExp(r'^[0-9]+$').hasMatch(str!)
      ? null
      : "it is not a valid regiester number";
}

Future<String> getAuthToken() async {
  var url = "https://erp.sathyabama.ac.in/erp/api/v1.0/MasterStudent/login";
  var regno = await SecureStorage().readSecureData(regnoKey);
  var password = await SecureStorage().readSecureData(erpPasswordKey);
  var client = http.Client();
  var body = {
    "RegisterNumber": regno,
    "Password": password,
  };
  var response = await client.post(Uri.parse(url), body: body);
  var data = jsonDecode(response.body) as Map<String, dynamic>;
  if (data["message"] == "Success") {
    return data["responseData"]["login"]["accessToken"];
  }
  return "";
}

String removeMultipleSpace(String str) {
  RegExp regex = RegExp(r'\s+');
  return str.replaceAll(regex, " ");
}
