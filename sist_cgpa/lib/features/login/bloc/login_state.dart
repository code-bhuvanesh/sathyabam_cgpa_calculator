part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginSucess extends LoginState {}

class NoLoginCredentials extends LoginState {}
class LoginFailed extends LoginState {}
