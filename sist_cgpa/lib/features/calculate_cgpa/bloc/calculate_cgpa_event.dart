part of 'calculate_cgpa_bloc.dart';

@immutable
sealed class CalculateCgpaEvent {}

class LoadSubjects extends CalculateCgpaEvent {}

class CalculateGpa extends CalculateCgpaEvent {}

class CalculateCgpa extends CalculateCgpaEvent {}
