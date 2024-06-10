part of 'calculate_cgpa_bloc.dart';

@immutable
sealed class CalculateCgpaEvent {}

class LoadSubjects extends CalculateCgpaEvent {
  final String course;
  LoadSubjects({required this.course});
}

class CalculateGpa extends CalculateCgpaEvent {}

class CalculateCgpa extends CalculateCgpaEvent {}
