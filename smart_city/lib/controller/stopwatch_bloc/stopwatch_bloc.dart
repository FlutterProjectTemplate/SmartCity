import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  static const int _tickDuration = 1; // 1-second tick
  Timer? _timer;

  StopwatchBloc() : super(const StopwatchInitial()) {
    on<StartStopwatch>(_onStartStopwatch);
    on<StopStopwatch>(_onStopStopwatch);
    on<ResetStopwatch>(_onResetStopwatch);
    on<TickStopwatch>(_onTickStopwatch);
    on<ResumeStopwatch>(_onResumeStopwatch);
  }

  void _onStartStopwatch(StartStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: _tickDuration), (timer) {
      add(TickStopwatch(state.duration + _tickDuration));
    });
    emit(StopwatchRunInProgress(state.duration));
  }

  void _onStopStopwatch(StopStopwatch event, Emitter<StopwatchState> emit) {
    if(state is StopwatchRunInProgress) {
      _timer?.cancel();
      emit(StopwatchRunPause(state.duration));
    }
  }

  void _onResetStopwatch(ResetStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    emit(const StopwatchInitial());
  }

  void _onTickStopwatch(TickStopwatch event, Emitter<StopwatchState> emit) {
    emit(StopwatchRunInProgress(event.duration));
  }

  void _onResumeStopwatch(ResumeStopwatch event, Emitter<StopwatchState> emit) {
    if(state is StopwatchRunPause) {
      _timer = Timer.periodic(const Duration(seconds: _tickDuration), (timer) {
        add(TickStopwatch(state.duration + _tickDuration));
      });
      emit(StopwatchRunInProgress(state.duration));
    }
  }


  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
