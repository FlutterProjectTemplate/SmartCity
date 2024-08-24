part of 'stopwatch_bloc.dart';

sealed class StopwatchState extends Equatable {
  const StopwatchState(this.duration);
  final int duration;

  @override
  List<Object> get props => [duration];

}

final class StopwatchInitial extends StopwatchState {
  const StopwatchInitial():super(0);

  @override
  String toString() => 'StopwatchInitial { duration: $duration }';
}

final class StopwatchRunPause extends StopwatchState {
  const StopwatchRunPause(super.duration);

  @override
  String toString() => 'StopwatchRunPause { duration: $duration }';
}

final class StopwatchRunInProgress extends StopwatchState {
  const StopwatchRunInProgress(super.duration);

  @override
  String toString() => 'StopwatchRunInProgress { duration: $duration }';
}

