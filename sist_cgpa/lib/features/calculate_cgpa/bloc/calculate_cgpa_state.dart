part of 'calculate_cgpa_bloc.dart';

@immutable
sealed class CalculateCgpaState {}

final class CalculateCgpaInitial extends CalculateCgpaState {}

class SubjectsLoaded extends CalculateCgpaState {
  final Map<int, List<SemSubject>> semSubjects;

  SubjectsLoaded({required this.semSubjects});
}
class FailedToLoadSubjects extends CalculateCgpaState{}

class GpaResult extends CalculateCgpaState {
  final double gpa;

  GpaResult({required this.gpa});
}

class CgpaResult extends CalculateCgpaState {
  final double cgpa;

  CgpaResult({required this.cgpa});
}
