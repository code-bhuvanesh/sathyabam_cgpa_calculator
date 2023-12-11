import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'calculate_cgpa_event.dart';
part 'calculate_cgpa_state.dart';

class CalculateCgpaBloc extends Bloc<CalculateCgpaEvent, CalculateCgpaState> {
  CalculateCgpaBloc() : super(CalculateCgpaInitial()) {
    on<CalculateCgpaEvent>((event, emit) {
      
    });
  }
}
