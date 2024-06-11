part of 'add_page_bloc.dart';

@immutable
sealed class AddSubjectState {}

final class AddPageInitial extends AddSubjectState {}

class SearchResultState extends AddSubjectState {
  final List<Subject> subjectsList;

  SearchResultState({required this.subjectsList});
}
