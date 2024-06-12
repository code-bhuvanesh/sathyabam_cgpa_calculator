// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sist_cgpa/models/subject.dart';

import '../../../utilites/sqlite_db.dart';

part 'add_page_event.dart';
part 'add_page_state.dart';

class AddSubjectBloc extends Bloc<AddSubjectEvent, AddSubjectState> {
  AddSubjectBloc() : super(AddPageInitial()) {
    on<SearchSubjectEvent>(searchSubjectsEvent);
  }

  Future<FutureOr<void>> searchSubjectsEvent(
    SearchSubjectEvent event,
    Emitter<AddSubjectState> emit,
  ) async {
    var subjectsList =await SqliteDB().searchSubject(event.searchText);
    emit(SearchResultState(subjectsList: subjectsList));

  }
}
