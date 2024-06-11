part of 'add_page_bloc.dart';

@immutable
sealed class AddSubjectEvent {}

class SearchSubjectEvent extends AddSubjectEvent {
  final String searchText;

  SearchSubjectEvent({required this.searchText});
}
