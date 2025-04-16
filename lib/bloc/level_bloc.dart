library level_bloc; // Добавляем объявление библиотеки

import 'package:bloc/bloc.dart';

part 'level_event.dart';
part 'level_state.dart';

class CounterBloc extends Bloc<LevelEvent, LevelState> {
  CounterBloc() : super(const LevelState(0)) {
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
    on<ResetEvent>(_onReset);
  }

  void _onIncrement(IncrementEvent event, Emitter<LevelState> emit) {
    emit(LevelState(state.value + 1));
  }

  void _onDecrement(DecrementEvent event, Emitter<LevelState> emit) {
    emit(LevelState(state.value - 1));
  }

  void _onReset(LevelEvent event, Emitter<LevelState> emit) {
    emit(LevelState(0));
  }
}
