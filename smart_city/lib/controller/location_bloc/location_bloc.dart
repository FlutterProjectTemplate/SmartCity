import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:location/location.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final Location _location = Location();
  StreamSubscription<LocationData>?  _locationSubscription;
  LocationBloc() : super(LocationState.initial()){
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
  }

  Future<void> _onStartTracking(StartTracking event, Emitter<LocationState> emit)async{
    LocationData currentLocation = await _location.getLocation();
    emit(state.copyWith(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
      isPermissionGranted: true
    ));
  }

  void _onStopTracking(
      StopTracking event, Emitter<LocationState> emit) {
    _locationSubscription?.cancel();
    emit(state.copyWith(isPermissionGranted: false));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
