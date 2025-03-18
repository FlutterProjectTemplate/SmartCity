import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stopwatch_event.dart';
part 'stopwatch_state.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  static const int _tickDuration = 1; // 1-second tick
  Timer? _timer;

  StopwatchBloc() : super(StopwatchState(stateStatus: StopwatchStateStatus.initial, duration: 0)) {
    on<StartStopwatch>(_onStartStopwatch);
    on<StopStopwatch>(_onInProgressToStopStopwatch);
    on<ResetStopwatch>(_onResetStopwatch);
    on<TickStopwatch>(_onTickStopwatch);
    on<ResumeStopwatch>(_onResumeStopwatch);
    on<ServicingStopwatch>(_onServicingStopwatch);
    on<ChangeServicingToResumeStopwatch>(_onStopwatchChangeServicingToRunInProgress);

  }

  void _onStartStopwatch(StartStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: _tickDuration), (timer) {
      add(TickStopwatch((state.duration ??0)+ _tickDuration));
    });
    emit(state.copyWith(stateStatus: StopwatchStateStatus.runInProgress, duration: state.duration));
  }
  void _onInProgressToStopStopwatch(StopStopwatch event, Emitter<StopwatchState> emit) {
      _timer?.cancel();
      emit(state.copyWith(stateStatus: StopwatchStateStatus.runPause, duration: state.duration));
  }

  void _onServicingStopwatch(ServicingStopwatch event, Emitter<StopwatchState> emit) {
      emit(state.copyWith(stateStatus: StopwatchStateStatus.servicing, duration: state.duration));
  }

  void _onResetStopwatch(ResetStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      duration: 0,
      stateStatus: StopwatchStateStatus.initial,
    ));
  }

  void _onTickStopwatch(TickStopwatch event, Emitter<StopwatchState> emit) {
    state.duration = event.duration;
    emit(state);
  }

  void _onResumeStopwatch(ResumeStopwatch event, Emitter<StopwatchState> emit) {
    if (state.stateStatus ==  StopwatchStateStatus.runPause) {
      _timer = Timer.periodic(const Duration(seconds: _tickDuration), (timer) {
        add(TickStopwatch((state.duration??0) + _tickDuration));
      });
      emit(state.copyWith(stateStatus: StopwatchStateStatus.runInProgress, duration: state.duration));
    }
  }
  void _onStopwatchChangeServicingToRunInProgress(ChangeServicingToResumeStopwatch event, Emitter<StopwatchState> emit) {
    if(state.stateStatus== StopwatchStateStatus.servicing) {
      emit(state.copyWith(stateStatus: StopwatchStateStatus.runInProgress, duration: state.duration));
    }
  }
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
