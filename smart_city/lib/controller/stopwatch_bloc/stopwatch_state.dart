part of 'stopwatch_bloc.dart';

enum StopwatchStateStatus{
  initial,
  runInProgress,
  runPause,
  servicing
}
class StopwatchState extends Equatable {
   StopwatchStateStatus? stateStatus;
   int? duration;
   StopwatchState({this.duration, this.stateStatus});
   StopwatchState copyWith({
     StopwatchStateStatus? stateStatus,
     int? duration
   })
   {
     return StopwatchState(
       duration: duration??this.duration,
       stateStatus: stateStatus??this.stateStatus,
     );
   }
  @override
  List<dynamic> get props => [duration, stateStatus];
}