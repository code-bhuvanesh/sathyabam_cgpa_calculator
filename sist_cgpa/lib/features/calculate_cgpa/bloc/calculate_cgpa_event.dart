part of 'calculate_cgpa_bloc.dart';

@immutable
sealed class CalculateCgpaEvent {}

class LoadSubjects extends CalculateCgpaEvent {
  LoadSubjects();
}

class CalculateGpa extends CalculateCgpaEvent {
  final List<SemSubject> subjects;

  CalculateGpa({required this.subjects});
}

class CalculateCgpa extends CalculateCgpaEvent {
  final Map<int, List<SemSubject>> semsubjects;

  CalculateCgpa({required this.semsubjects});
}
