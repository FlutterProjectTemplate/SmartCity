part of 'stopwatch_bloc.dart';

sealed class StopwatchState extends Equatable {
   StopwatchState(this.duration);

  int duration;

  @override
  List<Object> get props => [duration];
}

final class StopwatchInitial extends StopwatchState {
   StopwatchInitial() : super(0);

  @override
  String toString() => 'StopwatchInitial { duration: $duration }';
}

final class StopwatchRunPause extends StopwatchState {
   StopwatchRunPause(super.duration);

  @override
  String toString() => 'StopwatchRunPause { duration: $duration }';
}

final class StopwatchRunInProgress extends StopwatchState {
   StopwatchRunInProgress(super.duration);

  @override
  String toString() => 'StopwatchRunInProgress { duration: $duration }';
}

final class StopwatchServicing extends StopwatchState {
   StopwatchServicing(super.duration);

  @override
  String toString() => 'StopwatchRunInProgress { duration: $duration }';
}
