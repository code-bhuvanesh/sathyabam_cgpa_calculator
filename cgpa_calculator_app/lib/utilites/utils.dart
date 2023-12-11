
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
