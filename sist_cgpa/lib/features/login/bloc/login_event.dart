part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class OnLogin extends LoginEvent {
  final bool useSaved;
  final String? regno;
  final String? dob;
  final String? erpPassword;

  OnLogin({
    required this.useSaved,
    this.regno,
    this.dob,
    this.erpPassword,
  });
}
