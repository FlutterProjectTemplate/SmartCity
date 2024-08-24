part of 'map_bloc.dart';


class MapState extends Equatable {
  final MapType mapType;
  const MapState({this.mapType= MapType.normal});

  MapState copyWith({MapType? mapType}){
    return MapState(
      mapType: mapType ?? this.mapType
    );
  }

  @override
  List<Object> get props => [mapType];
}

