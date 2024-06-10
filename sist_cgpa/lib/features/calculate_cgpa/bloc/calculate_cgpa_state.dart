part of 'calculate_cgpa_bloc.dart';

@immutable
sealed class CalculateCgpaState {}

final class CalculateCgpaInitial extends CalculateCgpaState {}

class SubjectsLoaded extends CalculateCgpaState {
  final Map<String, List<SemSubject>> semSubjects;

  SubjectsLoaded({required this.semSubjects});
}

class GpaResutl extends CalculateCgpaState {}

class CgpaResult extends CalculateCgpaState {}
