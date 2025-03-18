part of 'stopwatch_bloc.dart';

abstract class StopwatchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartStopwatch extends StopwatchEvent {}

class StopStopwatch extends StopwatchEvent {}

class ResumeStopwatch extends StopwatchEvent {}

class ResetStopwatch extends StopwatchEvent {}
class ServicingStopwatch extends StopwatchEvent {}
class ServicingToStopStopwatch extends StopwatchEvent {}

class ChangeServicingToResumeStopwatch extends StopwatchEvent {}

class TickStopwatch extends StopwatchEvent {
  final int duration;

  TickStopwatch(this.duration);

  @override
  List<Object> get props => [duration];
}

