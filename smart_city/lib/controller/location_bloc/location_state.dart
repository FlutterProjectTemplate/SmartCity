part of 'location_bloc.dart';


class LocationState extends Equatable{
  final double latitude;
  final double longitude;
  final bool isPermissionGranted;

  const LocationState({
    required this.latitude,
    required this.longitude,
    required this.isPermissionGranted
  });

  factory LocationState.initial() => const LocationState(
    latitude: 0,
    longitude: 0,
    isPermissionGranted: false
  );

  LocationState copyWith({
    double? latitude,
    double? longitude,
    bool? isPermissionGranted
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, isPermissionGranted];
}