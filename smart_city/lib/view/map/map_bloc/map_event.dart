part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}
class NormalMapEvent extends MapEvent{}

class SatelliteMapEvent extends MapEvent{}

class HybridMapEvent extends MapEvent{}

class TerrainMapEvent extends MapEvent{}
